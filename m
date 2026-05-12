Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE64C3955F5;
	Tue, 12 May 2026 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608079; cv=none; b=JP/BxTxQu+IeYV40C+ywIzze6traRjHbrRtcKyr/Q5g3sM5RuURnkhlISGfWoXMDRsTegzN3+JybOuX6DB9qIHTfwpwvaTDdAbeXfqomY8ipLFCqBLIpmiV1EK900VceqN3EClu8BlCNQEZFTRYg31nhOwhZutDoKzMaHlZrR1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608079; c=relaxed/simple;
	bh=bTngXmHgGQVz9XAaUsv6T0ymV9rfovsDm7AnUt7El3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MorVKnxR9LtFYEIIwWXVjF+Mj4NhBqY59uqOmC7EpWjOfpxiHeCVpCpNrr2Dvq+IDd6N/IHHR66v+OWltoXOtS5oZPwt6DYMkKJR46UK47Ci62KAg3yoJhCB50uuUjc4LMDc0gjkinr6b1dLSmN7D5e7bC+rvBwGc5OG+f8xl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+y72YGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+y72YGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7666BC2BCC7;
	Tue, 12 May 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608079;
	bh=bTngXmHgGQVz9XAaUsv6T0ymV9rfovsDm7AnUt7El3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+y72YGaS400707REHqBXgoznqd2dOVcmSV8pV0ROJIR/rJz4RPHMlf7mGR27OD17
	 2FgF6t63rsFvfFA8Pt0y3X48npoxv6+wTLBWJNiw18uKRGlDIc2z8Ak5s3d9h0O1sj
	 2G4RsKmzlrA2EkVv0o6FKt5HhXU/DWOpjaMdQAYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Stefan Roese <stefan.roese@mailbox.org>
Subject: [PATCH 6.12 145/206] PCI/AER: Stop ruling out unbound devices as error source
Date: Tue, 12 May 2026 19:39:57 +0200
Message-ID: <20260512173935.933262532@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -849,8 +849,6 @@ static bool is_error_source(struct pci_d
 	 *      3) There are multiple errors and prior ID comparing fails;
 	 * We check AER status registers to find possible reporter.
 	 */
-	if (atomic_read(&dev->enable_cnt) == 0)
-		return false;
 
 	/* Check if AER is enabled */
 	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);


