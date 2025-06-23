Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5867080E;
	Mon, 23 Jun 2025 22:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716558; cv=none; b=L8fehX1EHxObsGjfnHNYwSsm9xrv8wBpRLOE4yQXOMfyY8sYc8VxU8fR75XwGmxXKyh3HD8gC5QP/1R6qrcrCLDmgupPGB7g3YZtPUwYPXvqSscdaTzgvnXVr0XTQVwYpnsuTWMxZK8jOwwY3+JaOAHAvZ2RW8SLZ7RkYeJ8q7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716558; c=relaxed/simple;
	bh=tOIRgtGpFvakrWpjOZ/AOTb57AmaloQyOITaPweo57E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ycw0bFzy/0D/IAMe7Ko0JftwnzPic/zoMsb36AyE6c5nQVqwnpEsxT7+h6YZ/bxPP2ImZ4Z5tSTo+snqlwUeR0JRXk3mQDszvMhXtm73ULvhtxaaCCT3yfg3kAic5Xy8qjv09LeEq+YttT3rbr7AYaBbo2neqr0Iv/mhnGlLfpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfNzQvnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfNzQvnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5357EC4CEEA;
	Mon, 23 Jun 2025 22:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716556;
	bh=tOIRgtGpFvakrWpjOZ/AOTb57AmaloQyOITaPweo57E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfNzQvnXEbUbX0Mw8JbxIQOKtd3v4bxY9+Y9BiPw7IJICazy9V0syYb8CDGPbQZFg
	 IbPU59hNP5iYPjLkwdOG1AiK/pLOjyHty0NXDqSZpWGavuuxOce6NQ96RqI63NPd5G
	 pfJnRIedEWV/SBuR1BObHhPeNHSdPNiuanLg486E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Rouven Czerwinski <rouven.czerwinski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 340/411] tee: Prevent size calculation wraparound on 32-bit kernels
Date: Mon, 23 Jun 2025 15:08:04 +0200
Message-ID: <20250623130642.208523682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 39bb67edcc582b3b386a9ec983da67fa8a10ec03 ]

The current code around TEE_IOCTL_PARAM_SIZE() is a bit wrong on
32-bit kernels: Multiplying a user-provided 32-bit value with the
size of a structure can wrap around on such platforms.

Fix it by using saturating arithmetic for the size calculation.

This has no security consequences because, in all users of
TEE_IOCTL_PARAM_SIZE(), the subsequent kcalloc() implicitly checks
for wrapping.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Tested-by: Rouven Czerwinski <rouven.czerwinski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index a44e5b53e7a91..a7e89c229fc51 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
 #include <linux/uaccess.h>
@@ -19,7 +20,7 @@
 
 #define TEE_NUM_DEVICES	32
 
-#define TEE_IOCTL_PARAM_SIZE(x) (sizeof(struct tee_param) * (x))
+#define TEE_IOCTL_PARAM_SIZE(x) (size_mul(sizeof(struct tee_param), (x)))
 
 #define TEE_UUID_NS_NAME_SIZE	128
 
@@ -493,7 +494,7 @@ static int tee_ioctl_open_session(struct tee_context *ctx,
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
-	if (sizeof(arg) + TEE_IOCTL_PARAM_SIZE(arg.num_params) != buf.buf_len)
+	if (size_add(sizeof(arg), TEE_IOCTL_PARAM_SIZE(arg.num_params)) != buf.buf_len)
 		return -EINVAL;
 
 	if (arg.num_params) {
@@ -571,7 +572,7 @@ static int tee_ioctl_invoke(struct tee_context *ctx,
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
-	if (sizeof(arg) + TEE_IOCTL_PARAM_SIZE(arg.num_params) != buf.buf_len)
+	if (size_add(sizeof(arg), TEE_IOCTL_PARAM_SIZE(arg.num_params)) != buf.buf_len)
 		return -EINVAL;
 
 	if (arg.num_params) {
@@ -705,7 +706,7 @@ static int tee_ioctl_supp_recv(struct tee_context *ctx,
 	if (get_user(num_params, &uarg->num_params))
 		return -EFAULT;
 
-	if (sizeof(*uarg) + TEE_IOCTL_PARAM_SIZE(num_params) != buf.buf_len)
+	if (size_add(sizeof(*uarg), TEE_IOCTL_PARAM_SIZE(num_params)) != buf.buf_len)
 		return -EINVAL;
 
 	params = kcalloc(num_params, sizeof(struct tee_param), GFP_KERNEL);
@@ -804,7 +805,7 @@ static int tee_ioctl_supp_send(struct tee_context *ctx,
 	    get_user(num_params, &uarg->num_params))
 		return -EFAULT;
 
-	if (sizeof(*uarg) + TEE_IOCTL_PARAM_SIZE(num_params) > buf.buf_len)
+	if (size_add(sizeof(*uarg), TEE_IOCTL_PARAM_SIZE(num_params)) > buf.buf_len)
 		return -EINVAL;
 
 	params = kcalloc(num_params, sizeof(struct tee_param), GFP_KERNEL);
-- 
2.39.5



