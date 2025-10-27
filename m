Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30321321440;
	Mon, 27 Oct 2025 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590649; cv=none; b=eGjA4YZZL7O7ZKg5+N/1b2UZNyksEAQv9ikQESJhmsE4ZP461VRw72T4faqHiik19peTS+R4rJ470Jeb3Ac7faeiG9Lsl+FAI4Gn0v75AnSAHZBCX5AIXCZV3U7ml5fI/Icalag5zkEkZ2U7usevoqkdgfxvUjQP5jAeJKExeSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590649; c=relaxed/simple;
	bh=/TR/YxnRxkk+4x6xGP4hy4ZXWg7mF08KgxLXTs+mNCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwJWfDxbqqcx2FNdV8p0SlY0KsniB8Uc7GubHrVRodjmlaonLWP3wGDD3tiXCcU+o1Z8b2lQXa055kXsvD6oV95xeFuLHdUfnOIVXV6LWuR0KNJyas03ZUYubVL4KcgcPORGTUExOAttWbUQ51jQufDz+gC6oH4CXjXRdAV38xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSc+l8cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSc+l8cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF342C4CEFD;
	Mon, 27 Oct 2025 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590649;
	bh=/TR/YxnRxkk+4x6xGP4hy4ZXWg7mF08KgxLXTs+mNCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSc+l8cxYJAYOP9DuGSb6c71a3Ut0GyBir3WPjE2HlPgUvBKqsK72ymmmttsE5S9t
	 x/38QIHRvKpuFFg9P+zM6xOZPHLUfB4nCA48qXFq+L+BqRIgmFSitUb1I4f3fSxZfl
	 u1H4Z+mE43xcXoHAAzd5GoXq2KG8mUqiKy9ByhJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.4 124/224] PCI/AER: Fix missing uevent on recovery when a reset is requested
Date: Mon, 27 Oct 2025 19:34:30 +0100
Message-ID: <20251027183512.299705588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1603,6 +1603,7 @@ void pci_uevent_ers(struct pci_dev *pdev
 	switch (err_type) {
 	case PCI_ERS_RESULT_NONE:
 	case PCI_ERS_RESULT_CAN_RECOVER:
+	case PCI_ERS_RESULT_NEED_RESET:
 		envp[idx++] = "ERROR_EVENT=BEGIN_RECOVERY";
 		envp[idx++] = "DEVICE_ONLINE=0";
 		break;


