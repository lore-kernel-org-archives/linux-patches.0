Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544B815218A;
	Tue,  2 Jul 2024 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940314; cv=none; b=rgGswdk9mL2ioqVD7OeZo/e47E9xSFsVAOzA96aUiHPNIk8XKd617z0H/9T9goFz53lC1KqxvTCrWj8dXN+F4OTWn2kqnAMUwjvhQqB/lLCoWRpMQu/b0VnnVxbxENoZ4PQRWtK8yxZlP6NHcxyfP62hmdLwO+3ZOR4KthkiJFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940314; c=relaxed/simple;
	bh=5t0RyREuQ9zsH0143+R1R8Uh2XxRivtbAL5kACEd9tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ix0nJ29F1p/8hG5P3urIiay1swgemfwG0DbwsAnedabLw81CsuKikixjfBymJwgpkrGSqvPyxKTozCOcDbIBCOmG+jUNN56XP5tU5SNBNMwb3hiWccPRSOadUkARuujGaiWsRnXsIVMKKCzqWRYtnHTfyeU3ywV32QCgYzomI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WSd9brr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WSd9brr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2D4C116B1;
	Tue,  2 Jul 2024 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940314;
	bh=5t0RyREuQ9zsH0143+R1R8Uh2XxRivtbAL5kACEd9tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WSd9brrLDuCQn9Fi1MD5bE6vZUSfPDxxx5p7XiBC6FQceiw6QwDZ8o4EVe3ZP71v
	 Q6S3A4tFpvnlkgDfMP+rvsL+zwq3kZ0DaW0LbOfYthIjHx/CHeSVT1n1z2AowZdJoq
	 CEBldcOIa4rpAp/WZydU5xiT+9zHd5O+Im1hkcvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 086/222] media: dvbdev: Initialize sbuf
Date: Tue,  2 Jul 2024 19:02:04 +0200
Message-ID: <20240702170247.264321585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 17d1316de0d7dc1bdc5d6e3ad4efd30a9bf1a381 ]

Because the size passed to copy_from_user() cannot be known beforehand,
it needs to be checked during runtime with check_object_size. That makes
gcc believe that the content of sbuf can be used before init.

Fix:
./include/linux/thread_info.h:215:17: warning: ‘sbuf’ may be used uninitialized [-Wmaybe-uninitialized]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 733d0bc4b4cc3..b43695bc51e75 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -956,7 +956,7 @@ int dvb_usercopy(struct file *file,
 		 int (*func)(struct file *file,
 			     unsigned int cmd, void *arg))
 {
-	char    sbuf[128];
+	char    sbuf[128] = {};
 	void    *mbuf = NULL;
 	void    *parg = NULL;
 	int     err  = -EINVAL;
-- 
2.43.0



