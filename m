Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E4143F0AA;
	Thu, 30 Jul 2026 14:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421405; cv=none; b=YyrvnFRQM9opPj1+dIZK7oBz+v51ANXMwgza2t75mhQdKpNXjQxcHKXrz1go6ER2wJ0B1XDigSDt+LC81MT5wvCK0SrJNMTzAbt/mE1KAvSKF22CSIHHk2Uay08GryCH5NR9ndKSJV9wKCrbHqqKoFLmQ+TWX3Qvp+ZkDxU4Kus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421405; c=relaxed/simple;
	bh=rVmZc6N/ijIY8iNrcxivmnRubzXAoBXKehdk3u6b++c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iW/VlRFhREYXpqvrNCU/kFwwRv33+H4v/WRd51zF9q+SMjx9FZyH4y/OdVgD356SBHGbII2/6rBkuTnBWAesnE85K8ivxqySn9ywRKG7kAnJncU0GLKCohMjFRSFVEjWdVUhF6XZuqe1oAZGFzPop0K6fsR/ib/P0Sta/4R5yRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMFrUHAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMFrUHAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8B1F00ACA;
	Thu, 30 Jul 2026 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421403;
	bh=frwHPmUgrm7aDQEOrhxaifi+aZVPWahNsUTA5hAe/Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMFrUHAl9NlLZxNPbo7v21wQJZJJnXZZaJZDjt7njKbZXeuXHSHU0ByLjOwjSKzF2
	 tU1wLQGkRKR26y/YfgoeAZZdGvlgulErDJPoTAK7p/8BcocALS56jwSZbmQcM6Mpxc
	 Dbp5o0J/qNr9gbDxVTuFPHL4VSnm8EsVzfwVRzQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 093/744] ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered
Date: Thu, 30 Jul 2026 16:06:06 +0200
Message-ID: <20260730141446.244959768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 4bbc16a353a98023e5ddfca7c1fc0e49971cf4d0 ]

sata_dwc_enable_interrupts() is called before platform_get_irq() and
ata_host_activate(), leaving the SATA controller's interrupt mask
enabled without a registered handler.  If a later step fails (irq
request, phy init, etc.) or if the controller asserts an interrupt
during probe, the irq line may fire with no handler, causing a
spurious interrupt storm.

Move sata_dwc_enable_interrupts() after ata_host_activate() so that
interrupts are only unmasked once the handler is registered and the
core is fully initialized.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 64cb544903d888..47313dd4757859 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1168,9 +1168,6 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	/* Save dev for later use in dev_xxx() routines */
 	hsdev->dev = dev;
 
-	/* Enable SATA Interrupts */
-	sata_dwc_enable_interrupts(hsdev);
-
 	/* Get SATA interrupt number */
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
@@ -1203,6 +1200,8 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	if (err)
 		dev_err(dev, "failed to activate host");
 
+	/* Enable SATA Interrupts */
+	sata_dwc_enable_interrupts(hsdev);
 	return 0;
 
 error_out:
-- 
2.53.0



