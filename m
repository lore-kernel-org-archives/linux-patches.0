Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940F032E13C;
	Fri, 17 Oct 2025 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713814; cv=none; b=jjmPJwxA1Oq+XuJEGurBHqTwBUTbUL/PhDBl0XDRrqBRraj0HkSQMvSdCg4z/nvJIg+t7QwwV5wQfJ1fgSnWeTraBVeLkFfzy4Q5wAatmRFlPsyiJZTbgDafxwfE7Kdb+SiWRbMX2/jXBQQJzpvl0L0AW2ZESDMV1rfYJXIHb+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713814; c=relaxed/simple;
	bh=GZKeEfy34uMMei66ABlBuf2NXcWn9+kZwHIOCWIJ2OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz2bbhlz/Rvd/6BcPe4qmFu+2KNN3lYo7luQ8/QHMmdaFjJQ/Dxgahf9mZu5tWR7LKvbTB/rEsdFLOTrfcbT7c3ceeo7+ASAdtTx5KGWAjruwvvLPFDdGEVr2wPa/6sYrnJJAcrgQ3iyHKPJvKXtp3N9xrFrZgaM3O1zDZQRZmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN1v9NWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN1v9NWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4E6C4CEE7;
	Fri, 17 Oct 2025 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713814;
	bh=GZKeEfy34uMMei66ABlBuf2NXcWn9+kZwHIOCWIJ2OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN1v9NWFVg4cYKmnn5XQjAfvR9/+YMpe6Mu/jubBLXqb4HhsLTvlJKkCrOgZpvGWH
	 jqiZ6nyP5EsJ0EskHKyd9hP9ZDwI7PtfMddFaPDRWqSsNo2+8XPA29g5FwO/nKCcuR
	 44pS4fnM2tYA0aR3EuTSrblnbQ9bf/Ha/EWLoAqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.6 130/201] PCI/AER: Support errors introduced by PCIe r6.0
Date: Fri, 17 Oct 2025 16:53:11 +0200
Message-ID: <20251017145139.516613718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 6633875250b38b18b8638cf01e695de031c71f02 upstream.

PCIe r6.0 defined five additional errors in the Uncorrectable Error
Status, Mask and Severity Registers (PCIe r7.0 sec 7.8.4.2ff).

lspci has been supporting them since commit 144b0911cc0b ("ls-ecaps:
extend decode support for more fields for AER CE and UE status"):

  https://git.kernel.org/pub/scm/utils/pciutils/pciutils.git/commit/?id=144b0911cc0b

Amend the AER driver to recognize them as well, instead of logging them as
"Unknown Error Bit".

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/21f1875b18d4078c99353378f37dcd6b994f6d4e.1756301211.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aer.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -38,7 +38,7 @@
 #define AER_ERROR_SOURCES_MAX		128
 
 #define AER_MAX_TYPEOF_COR_ERRS		16	/* as per PCI_ERR_COR_STATUS */
-#define AER_MAX_TYPEOF_UNCOR_ERRS	27	/* as per PCI_ERR_UNCOR_STATUS*/
+#define AER_MAX_TYPEOF_UNCOR_ERRS	32	/* as per PCI_ERR_UNCOR_STATUS*/
 
 struct aer_err_source {
 	unsigned int status;
@@ -510,11 +510,11 @@ static const char *aer_uncorrectable_err
 	"AtomicOpBlocked",		/* Bit Position 24	*/
 	"TLPBlockedErr",		/* Bit Position 25	*/
 	"PoisonTLPBlocked",		/* Bit Position 26	*/
-	NULL,				/* Bit Position 27	*/
-	NULL,				/* Bit Position 28	*/
-	NULL,				/* Bit Position 29	*/
-	NULL,				/* Bit Position 30	*/
-	NULL,				/* Bit Position 31	*/
+	"DMWrReqBlocked",		/* Bit Position 27	*/
+	"IDECheck",			/* Bit Position 28	*/
+	"MisIDETLP",			/* Bit Position 29	*/
+	"PCRC_CHECK",			/* Bit Position 30	*/
+	"TLPXlatBlocked",		/* Bit Position 31	*/
 };
 
 static const char *aer_agent_string[] = {


