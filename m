Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D02325495;
	Mon, 27 Oct 2025 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591421; cv=none; b=gJOrIlhezqSZ7ZQPYsNkFKw4J7ZvENhE/DMyO7IRzdzwBDt2y29RDywO+Ca5DBWESaD6eDFDVEcZUFbqLAJPImvkjqSifsp4inFuT+Wl4xEqhvrmyAyTYkC8jIyd5xwauOwy16ljm2OzaizAndfBvnne7TlZVWhlBhU3TW7qGCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591421; c=relaxed/simple;
	bh=4kwn2XsW0A2QeGLfwZILSK/gW17UFxR0Ev3/UytMBe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsMGv4NcAqkYg0+h4CvFPULzMVO9e5VT8X/lLL8FL7mJ5XisfaXWZ8CWtw6Sb7DpJpFP4Ra1KvdTDujvsrodcJFLX1HNXiOs+Zit7Wm5yxMssdD7YcPnzVYWOWh+RpLXRMLaQ8c4bMHGAeeJFYjAzxmoGmsoV5eBVzZ0gbLf8B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2QFoA19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2QFoA19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7FAC4CEF1;
	Mon, 27 Oct 2025 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591420;
	bh=4kwn2XsW0A2QeGLfwZILSK/gW17UFxR0Ev3/UytMBe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2QFoA19NQDbPvdF55kXrn/xm6x2LO7P3r9MHofoo0k8D1Trwgqq7Nbjw5K01l0Ls
	 Ryw0SphlKp2vhhwtX5sWjt7Ms7qczQs8bInGE9yhQu9OCWhQxLkuonTJVQky0fOsaZ
	 2KNXjjnJbdemRKfAqrAA/esOVdXeQ6rIw0RpLLDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 5.10 160/332] PCI/AER: Support errors introduced by PCIe r6.0
Date: Mon, 27 Oct 2025 19:33:33 +0100
Message-ID: <20251027183528.854169091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,7 +37,7 @@
 #define AER_ERROR_SOURCES_MAX		128
 
 #define AER_MAX_TYPEOF_COR_ERRS		16	/* as per PCI_ERR_COR_STATUS */
-#define AER_MAX_TYPEOF_UNCOR_ERRS	27	/* as per PCI_ERR_UNCOR_STATUS*/
+#define AER_MAX_TYPEOF_UNCOR_ERRS	32	/* as per PCI_ERR_UNCOR_STATUS*/
 
 struct aer_err_source {
 	unsigned int status;
@@ -513,11 +513,11 @@ static const char *aer_uncorrectable_err
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


