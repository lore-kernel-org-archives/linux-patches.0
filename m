Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5976A52B1DE;
	Wed, 30 Sep 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790660; cv=none; b=VhtvSZ2+OF8p/T175dXq6LKHZyZUTwmU9qTxwBC4KhXLqzspQRPNo6n/Tjjawep6d7kGZ6d9jb05EN62kPoSBMpMuDo8vaiUrGaaMjzkzJQ3U/Zz7/tX+jPVNiI/E4Av3KNP4TTrVsfDN08yKQ0VshMBNmvyg9uCWNWEEvh91wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790660; c=relaxed/simple;
	bh=hjt2lk0LAK6/lW4gKKg9dSF1pq4ncjzcPiNLpUFdEuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKJdN90lW/jcO/YEKvktC0h5ZaGSZ01XaC2wcXKWdW6SHNOaOuLPepQM8bn2QYTvoahlisDpdGfwizJRdMYzPGvaNf7EZ2L0Ozy/1WPSmXuHaYEXBF7ZFHnL5MGElitxh2Q550C4j6BMJOpfuO0YuwmjB/3UAE0St/1CfaSnNsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCk+X5mq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCk+X5mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708421F000FF;
	Wed, 30 Sep 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790659;
	bh=kzBpLznSMWLS3n9wyuZKvcgHzTtSybaZxWTyeLIrsFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCk+X5mqORxd0HaHcygla3vwfj1szuZOjkbOGK9i8kiGzP6ekyLkjfIGCsaGSFsy/
	 ACx3hLnlTLjXHI74Eglb6edzBp8mtqYbEdXT1qitnGH9R5ed7g5flebxOdNnAJ9ZLC
	 IHNwXfTlmZCqExhHkWIZEyzLtY8mrKxiuB9G2ki8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/752] PCI: Stop setting cached power state to unknown on unbind
Date: Wed, 30 Sep 2026 17:17:55 +0200
Message-ID: <20260930152358.258590446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit d462c8e89e84bfb6417e6b4c88e0cb7cc747ba41 ]

When a PCI device is unbound from its driver, pci_device_remove() sets the
cached power state in pci_dev->current_state to PCI_UNKNOWN.  This was
introduced by commit 2449e06a5696 ("PCI: reset pci device state to unknown
state for resume") to invalidate the cached power state in case the system
is subsequently put to sleep.

For bound devices, the cached power state is set to PCI_UNKNOWN in
pci_pm_suspend_noirq(), immediately before entering system sleep.

Extend to unbound devices for consistency.

This obviates the need to change the cached power state on unbind, so stop
doing so.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/af7d11d3ceb231acc90829f7a5c8400c2446744f.1776415510.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 08c985478b8ff..087e664a95bdd 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -478,13 +478,6 @@ static void pci_device_remove(struct device *dev)
 	/* Undo the runtime PM settings in local_pci_probe() */
 	pm_runtime_put_sync(dev);
 
-	/*
-	 * If the device is still on, set the power state as "unknown",
-	 * since it might change by the next time we load the driver.
-	 */
-	if (pci_dev->current_state == PCI_D0)
-		pci_dev->current_state = PCI_UNKNOWN;
-
 	/*
 	 * We would love to complain here if pci_dev->is_enabled is set, that
 	 * the driver should have called pci_disable_device(), but the
@@ -822,7 +815,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 
 	if (!pm) {
 		pci_save_state(pci_dev);
-		goto Fixup;
+		goto set_unknown;
 	}
 
 	if (pm->suspend_noirq) {
@@ -879,6 +872,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		goto Fixup;
 	}
 
+set_unknown:
 	pci_pm_set_unknown_state(pci_dev);
 
 	/*
-- 
2.53.0



