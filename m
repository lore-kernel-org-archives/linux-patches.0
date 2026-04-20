Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0B334107F;
	Mon, 20 Apr 2026 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701580; cv=none; b=mbBmnBTsp+z2PVWQoCmV+KKDvx7Pzp9fRZWYVrNfRGCNPYITH4wr63CUXH02kIP/pK87TviekYuMzppDHG+8tCzI4DfkNjy1mSZNBCMv9dDdlcljwpg78LHBS3cf4wDIFBW8et+ctTowpV3x1CNdKNTZT3BYJkKfdmUy4dccVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701580; c=relaxed/simple;
	bh=3mcL31hM0ovu0jMK91xgTYZrnbs8zsWei5miGYg8Wa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L///R7xObRWdfItFAYspgpvwh7uctYUwOLI7Ctfq+hydnKwRDZFjovcwnm9fYXJlEExcWGIPXbGxBNYaEVAS/99XDEssMT69h2+Fa5yebE1ggsp9jRIorfL+ZsyUJ7zFONFhYnXTE9WY+pOeqMJQk2i9Et8NccjxHpReL7NbFuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcDn1Wi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcDn1Wi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F62C19425;
	Mon, 20 Apr 2026 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701580;
	bh=3mcL31hM0ovu0jMK91xgTYZrnbs8zsWei5miGYg8Wa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcDn1Wi5aFzuUladPRRMmt57jSInS5WsiydpeJJa0yDlqNSEVRkFRX0e0Yh1bQfGA
	 3JXRhNftPXMZTVuDQ/0UG3CUq0MhA1Ep7h4vcUZB9p9xrCB8PsFZLNFVj9HpePIfU3
	 zULPxTbpXqul2uZzmPaSQpqt9V2AkhD/7/gVgeDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.12 160/162] PCI: Fix placement of pci_save_state() in pci_bus_add_device()
Date: Mon, 20 Apr 2026 17:43:12 +0200
Message-ID: <20260420153932.851452840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

Commit 58130e7ce6cb ("PCI/ERR: Ensure error recoverability at all
times") sought to backport upstream commit a2f1e22390ac, but misplaced
the call to pci_save_state() in pci_bus_add_device():

It put the call at the top of the function even though the upstream
commit deliberately put it in the middle to capture config space changes
caused by pci_fixup_final().

Fix the placement.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/bus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -331,9 +331,6 @@ void pci_bus_add_device(struct pci_dev *
 	struct device_node *dn = dev->dev.of_node;
 	int retval;
 
-	/* Save config space for error recoverability */
-	pci_save_state(dev);
-
 	/*
 	 * Can not put in pci_device_add yet because resources
 	 * are not assigned yet for some devices.
@@ -346,6 +343,9 @@ void pci_bus_add_device(struct pci_dev *
 	pci_proc_attach_device(dev);
 	pci_bridge_d3_update(dev);
 
+	/* Save config space for error recoverability */
+	pci_save_state(dev);
+
 	dev->match_driver = !dn || of_device_is_available(dn);
 	retval = device_attach(&dev->dev);
 	if (retval < 0 && retval != -EPROBE_DEFER)


