Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C20319858;
	Mon, 29 Dec 2025 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024982; cv=none; b=WLNvDLlcBKX5wUtGrnvWByUU8Ri3hYVakxqerRFLFSQY4NynywdXY+lEoYBbXRkWUNXKswxZ4rFhLDHzueB4aiZHSF3rFi7LlRWMtImcEdaB8NqzlIp9Iitm6yp2jf/kJqWjqNBLFzrY3+qVjWsupuVaGIDUaq4gwb8pYCDHv5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024982; c=relaxed/simple;
	bh=xCWot3U2ZiH+qxK3lwDpPZxc5nybJFmHITChkuU/uqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXhuxmokU75PPo6QukrRmvkilOcdti8F8i/z3AWxPxF0Xa2u8QrjxQUnp4LrTUzo0g3FxKJ5bKns18dplIcojJEWSkdSc2wVSf7ql/9eDMT2VJfRykE6nTNlsSdB5cX3cOfrZhBWlKoYtaUQTn8aivRohXPVyPMX8Ky1xzTEpZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZJQYmGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZJQYmGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4645C4CEF7;
	Mon, 29 Dec 2025 16:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024982;
	bh=xCWot3U2ZiH+qxK3lwDpPZxc5nybJFmHITChkuU/uqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZJQYmGdHimW1P9nz2E+NpIOqEjlxoZSwXnUHHyLzBzp+TUxcpNsVqk9DgyTrcFou
	 KMDIABU7y42U/RHVJzj7JmrCKc3kZXAhZ2g3Ua0fM+rS1DsZgvRbTmngSlzgbYTGaU
	 8sxLmEb28KqfyTX8Rb2cuRMyDHfcFD0L5ggT+Jzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/430] crypto: ccp - Add support for PCI device 0x115A
Date: Mon, 29 Dec 2025 17:07:07 +0100
Message-ID: <20251229160725.084951436@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 9fc6290117259a8dbf8247cb54559df62fd1550f ]

PCI device 0x115A is similar to pspv5, except it doesn't have platform
access mailbox support.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index e7bb803912a6d..8891ceee1d7d0 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -459,6 +459,17 @@ static const struct psp_vdata pspv6 = {
 	.intsts_reg             = 0x10514,	/* P2CMSG_INTSTS */
 };
 
+static const struct psp_vdata pspv7 = {
+	.tee			= &teev2,
+	.cmdresp_reg		= 0x10944,	/* C2PMSG_17 */
+	.cmdbuff_addr_lo_reg	= 0x10948,	/* C2PMSG_18 */
+	.cmdbuff_addr_hi_reg	= 0x1094c,	/* C2PMSG_19 */
+	.bootloader_info_reg	= 0x109ec,	/* C2PMSG_59 */
+	.feature_reg		= 0x109fc,	/* C2PMSG_63 */
+	.inten_reg		= 0x10510,	/* P2CMSG_INTEN */
+	.intsts_reg		= 0x10514,	/* P2CMSG_INTSTS */
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -525,6 +536,13 @@ static const struct sp_dev_vdata dev_vdata[] = {
 		.psp_vdata = &pspv6,
 #endif
 	},
+	{	/* 9 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+		.psp_vdata = &pspv7,
+#endif
+	},
+
 };
 static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
@@ -539,6 +557,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
 	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.51.0



