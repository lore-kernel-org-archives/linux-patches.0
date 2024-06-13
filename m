Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823A2143C6F;
	Thu, 13 Jun 2024 11:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279020; cv=none; b=N7ruC0+NpoGVHly85t+qaoV5KMx4s8o5hJ3i5n0V7VQ+h4dLfn0ba/Mf4POhBK/HI3z6GSGCCPeMrZhT4ZUT/zQoeNF4OFw1ySmNZMGSrKqcsulzLotQrgYYC9ut2pejnBeWWxyd/wQBaXbl2MjYSRub45o7qp1yGkBHR6ufaTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279020; c=relaxed/simple;
	bh=jhsfw6jl8E7JL8Kr/e0H/qqU9LDE6M9DnQ/Z/AoNdYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcGQIQGlfwqnjV9zctJ2onFB/ErrWI/1MrSnQqgF+4k9cKIFXE7huFFwzY0JQr2ZcXUc3E6xmSzbQv2HBLtWjJwk93PHRktrr++w84kGxe9++Hdk5lMJb85uB3blpf0liPxyLeUY9xYbtHfMQYlIqLB2QvQLK5MHEbYUieBhTkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+ZluFKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+ZluFKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098D1C2BBFC;
	Thu, 13 Jun 2024 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279020;
	bh=jhsfw6jl8E7JL8Kr/e0H/qqU9LDE6M9DnQ/Z/AoNdYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+ZluFKNjeQIGdk72kvw7a/7oIaykNT39ol1p/BBPPPPeavcoFqd/Vjq+k/DDJlC/
	 76E735jpXUIqqoZA1Ektj9WXdRI1AdWbQloZB9DHzlp2KW2eUhW355Omu2ZXTHOLwt
	 uV0ikftU9u/5URe6APW2nq1q+6nuh6Y9IUX/Si/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 4.19 118/213] media: cec: cec-api: add locking in cec_release()
Date: Thu, 13 Jun 2024 13:32:46 +0200
Message-ID: <20240613113232.551537106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b2b3f779592fd..d4c848c2f3764 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -660,6 +660,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 		list_del(&data->xfer_list);
 	}
 	mutex_unlock(&adap->lock);
+
+	mutex_lock(&fh->lock);
 	while (!list_empty(&fh->msgs)) {
 		struct cec_msg_entry *entry =
 			list_first_entry(&fh->msgs, struct cec_msg_entry, list);
@@ -677,6 +679,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 			kfree(entry);
 		}
 	}
+	mutex_unlock(&fh->lock);
 	kfree(fh);
 
 	cec_put_device(devnode);
-- 
2.43.0



