Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4F2335060;
	Fri, 17 Oct 2025 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715615; cv=none; b=UJdBTmntsEysL/L6KQ6q7oo5lL0loj6qMNk8YYcyl/65eezlMlOCSn12AFFxeaojrAH604Hgz8cSrmK/dToOOPwezYA3eNc40vN9ttfAV1ZlIzk5OhOTpDdjjtNmAcUMRe9vTbk9YHO5pHRn3O0jY5pQw1ikEaF8quKcPBYk/Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715615; c=relaxed/simple;
	bh=pAc5hxjrvgx6th/pR6Oj54E/SPgxcH3/ivxD3ZGX340=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLv9t3crwXPy4DvuTUDRxajnDQtSwV9ZN7QO7dw1Q5Zz758j0CtbZUnVsr+1nMpkoYBg6n8BVwrFv11z/QZiYgij8AeeE2kUuBonKHPleapZQLchiuWwp8T3nFwxy8kylflHVtaaEIXE1Jo+MujIz8iG4UtD8rV2RAzZwAHXHgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss6p7e3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss6p7e3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED12C4CEFE;
	Fri, 17 Oct 2025 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715614;
	bh=pAc5hxjrvgx6th/pR6Oj54E/SPgxcH3/ivxD3ZGX340=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss6p7e3Nqrezg7AJmKOdoR4PtlSl6MDXL+qQRHhMf7evBB+P/8TiLFiARuXB6Gvne
	 Ye/MyPhNT4TKwgagLkr9zc5fDjVFGVC9BiWGoOKw7Na/nzCroNpCWjrYXsuUmuDs4Q
	 02KAw8O5fLIP5+nzcSqVEEAL48GUwHWZB58GQ4b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.17 278/371] PCI/AER: Fix missing uevent on recovery when a reset is requested
Date: Fri, 17 Oct 2025 16:54:13 +0200
Message-ID: <20251017145212.132657907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1596,6 +1596,7 @@ void pci_uevent_ers(struct pci_dev *pdev
 	switch (err_type) {
 	case PCI_ERS_RESULT_NONE:
 	case PCI_ERS_RESULT_CAN_RECOVER:
+	case PCI_ERS_RESULT_NEED_RESET:
 		envp[idx++] = "ERROR_EVENT=BEGIN_RECOVERY";
 		envp[idx++] = "DEVICE_ONLINE=0";
 		break;


