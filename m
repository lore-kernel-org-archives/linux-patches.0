Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B72D248B;
	Wed, 25 Feb 2026 06:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002617; cv=none; b=GWqy8b0CZA/HxWiSJTCvKWd4MVUaJhVUZUneW0gBT5GOgx+J4q/hGPmD+mR4oLot9DetATb21jnzmSRaY96BkOTDjRVUZ8kAwZWHWrNTY97kregdap2MufNKISl6bKGgTxEMtBle6pHy/FfEEzX2BNh3HLiaIShLlyo5idL5pKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002617; c=relaxed/simple;
	bh=B+PrP6YlrYfgJZ07Snn8zvaiNDK54KbeKb9eAPlmVWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnaDjkJ6f704mcgEL58WFpVg8wqwiY4XawWpshkO93vQSjjnjBe38JyCUjPeHp667HTWsTLxavpmmWf+Vh/f3Stuae+pCXj0YFX5QkkUc5ERl+kB2ejIXrHp9cLkwOrC9eNE1RQuMHakhhVntBphyrMTFOrIM7kV6Jg0aiwVeWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEtG8JqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEtG8JqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5664EC19425;
	Wed, 25 Feb 2026 06:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002617;
	bh=B+PrP6YlrYfgJZ07Snn8zvaiNDK54KbeKb9eAPlmVWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEtG8JqQYb1N3FH7mXvwquBzAt4dkBdFT3y2XOmkNUSnAU7EGmBl0ZOSga+414Xvh
	 HbDIFM3fraDwUAezZorTvUWksAvzPR3XCTMn48pFGP151Iitx12Q6nzBx2HLKwEcoH
	 LzFefNM8s9bBnKvaA/OUoIOVT4o5hhzimv64rvP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijun Shen <Yijun.Shen@Dell.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/641] crypto: ccp - Factor out ring destroy handling to a helper
Date: Tue, 24 Feb 2026 17:21:36 -0800
Message-ID: <20260225012357.568758094@linuxfoundation.org>
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

[ Upstream commit d95f87a65bce5f2f2a02ca6094ca4841d4073df3 ]

The ring destroy command needs to be used in multiple places. Split
out the code to a helper.

Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20260116041132.153674-5-superm1@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 7b85137caf11 ("crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 11c4b05e2f3a2..ef1430f86ad62 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -86,6 +86,29 @@ static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
 	kfree(cmd);
 }
 
+static bool tee_send_destroy_cmd(struct psp_tee_device *tee)
+{
+	unsigned int reg;
+	int ret;
+
+	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
+				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
+	if (ret) {
+		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
+		psp_dead = true;
+		return false;
+	}
+
+	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
+		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
+			FIELD_GET(PSP_CMDRESP_STS, reg));
+		psp_dead = true;
+		return false;
+	}
+
+	return true;
+}
+
 static int tee_init_ring(struct psp_tee_device *tee)
 {
 	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
@@ -137,24 +160,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
 
 static void tee_destroy_ring(struct psp_tee_device *tee)
 {
-	unsigned int reg;
-	int ret;
-
 	if (!tee->rb_mgr.ring_start)
 		return;
 
 	if (psp_dead)
 		goto free_ring;
 
-	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
-				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
-	if (ret) {
-		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
-		psp_dead = true;
-	} else if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
-		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
-			FIELD_GET(PSP_CMDRESP_STS, reg));
-	}
+	tee_send_destroy_cmd(tee);
 
 free_ring:
 	tee_free_ring(tee);
-- 
2.51.0



