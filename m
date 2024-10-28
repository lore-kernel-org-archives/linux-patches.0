Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068E2C697;
	Mon, 28 Oct 2024 06:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097497; cv=none; b=n3G6X8oGm6qILRro5/ecdEkABgfr0rIn9cLM8yZT4r9UUIEmPIyszQ1rPrXq/qZtDK2S8FxWLuR6tORGGAGXupkBD4yoW6MHpaizLWNfmpozTCXOElmxuLmlzw1uu+q/IMCXLmkDNNV/tuH13TR56nxe/sjCceCsVnevaCZIR3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097497; c=relaxed/simple;
	bh=sZnvWuvQSRy7SK88k1ED4m0ZRoFCmwbAmAgxD6P0LWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=logv7SfnzXgtXLhyysiWBqtIaz+xCyTOmJwsg7TFnXBnQZExlDomp/jgCtbXfeuFQvNuVfPFzZi/ibVeSRT/P33MItM4jNbDs5yzZGwrzMBruIvxXhiTmExDJQhb8TwxFxSIE0iAEzkd9bhWancoH5iZtHfXe7ZUSDjvZnX1rMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6Lwdi6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6Lwdi6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFC5C4CEC3;
	Mon, 28 Oct 2024 06:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097496;
	bh=sZnvWuvQSRy7SK88k1ED4m0ZRoFCmwbAmAgxD6P0LWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6Lwdi6mta2f4TkQVTnGbaJjlymQ/A0zACn8Zwu2ymcMOAy7SF7mFU1L2mirB42Hj
	 W4Au2l9WM8muV6wkHkCObsAcf8mhBQeag/fqTZ0ALBJtTga/fp4mvd38nFurWsV7F7
	 vOrMsbdpChurUMkCLlfUVuRKoGhH3xFFW7xDK9dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/208] s390/pci: Handle PCI error codes other than 0x3a
Date: Mon, 28 Oct 2024 07:23:19 +0100
Message-ID: <20241028062307.131953828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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



