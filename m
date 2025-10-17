Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4D732C931;
	Fri, 17 Oct 2025 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713811; cv=none; b=nD40RwJNNDpmDqwF/TFSSaREKYcPzzBxVx4U+1YPDHA0Em8vInvsvK01v88SfrefLbsNy2Fh++K2iNm+tYkJRSs2zb6PHjq18Mwr8/gN4FygG62ipW6hjKZk8/xKVUDk/vSmewLWL/rg7wracJsqGaDDfn78fHJdoPQ2Gfre6wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713811; c=relaxed/simple;
	bh=QEWQq3tH6RaKFAZehKi0pinYMw8u6UF0tNxba3hOEV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrTnWd4V90Va027SoXR4edNvVr99EbWAw+2mHDKlEMGceRnjhrV7w+OhIPjONDt5W/HXfaQB2FsmBQEN1YSHgC8m//HYTWJYKNNzsNIPYyuY/1h17f5l1HFDGJu9hRQ+xI8bv7pCAcENXDRgmqBvO7y/5Bx95STvvCEXIDucX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO/1d31g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO/1d31g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658E9C4CEE7;
	Fri, 17 Oct 2025 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713811;
	bh=QEWQq3tH6RaKFAZehKi0pinYMw8u6UF0tNxba3hOEV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO/1d31gCd6HzwbjQy/7pEEI4mZvoPosUUbmW+mXZRueMmVNtxAdHt0QuT9HfZ0ZR
	 X0b8ZOO0yVYG7qXmQsBaAHiEylW3chcY6xxRayKsSLCSr+UP7whi4Y6EQV/4pIynXj
	 ENAAc+8twZseWGexHAEiQnkG21QrIiOllS0rz4Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.6 129/201] PCI/AER: Fix missing uevent on recovery when a reset is requested
Date: Fri, 17 Oct 2025 16:53:10 +0200
Message-ID: <20251017145139.479827212@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit bbf7d0468d0da71d76cc6ec9bc8a224325d07b6b upstream.

Since commit 7b42d97e99d3 ("PCI/ERR: Always report current recovery
status for udev") AER uses the result of error_detected() as parameter
to pci_uevent_ers(). As pci_uevent_ers() however does not handle
PCI_ERS_RESULT_NEED_RESET this results in a missing uevent for the
beginning of recovery if drivers request a reset. Fix this by treating
PCI_ERS_RESULT_NEED_RESET as beginning recovery.

Fixes: 7b42d97e99d3 ("PCI/ERR: Always report current recovery status for udev")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250807-add_err_uevents-v5-1-adf85b0620b0@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1612,6 +1612,7 @@ void pci_uevent_ers(struct pci_dev *pdev
 	switch (err_type) {
 	case PCI_ERS_RESULT_NONE:
 	case PCI_ERS_RESULT_CAN_RECOVER:
+	case PCI_ERS_RESULT_NEED_RESET:
 		envp[idx++] = "ERROR_EVENT=BEGIN_RECOVERY";
 		envp[idx++] = "DEVICE_ONLINE=0";
 		break;


