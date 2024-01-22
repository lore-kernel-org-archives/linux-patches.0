Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386076A354;
	Tue, 23 Jan 2024 02:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975372; cv=none; b=RfpknnYyMtHAj40L+BT6BWlmHhZJUrcaLSI067sEb9SLk0O7cYcQSGgcrbV7dPwJnx7v9QedA7A/M4DDA3/XU6XFqEUEjNwPHxFXySQ7o2Cw4Ddk6bINojbzYPcOOSEROvhuD5vAyVnx6iu+ECPeeP7P1kWkPsiyh3Hqg4r5NPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975372; c=relaxed/simple;
	bh=eLeU5xlDBPy/kD//MsCCBsu6RNKMyBYHzhp/eCNwpJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzlzZvmDKh3N/nE6t38Txh2itYgQdNXPqetirDY/huC9FDmYmwefy8uRjux2d0RPfL8a1XTtk7P667qLVzdc/GjoDEVFQzVw4049gg3ZDKe/OIyu+HLJUfzv0+WF5TwPn2ZTeGryvW2mEu5uPD/s5s7Bh+rnwIEZWNdiKcoPTgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfyAYJYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfyAYJYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ED5C433C7;
	Tue, 23 Jan 2024 02:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975372;
	bh=eLeU5xlDBPy/kD//MsCCBsu6RNKMyBYHzhp/eCNwpJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfyAYJYMV2GsvdTDVaTmhxZIoJerQfcOPL9ywrvMPnVYgxtbgeZO/G1HCCPFsWEiU
	 q1BnokPaCpCWduLrGzMNGcRjOeJp4oSMKOtpH/Ed5OSJSPOPAMyvSfhBixbCIGvWzt
	 ccqJMiHIHrfyB/MeXqYKBS8fY7tToZhKV956jIC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/583] accel/habanalabs: fix information leak in sec_attest_info()
Date: Mon, 22 Jan 2024 15:56:00 -0800
Message-ID: <20240122235821.482251221@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
 drivers/accel/habanalabs/common/habanalabs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/habanalabs_ioctl.c b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
index 6a45a92344e9..a7f6c54c123e 100644
--- a/drivers/accel/habanalabs/common/habanalabs_ioctl.c
+++ b/drivers/accel/habanalabs/common/habanalabs_ioctl.c
@@ -682,7 +682,7 @@ static int sec_attest_info(struct hl_fpriv *hpriv, struct hl_info_args *args)
 	if (!sec_attest_info)
 		return -ENOMEM;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		rc = -ENOMEM;
 		goto free_sec_attest_info;
-- 
2.43.0



