Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0754018E748;
	Mon, 28 Oct 2024 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097161; cv=none; b=azfpH+SIFk0ZsAxEZwAM/ZhirvcvYYhuxnOcJXy1NxXckJtMpqiNdyzKQc228gi+YJmu/XdUT8c6E7N/khURIucbVQt9VbN9WL1BvkURk+1hjRRZHRgZ1LoReQmN67IX9Z/vUy4n44Ls4XlV3tOCVUNJjNPZetifyX9J6YQzwfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097161; c=relaxed/simple;
	bh=mQzS6Qec9XtQNsFc/zOuGyTHVLmFPdfAu0spSouB7Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7CAvAiu9V0Whcx806uQBCnk2qtqHTBvME39rLqlO6afAXR5kGFqyXL/TiPXnbT2Yyfa6E0fAnvZ/Byblz2azkOJX4HRkj/RSpCncEUptFTEJvbPJBjcAInKuIqkGt7e9hdPJmUof4DwaCNKdmzTg1/mxOecKsYztErn3Ipn2Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sh99rrIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sh99rrIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB63C4CEC7;
	Mon, 28 Oct 2024 06:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097160;
	bh=mQzS6Qec9XtQNsFc/zOuGyTHVLmFPdfAu0spSouB7Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sh99rrIeqeaQtYo43iuwZC5QVmcvjv8kDdSa/oA2CpY5TXS+XTUigmeVDIh4gjMTO
	 xPBuzMbKmcw29Uj26pCQwG/bvnNKG7pabuzMNqA2m40ND7ApOzv33MsAdcYCIsnzRB
	 CWNf8dhFH0GYv3Xi5/60goVyLxKH2fDKz1I0382Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/137] s390/pci: Handle PCI error codes other than 0x3a
Date: Mon, 28 Oct 2024 07:24:07 +0100
Message-ID: <20241028062259.005023407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 3cd03ea57e8e16cc78cc357d5e9f26078426f236 ]

The Linux implementation of PCI error recovery for s390 was based on the
understanding that firmware error recovery is a two step process with an
optional initial error event to indicate the cause of the error if known
followed by either error event 0x3A (Success) or 0x3B (Failure) to
indicate whether firmware was able to recover. While this has been the
case in testing and the error cases seen in the wild it turns out this
is not correct. Instead firmware only generates 0x3A for some error and
service scenarios and expects the OS to perform recovery for all PCI
events codes except for those indicating permanent error (0x3B, 0x40)
and those indicating errors on the function measurement block (0x2A,
0x2B, 0x2C). Align Linux behavior with these expectations.

Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_event.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index b9324ca2eb940..b3961f1016ea0 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -272,18 +272,19 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 		goto no_pdev;
 
 	switch (ccdf->pec) {
-	case 0x003a: /* Service Action or Error Recovery Successful */
+	case 0x002a: /* Error event concerns FMB */
+	case 0x002b:
+	case 0x002c:
+		break;
+	case 0x0040: /* Service Action or Error Recovery Failed */
+	case 0x003b:
+		zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
+		break;
+	default: /* PCI function left in the error state attempt to recover */
 		ers_res = zpci_event_attempt_error_recovery(pdev);
 		if (ers_res != PCI_ERS_RESULT_RECOVERED)
 			zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
 		break;
-	default:
-		/*
-		 * Mark as frozen not permanently failed because the device
-		 * could be subsequently recovered by the platform.
-		 */
-		zpci_event_io_failure(pdev, pci_channel_io_frozen);
-		break;
 	}
 	pci_dev_put(pdev);
 no_pdev:
-- 
2.43.0



