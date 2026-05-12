Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800073EDE41;
	Tue, 12 May 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608716; cv=none; b=msLH3dMssr+h+Q4CNljd/Z1gWQ55vTL7gyMXI2QU3m/GYArhtnDgb7rbZI4BOa665/G1Rok664zE6kGAlH0ExFybpjJeB9S3sT4Pz6VVggHsOVoKhv1mdhXRW2huGHb5lVJTHJ8HyY1PO75a3q+pLvEWkyz3qef52ljGZDDvTIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608716; c=relaxed/simple;
	bh=K9cN7gBxarQQAtVCc6WLQcFnLUBqkGA9qnLex8VDT0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHnToELQObvMK3baPPRPRPXaHR64sV1bD5HrFMeBiikfZpaiaR2+cfzQHb+GDRq0wCq3jBm2YWGe3V+w8EcoBZptug+3cNks0zhmz+WmzySJnpa3GazObHkkCMNqxj7RkgWPxIlIr2JpA8x4kx8ls3p+tNulO6bXVdGD1mQbb9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvrDPBxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvrDPBxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D3AC2BCB0;
	Tue, 12 May 2026 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608716;
	bh=K9cN7gBxarQQAtVCc6WLQcFnLUBqkGA9qnLex8VDT0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvrDPBxTKclTQcu9kR2err17r+s8gbP7wp7VRU35gWDI7cYdEU9xD11dgG7k+y3ll
	 B97Aj+tQRyIkSw4OcZftVOQRcUcE/cvq64gf/Lxe2dsZZKa+hrBYVAt5OgLsIdQAHI
	 PtT5Ax7AY7eTDwVsrGv0FtzyHoTeXVNyaLaCxli4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Stefan Roese <stefan.roese@mailbox.org>
Subject: [PATCH 6.18 187/270] PCI/AER: Stop ruling out unbound devices as error source
Date: Tue, 12 May 2026 19:39:48 +0200
Message-ID: <20260512173942.385541228@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 1ab4a3c805084d752ec571efc78272295a9f2f74 upstream.

When searching for the error source, the AER driver rules out devices whose
enable_cnt is zero.  This was introduced in 2009 by commit 28eb27cf0839
("PCI AER: support invalid error source IDs") without providing a
rationale.

Drivers typically call pci_enable_device() on probe, hence the enable_cnt
check essentially filters out unbound devices.  At the time of the commit,
drivers had to opt in to AER by calling pci_enable_pcie_error_reporting()
and so any AER-enabled device could be assumed to be bound to a driver.
The check thus made sense because it allowed skipping config space accesses
to devices which were known not to be the error source.

But since 2022, AER is universally enabled on all devices when they are
enumerated, cf. commit f26e58bf6f54 ("PCI/AER: Enable error reporting when
AER is native").

Errors may very well be reported by unbound devices, e.g. due to link
instability.  By ruling them out as error source, errors reported by them
are neither logged nor cleared.  When they do get bound and another error
occurs, the earlier error is reported together with the new error, which
may confuse users.  Stop doing so.

Fixes: f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Stefan Roese <stefan.roese@mailbox.org>
Cc: stable@vger.kernel.org # v6.0+
Link: https://patch.msgid.link/734338c2e8b669db5a5a3b45d34131b55ffebfca.1774605029.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aer.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1034,8 +1034,6 @@ static bool is_error_source(struct pci_d
 	 *      3) There are multiple errors and prior ID comparing fails;
 	 * We check AER status registers to find possible reporter.
 	 */
-	if (atomic_read(&dev->enable_cnt) == 0)
-		return false;
 
 	/* Check if AER is enabled */
 	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);


