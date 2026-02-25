Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2355F2D248B;
	Wed, 25 Feb 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002618; cv=none; b=f3IbduwvV+6hpioLZ7Vid3wY40ofY7vs6Sb37pzEthNJe7b43U1FyK5HU0Xu4BS2Bu64usxjtP//WuyTwpMZ4pjKrETkQ9B+v7q0yzL2xKrZ4bJAycoHI2U9sjda1rbfgc6S4P/cJnPWx1qu/U7MKkbY1YKVmXzpmzAHdhItV1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002618; c=relaxed/simple;
	bh=MjyDjNiLMi//rwFbxtuOgpzifFfA9BbrV92NgcpJnz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLIi8qDWqqU7Tq677wuyAT0NUTiuyAcSw7Di/VTCJTQZ6hOipANAfVNN5EA1DfwaKJQF0+FmLB8Eg0oZmOyI6WsJ6ewCHQGDRp4QPx6KZuAkCIoti0lW4iUQs1ZcyoS5SAtqaeXKSE/sitqxNPwGjNL1SOm55gHhBE3UpU+BFc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bu52+Qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bu52+Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B0BC116D0;
	Wed, 25 Feb 2026 06:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002618;
	bh=MjyDjNiLMi//rwFbxtuOgpzifFfA9BbrV92NgcpJnz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bu52+QaFN1RHeIZLi6mM7uexV0PRhiXb2SdHsaVmIJp5KSpyKflTMF4OIEJkuvRi
	 mZCip1BNIlyj7y9LY56qmFWSe4KyBKkfEZ/PW6WKTX8DF/wY7TMP7Rv1X/zjj1OvUH
	 fuyUOC2/uKWXmsFCv5ti/2e10cmlhG/aCFua0+YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@Dell.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/641] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails
Date: Tue, 24 Feb 2026 17:21:37 -0800
Message-ID: <20260225012357.596582531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 7b85137caf110a09a4a18f00f730de4709f9afc8 ]

The hibernate resume sequence involves loading a resume kernel that is just
used for loading the hibernate image before shifting back to the existing
kernel.

During that hibernate resume sequence the resume kernel may have loaded
the ccp driver.  If this happens the resume kernel will also have called
PSP_CMD_TEE_RING_INIT but it will never have called
PSP_CMD_TEE_RING_DESTROY.

This is problematic because the existing kernel needs to re-initialize the
ring.  One could argue that the existing kernel should call destroy
as part of restore() but there is no guarantee that the resume kernel did
or didn't load the ccp driver.  There is also no callback opportunity for
the resume kernel to destroy before handing back control to the existing
kernel.

Similar problems could potentially exist with the use of kdump and
crash handling. I actually reproduced this issue like this:

1) rmmod ccp
2) hibernate the system
3) resume the system
4) modprobe ccp

The resume kernel will have loaded ccp but never destroyed and then when
I try to modprobe it fails.

Because of these possible cases add a flow that checks the error code from
the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.

Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
Reported-by: Lars Francke <lars.francke@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-6-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 14 ++++++++++++++
 include/linux/psp.h          |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index ef1430f86ad62..92ffa412622a2 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
 	struct tee_init_ring_cmd *cmd;
+	bool retry = false;
 	unsigned int reg;
 	int ret;
 
@@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	/* Send command buffer details to Trusted OS by writing to
 	 * CPU-PSP message registers
 	 */
+retry_init:
 	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
 				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
 	if (ret) {
@@ -145,6 +147,18 @@ static int tee_init_ring(struct psp_tee_device *tee)
 	}
 
 	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		/*
+		 * During the hibernate resume sequence driver may have gotten loaded
+		 * but the ring not properly destroyed. If the ring doesn't work, try
+		 * to destroy and re-init once.
+		 */
+		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
+			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
+			if (tee_send_destroy_cmd(tee)) {
+				retry = true;
+				goto retry_init;
+			}
+		}
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
diff --git a/include/linux/psp.h b/include/linux/psp.h
index 92e60aeef21e1..b337dcce1e991 100644
--- a/include/linux/psp.h
+++ b/include/linux/psp.h
@@ -18,6 +18,7 @@
  * and should include an appropriate local definition in their source file.
  */
 #define PSP_CMDRESP_STS		GENMASK(15, 0)
+#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
 #define PSP_CMDRESP_CMD		GENMASK(23, 16)
 #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
 #define PSP_CMDRESP_RECOVERY	BIT(30)
-- 
2.51.0



