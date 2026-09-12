Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5A92F9D82;
	Sat, 12 Sep 2026 07:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198385; cv=none; b=fZcl4031mut61riZTdzwd7zDiUCOcnulr5p3tTBOBffTsbTJeg0mZBooGCnSQV7nef5LiQhNFdb6iwxTwPigFfEJi6ysMZPysncJZIF55qAdz38JvYY0med+SoIyLQ2OSH5wVdJPj6WyCAf+PS2sqYcRiiQR27bO+j3mjiRy0g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198385; c=relaxed/simple;
	bh=7bRHWUlizZg2myO7Fyb3+psa/49nhvIGC+EhHaxH1qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzfkRZqzuMgzvHw0x4YVjH0M7OtNsOMtD/mz3PMJ4hCGRC7741DpzYXLK5bLg3o7k17PfzRXaELpNeepWB7F0qsktyKQJtoGGgrUqiMLTQDwYz1VPJVoiSbjZD5PRqgwsX9n3ywgsxIbUkGj8Ddpj3Fa8Bg2O/NQms3/73zBDn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seQG8GBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seQG8GBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AB91F000FF;
	Sat, 12 Sep 2026 07:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198384;
	bh=3oFY/yknQtyiYxHid4P2AqDtUk7xbKf2g4d07+yyYcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seQG8GBmRV5AHLXAer6WemmMkr3/PTCZfWNr/sDHnf2YwpRRUrP/kfEfDpSdmbfbo
	 77W/9VK4QEjFHXwYnKi0HQReV9PiKp6rHAUf2VH/GYrS35fd4qcFpDkci5ZtokfSKJ
	 Y7eqnKkU8961Hrdov2u+YdKzEfiSJbv3BWtp70Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Pratap Nirujogi <pratap.nirujogi@amd.com>,
	Bin Du <bin.du@amd.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0316/1815] media: platform: amd: use refcount_t instead of atomic_t
Date: Sat, 12 Sep 2026 08:34:26 +0200
Message-ID: <20260912065656.357683927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 0baf8f42110b7c361bb3f6a8a78c0958a23e4e32 ]

We are using the refcnt variable for refcounting. Use the refcount_t
type instead, as it has support for saturation and underflow.

This also makes cocci happier, as it will fix the following warning:
./platform/amd/isp4/isp4_subdev.c:394:6-25: WARNING: atomic_dec_and_test variation before object free at line 395.

Fixes: 4c5feef6a62c ("media: platform: amd: Add isp4 fw and hw interface")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Pratap Nirujogi <pratap.nirujogi@amd.com>
Reviewed-by: Bin Du <bin.du@amd.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amd/isp4/isp4_interface.c | 4 ++--
 drivers/media/platform/amd/isp4/isp4_interface.h | 2 +-
 drivers/media/platform/amd/isp4/isp4_subdev.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amd/isp4/isp4_interface.c b/drivers/media/platform/amd/isp4/isp4_interface.c
index 8d73f66bb42cb..00a8179092921 100644
--- a/drivers/media/platform/amd/isp4/isp4_interface.c
+++ b/drivers/media/platform/amd/isp4/isp4_interface.c
@@ -375,7 +375,7 @@ static int isp4if_send_fw_cmd(struct isp4_interface *ispif, u32 cmd_id,
 			return -ENOMEM;
 
 		/* Get two references: one for the resp thread, one for us */
-		atomic_set(&ele->refcnt, 2);
+		refcount_set(&ele->refcnt, 2);
 		init_completion(&ele->cmd_done);
 	}
 
@@ -455,7 +455,7 @@ static int isp4if_send_fw_cmd(struct isp4_interface *ispif, u32 cmd_id,
 
 put_ele_ref:
 	/* Don't free the command if we didn't put the last reference */
-	if (ele && atomic_dec_return(&ele->refcnt))
+	if (ele && !refcount_dec_and_test(&ele->refcnt))
 		ele = NULL;
 
 free_ele:
diff --git a/drivers/media/platform/amd/isp4/isp4_interface.h b/drivers/media/platform/amd/isp4/isp4_interface.h
index ce3ac9b9e5cda..04db71cd54e6c 100644
--- a/drivers/media/platform/amd/isp4/isp4_interface.h
+++ b/drivers/media/platform/amd/isp4/isp4_interface.h
@@ -68,7 +68,7 @@ struct isp4if_cmd_element {
 	u32 seq_num;
 	u32 cmd_id;
 	struct completion cmd_done;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 struct isp4_interface {
diff --git a/drivers/media/platform/amd/isp4/isp4_subdev.c b/drivers/media/platform/amd/isp4/isp4_subdev.c
index 48deea79ce6c2..2a8bc12078434 100644
--- a/drivers/media/platform/amd/isp4/isp4_subdev.c
+++ b/drivers/media/platform/amd/isp4/isp4_subdev.c
@@ -391,7 +391,7 @@ static void isp4sd_fw_resp_cmd_done(struct isp4_subdev *isp_subdev,
 
 	if (ele) {
 		complete(&ele->cmd_done);
-		if (atomic_dec_and_test(&ele->refcnt))
+		if (refcount_dec_and_test(&ele->refcnt))
 			kfree(ele);
 	}
 }
-- 
2.53.0



