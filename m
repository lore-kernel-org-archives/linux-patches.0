Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A61214535F;
	Thu, 13 Jun 2024 12:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280074; cv=none; b=BVMIBQ3zoVrIxYf7/Ye1EtIg1WvBnL5QNmWq619DPNgKClYIqJ3jbh9YoPsDwlgmrwGTsNlJcboxuRKlg29gvP11uyPnoKtnpGbdC22FDYRXNXHKXmPMGDFKTS5m91cZk5vJ/LrD4Mq6Jx/6xEESrJkNzraVV2vSVErHEaHLeZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280074; c=relaxed/simple;
	bh=kwRO0IxtUvrncdKET2YciifBWel07thNq8dROQtoaos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov8acMlHlTD5xD7b6WFYIRaqjC2RWXhPlGrznhDnMqnbb31NNexESvk3dFPjGO8iq3DAa7E8NBvbPQXD0H3+awRVy9lnD79/+bnI5Vmm57/pQQUMn0rtzXmmK7QqmKD0NTmdFpbp9FrWiSAnrmosngPKpX3Yv6oeKvnaDLVm+t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/pwilTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/pwilTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5685C4AF1A;
	Thu, 13 Jun 2024 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280074;
	bh=kwRO0IxtUvrncdKET2YciifBWel07thNq8dROQtoaos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/pwilTbzlU9ZPTtcBpODsGywAyT5YqAz+C9B+jYGJSY/7ESDuWLX9vAGaS423YeM
	 sBrD7lrVM33k9i+v1hwR73+cpAe3JtQuhe+O5Iody9hKDd0ZhTO7TLH0a4tLMmpB7H
	 Qtbm86SuwkoAaSGp0PLY/JPderv03Qjx5Vs8ik58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 5.4 134/202] media: cec: cec-api: add locking in cec_release()
Date: Thu, 13 Jun 2024 13:33:52 +0200
Message-ID: <20240613113232.933259601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/cec/cec-api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index ed75636a6fb34..90e90234f5bd8 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -652,6 +652,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&data->xfer_list);
 	}
 	mutex_unlock(&adap->lock);
+
+	mutex_lock(&fh->lock);
 	while (!list_empty(&fh->msgs)) {
 		struct cec_msg_entry *entry =
 			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
@@ -669,6 +671,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 			kfree(entry);
 		}
 	}
+	mutex_unlock(&fh->lock);
 	kfree(fh);
 
 	cec_put_device(devnode);
-- 
2.43.0



