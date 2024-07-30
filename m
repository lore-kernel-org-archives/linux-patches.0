Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED49F1A616E;
	Tue, 30 Jul 2024 16:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356971; cv=none; b=s1hejV4trCQP7SCKt2eAjDxrJg3NT+ixE3Vj79WCnMLMetpar75t+3AOTdkSmrBcg/gptbPJF+HarnBBhbcCSEaKxtdZ2Y81tFnIW6tFNihQ8cHu6yY94aTeGW2G/UqdKD8cQr/PV9ytoRsiRBPhQMk30pgW/aBFCG8t09dM7z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356971; c=relaxed/simple;
	bh=5nMAECznsFeoFL3BaB/Fr8rcEoRvktGRbJs8Iu0nVNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3ZOHn7NSJfOVGPBOIBlfx9NySnRiunU3JDsXOt2Ef3WGqF6iFG6VRWDdvoHqCJYmAgS5ZiAUqYmyi2J+aM+vL/3BBzEBY5rw2lU2gsm41j2P9frcmlkGgo75tN8Mezij/Frm1hpRvO4kHev4MThCXzSKYflmV7Apju9FVkDJcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xspapBfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xspapBfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72303C32782;
	Tue, 30 Jul 2024 16:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356970;
	bh=5nMAECznsFeoFL3BaB/Fr8rcEoRvktGRbJs8Iu0nVNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xspapBfS+bSa24mBKDEe2byG/dUWLefVkhjKWYeR+1Y8+BsnAQ1KWaOhptQu/s3xP
	 pUw4h4QkKhRngArd/HTl32/cV2lFvZvoGKm0oLpurUHbbW5J0i4PFnwsPOtZpJmI8l
	 Msx8U3j26tHcb3IKbDg0ZliByPHbsXXMy9tf4nOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/568] ipmi: ssif_bmc: prevent integer overflow on 32bit systems
Date: Tue, 30 Jul 2024 17:45:06 +0200
Message-ID: <20240730151647.654710704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 0627cef36145c9ff9845bdfd7ddf485bbac1f981 ]

There are actually two bugs here.  First, we need to ensure that count
is at least sizeof(u32) or msg.len will be uninitialized data.

The "msg.len" variable is a u32 that comes from the user.  On 32bit
systems the "sizeof_field(struct ipmi_ssif_msg, len) + msg.len"
addition can overflow if "msg.len" is greater than U32_MAX - 4.

Valid lengths for "msg.len" are 1-254.  Add a check for that to
prevent the integer overflow.

Fixes: dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-Id: <1431ca2e-4e9c-4520-bfc0-6879313c30e9@moroto.mountain>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ssif_bmc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index 56346fb328727..ab4e87a99f087 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -177,13 +177,15 @@ static ssize_t ssif_bmc_write(struct file *file, const char __user *buf, size_t
 	unsigned long flags;
 	ssize_t ret;
 
-	if (count > sizeof(struct ipmi_ssif_msg))
+	if (count < sizeof(msg.len) ||
+	    count > sizeof(struct ipmi_ssif_msg))
 		return -EINVAL;
 
 	if (copy_from_user(&msg, buf, count))
 		return -EFAULT;
 
-	if (!msg.len || count < sizeof_field(struct ipmi_ssif_msg, len) + msg.len)
+	if (!msg.len || msg.len > IPMI_SSIF_PAYLOAD_MAX ||
+	    count < sizeof_field(struct ipmi_ssif_msg, len) + msg.len)
 		return -EINVAL;
 
 	spin_lock_irqsave(&ssif_bmc->lock, flags);
-- 
2.43.0



