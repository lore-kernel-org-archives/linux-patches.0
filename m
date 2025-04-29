Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D480622DF91;
	Tue, 29 Apr 2025 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948351; cv=none; b=CcgdGpDq4SPicvo1SQqaCXfll20/kZVwTO27HEfxtoonalROIlliizjhEreOwo6S74QlWrWos6V8eUE5pw8GuCKSMzbTOJ9irgLaNcuDnUv2UHvo8OuHtQOybxOJKN6L/X4N4x3d16Ycu1cmH7PdwhJB05hnYJOhKE2EnXIAgqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948351; c=relaxed/simple;
	bh=SP/ss1cjl2SAiKQ48BgV8gikIV63W+PlOUC4cy25GQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnLGEbuzUoLeWZgLMz9s2KiB8AH8HayK17/14hgmrgyt4JOwlFYO7AXr1Yufk40/SUJ/TfXsJ8c80EjgvQMjGzbWMzgN1k2w9PgYXyKKpo+FGpG3HquJzFAahjU0RhTTxUyMAdXt/r7UcLb+tjL+BMvRJ68d42z2c996AcYMI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO2Gg2Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO2Gg2Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A4FC4CEE3;
	Tue, 29 Apr 2025 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948351;
	bh=SP/ss1cjl2SAiKQ48BgV8gikIV63W+PlOUC4cy25GQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO2Gg2YzxNHIO9Cgyu2//wRNue3+qmM3FBXMFGc4hHs3ayeZBrTkS792anurXQvb8
	 qe6+PbWnpji7sCq/pUEfHsbLnDrWSHnWxcIffbRRz3M+QWb/IGcEtS71mCtGXL193g
	 Hl24kw1/d61JBxe5+lTAJ3fsqbfuhXYPMAGshyzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 261/280] comedi: jr3_pci: Fix synchronous deletion of timer
Date: Tue, 29 Apr 2025 18:43:22 +0200
Message-ID: <20250429161125.813887651@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 44d9b3f584c59a606b521e7274e658d5b866c699 upstream.

When `jr3_pci_detach()` is called during device removal, it calls
`timer_delete_sync()` to stop the timer, but the timer expiry function
always reschedules the timer, so the synchronization is ineffective.

Call `timer_shutdown_sync()` instead.  It does not matter that the timer
expiry function pointer is cleared, because the device is being removed.

Fixes: 07b509e6584a5 ("Staging: comedi: add jr3_pci driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20250415123901.13483-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/jr3_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/comedi/drivers/jr3_pci.c
+++ b/drivers/comedi/drivers/jr3_pci.c
@@ -758,7 +758,7 @@ static void jr3_pci_detach(struct comedi
 	struct jr3_pci_dev_private *devpriv = dev->private;
 
 	if (devpriv)
-		del_timer_sync(&devpriv->timer);
+		timer_shutdown_sync(&devpriv->timer);
 
 	comedi_pci_detach(dev);
 }


