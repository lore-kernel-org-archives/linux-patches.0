Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B358161;
	Thu, 13 Jun 2024 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282425; cv=none; b=hXS23NtHISRa70blTVs5hMsa5p+8Y/kxr9ZFBzrkDqozakVdEwoFHq/CYHm88vKyoTJ3HKnB73jnzWjZISFtSLTWVdhSdnZ9JE82x/Q/IJnRTwwNg945OBl9Mc2y/oU121vnYQmpEqyiB3vw0nrunlCA3HCE82XCrbEm9aV4T0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282425; c=relaxed/simple;
	bh=hWndqZ6PhTt7ynk7D4F6QLB67xLZdVZCamZ2O5HuN0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDnauobquuJzHfBINzdKkkhr7wF7F+pxqTOjhCtYsHhMQaDzvIbhirRWrdkatYvYiG4w3F+KDHpO9rJpjK1STgLyYjvcYMqXBBc3gIGs2n8HNivazpEzLwipr6qwOQ1fK+P+32FKnG6vBZhE/EXxPE2zZYLh6hmqjF/JBmWtxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0VIghxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0VIghxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AAEC2BBFC;
	Thu, 13 Jun 2024 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282424;
	bh=hWndqZ6PhTt7ynk7D4F6QLB67xLZdVZCamZ2O5HuN0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0VIghxXUZ3QFjyGc7uHdeugdfafanna6cYwYDpGyOIdxJZN5vkBCCPz2OOyiWu0R
	 GJGAyFkk/QlEhBSu8oR2pOTDwErWDESzQDAEJb7WGG2REdBgXyECFlCwbsIJGr+YIj
	 JkbBpVKkPLnSAIv9OLKsrlL8a2CvdoIYwiHYTS/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.15 272/402] media: cec: cec-api: add locking in cec_release()
Date: Thu, 13 Jun 2024 13:33:49 +0200
Message-ID: <20240613113312.762819479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 42bcaacae924bf18ae387c3f78c202df0b739292 ]

When cec_release() uses fh->msgs it has to take fh->lock,
otherwise the list can get corrupted.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: ca684386e6e2 ("[media] cec: add HDMI CEC framework (api)")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/cec/core/cec-api.c b/drivers/media/cec/core/cec-api.c
index 52c30e4e20055..4510a4bec659a 100644
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -678,6 +678,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&data->xfer_list);
 	}
 	mutex_unlock(&adap->lock);
+
+	mutex_lock(&fh->lock);
 	while (!list_empty(&fh->msgs)) {
 		struct cec_msg_entry *entry =
 			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
@@ -695,6 +697,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 			kfree(entry);
 		}
 	}
+	mutex_unlock(&fh->lock);
 	kfree(fh);
 
 	cec_put_device(devnode);
-- 
2.43.0



