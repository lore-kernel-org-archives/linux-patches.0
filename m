Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE50064CDA;
	Tue, 23 Jan 2024 00:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971343; cv=none; b=GnD1DLVT7N/u8DBb0J2ksId/xrv5DFYannJ9HLAsOtG8+/FeyJjyVwbodFGzmgc5bTIOwfq+U9YBqNCuZuWZvahzf7lKg6AWhFoF9q5hveEnBWPQPlkKZHoDcLJg+xhtHleqNfv4T+rAnrnvZ/+VHkLPkwPURG4prB7Fae8HIsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971343; c=relaxed/simple;
	bh=Rk70To/34dzhv8aXOUJRPhl4CO89h6JCzDCip1ph1hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3PRllkfgLoqt092S7WPsuaGtUQUXuHC6VXfLQxtaa0WCEZiQbfUFKXHsemjBBicn1uml83rjp9so2JFtI4HRmnRueF0Zl6ONFuHEDPzDoqIPeS7AM5u+uYO7neLG77l7YL4xsVAelzuZZukWJzkV/IRUCgP+soVQFeyxP6Qzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9eU5rZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9eU5rZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF28C433F1;
	Tue, 23 Jan 2024 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971342;
	bh=Rk70To/34dzhv8aXOUJRPhl4CO89h6JCzDCip1ph1hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9eU5rZA2H6sBZZiImNcCBXIf/abiEWxfJCSU5vTgVImQesNTMJsXsFBFw8N5nGEg
	 /mK//xB9Sqdd2mvKTmTAAwox4/azXyeNWX21HwV4BAjck3VGqJV/Xf6DkX7bdD7+CW
	 jtbpnfKYYXclKXh9cyga5Os/Bj+FX9Wx1s9tNwL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/417] accel/habanalabs: fix information leak in sec_attest_info()
Date: Mon, 22 Jan 2024 15:56:34 -0800
Message-ID: <20240122235759.740806369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit a9f07790a4b2250f0140e9a61c7f842fd9b618c7 ]

This function may copy the pad0 field of struct hl_info_sec_attest to user
mode which has not been initialized, resulting in leakage of kernel heap
data to user mode. To prevent this, use kzalloc() to allocate and zero out
the buffer, which can also eliminate other uninitialized holes, if any.

Fixes: 0c88760f8f5e ("habanalabs/gaudi2: add secured attestation info uapi")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/habanalabs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/common/habanalabs_ioctl.c b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
index 43afe40966e5..1ea1ae34b7a7 100644
--- a/drivers/misc/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/misc/habanalabs/common/habanalabs_ioctl.c
@@ -677,7 +677,7 @@ static int sec_attest_info(struct hl_fpriv *hpriv, struct hl_info_args *args)
 	if (!sec_attest_info)
 		return -ENOMEM;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		rc = -ENOMEM;
 		goto free_sec_attest_info;
-- 
2.43.0



