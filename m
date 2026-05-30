Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3157F331200;
	Sat, 30 May 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166042; cv=none; b=XiIOkS8idq1sNqSd50lSK/kEo2Zwvz7L2CHHh8FtZO74qnl9KFLrqTQ3/+fEg8dGQ3lWZHHXNBeUi0d6VKm1uo+CzF4eo56o2FvJFv3slac8cGm2+KR6CO7klzs/JrIiotYqoh1oJ/DLDiA7TvK+204Ek6AA50o8JtgcEzFF7Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166042; c=relaxed/simple;
	bh=ysXuTmXd7YK+2fzBI6h39WfDx4vQFhmZhsaO6etlejM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuAdYNSQMZ4O+GI1sjwaQSVUUcX259VnRl0lk7pqrh5knRPuVHOzFFTmKT38ptChWFsyRbdXU1Z2M2d/I45/0hplUnpKCmW0pM+dCcj16zYzGrVwArW1PCd/mUQVSYrDFX014kf1KAh9ihIxBHXpRkiq9IAap6diZ7D1FRFqUGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtgadl7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtgadl7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E21F00893;
	Sat, 30 May 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166041;
	bh=ZAlIMvpGydhLOltVYE3ncD5ZtSsIPiYvOI5ZpVSd8lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtgadl7WTXdOwVZqQi75y5oe7URpdpXkjgfzuW/UgASQFAjB/lA5+2ULa3VDmw4CL
	 idRccfU8jMkCFXxko9xmxnhTUuHS5AFdTcfmh/qJFJK6wmeBzcP35NKOnS642raPII
	 rzMN3SRmnxJs90JslMBPFcVG9VDWoTYzB863kuMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Stefan Roese <stefan.roese@mailbox.org>
Subject: [PATCH 5.10 257/589] PCI/AER: Stop ruling out unbound devices as error source
Date: Sat, 30 May 2026 18:02:18 +0200
Message-ID: <20260530160231.730576543@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -853,8 +853,6 @@ static bool is_error_source(struct pci_d
 	 *      3) There are multiple errors and prior ID comparing fails;
 	 * We check AER status registers to find possible reporter.
 	 */
-	if (atomic_read(&dev->enable_cnt) == 0)
-		return false;
 
 	/* Check if AER is enabled */
 	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);


