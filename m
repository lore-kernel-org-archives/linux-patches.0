Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB61E2834;
	Wed, 25 Feb 2026 01:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983075; cv=none; b=RsTNw0dTp0q3Wi2pprVnYSKvU9VAAQOUhN1PdQ6uNMpU1Au/QKqLDbvkMqf11Y4m4Fano7bM0aSmyDzQtmOpe6Envs0Hdx3up3b27Vs2LJAHzZ0VUhZJQvlN09073n+UQe2Njm5fs1ubuU2E/TfwsfGdQ2FG9FbXNHB8UMnfeP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983075; c=relaxed/simple;
	bh=MTmW2xsNeGczH0qU3JU7jx1tU1jR+0X3Yzu7xfRalhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV7mFf2GM0QCEy94VhBvNxotZn2XCJgENRKA0jXZdqDUYPmeW5+/UQR+fkA2orL9kJ8gFcqsEFzlLg+bAes5WGlYNR/9lTilvPFFR0tu/qBryAInDxqp3l8H95xpV/rsm3JWC++w2KnOfAQOKseao9RGWIQztm3A8PMz0ClEaFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjdCilHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjdCilHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CC0C116D0;
	Wed, 25 Feb 2026 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983074;
	bh=MTmW2xsNeGczH0qU3JU7jx1tU1jR+0X3Yzu7xfRalhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjdCilHqtnRZ3F8MPX6aO7644mZ8NOIAaxX/JSVF+CtdGN0nmV+hE5vOHhIO1oOXQ
	 wNnSdtgevUQaHTbH7e00Jep4axRcnL3dT0QzpdjwUgb/miy6369Ntjp2qg+SVlJyQ1
	 HN/R1fwI+wdpCC9kkruSQ07bkV25qeMlhWOeo484=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 236/781] media: chips-media: wave5: Fix memory leak on codec_info allocation failure
Date: Tue, 24 Feb 2026 17:15:45 -0800
Message-ID: <20260225012405.497087698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit a519e21e32398459ba357e67b541402f7295ee1b ]

In wave5_vpu_open_enc() and wave5_vpu_open_dec(), a vpu instance is
allocated via kzalloc(). If the subsequent allocation for inst->codec_info
fails, the functions return -ENOMEM without freeing the previously
allocated instance, causing a memory leak.

Fix this by calling kfree() on the instance in this error path to ensure
it is properly released.

Fixes: 9707a6254a8a6 ("media: chips-media: wave5: Add the v4l2 layer")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c | 4 +++-
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index e3038c18ca362..a4387ed58cac3 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1753,8 +1753,10 @@ static int wave5_vpu_open_dec(struct file *filp)
 	spin_lock_init(&inst->state_spinlock);
 
 	inst->codec_info = kzalloc(sizeof(*inst->codec_info), GFP_KERNEL);
-	if (!inst->codec_info)
+	if (!inst->codec_info) {
+		kfree(inst);
 		return -ENOMEM;
+	}
 
 	v4l2_fh_init(&inst->v4l2_fh, vdev);
 	v4l2_fh_add(&inst->v4l2_fh, filp);
diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
index 9bfaa9fb3ceb3..94fb5d7c87021 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -1578,8 +1578,10 @@ static int wave5_vpu_open_enc(struct file *filp)
 	inst->ops = &wave5_vpu_enc_inst_ops;
 
 	inst->codec_info = kzalloc(sizeof(*inst->codec_info), GFP_KERNEL);
-	if (!inst->codec_info)
+	if (!inst->codec_info) {
+		kfree(inst);
 		return -ENOMEM;
+	}
 
 	v4l2_fh_init(&inst->v4l2_fh, vdev);
 	v4l2_fh_add(&inst->v4l2_fh, filp);
-- 
2.51.0



