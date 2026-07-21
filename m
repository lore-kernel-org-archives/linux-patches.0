Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44E0415F04;
	Tue, 21 Jul 2026 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664361; cv=none; b=OKloT5lr3XtJN4JT6BC0XBU7h0wtlbCV1dPOgxnPJEawZ/2bG+VJQqxUr5oef6V2N55zHQTFPGoFhzdKFEvxOxBLlxQKi40lxwYlRaW1IUC0tL1SzCNv42ieZafu+VViLiWT5BXi1hinaXizkrnsQbvS8suHvGZanKJz5qhMdeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664361; c=relaxed/simple;
	bh=EggdhOXJu2DvEVRRgacslUYbIxqqE60F9bSmtQHztNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPSsQGZ9hf1Q1G+/JKmRvKGULBl2Bmqw9B4ttOG4s0Le/PZoOdTajcAV8D2UEV/I8h29w1Udk2Y6i6OOv1A/umZcdbf+cOVKTWsSBVuRQPHHKNpDokhlwCRxMqLNUMPs1hpulFDJOfPRnbjVBPjacKvJB/P1PYQRKC1+S3YEgx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMRtzF/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMRtzF/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129071F000E9;
	Tue, 21 Jul 2026 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664360;
	bh=U9GIEInVub23f/bG9qj1zdDJjUnU+3HLl3nkSUJikaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMRtzF/4FxUDhsaOBsoGRuGdGkNAF3rF5WfZU1/iA+vuqTinYjITNRiOlS2Y7td+P
	 G4/+0xSNpQ2FjOThU66JSEY31vKV8cEFKpKhoQLrzPP+W1SyE5BH6bHPtREYY7arU4
	 gsiFvPTFTa0LdVgc4IF3CTJCybSly3PqlJ8JWClw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.12 1154/1276] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:26:37 +0200
Message-ID: <20260721152511.837253388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 1d8a0506f69895b7cfd9d5c4546761c508231a8a ]

Freeing the saved list does not require holding pci_bus_sem, so the
critical section can be made shorter.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-6-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2400,8 +2400,8 @@ cleanup:
 		pci_claim_resource(bridge, i);
 		pci_setup_bridge(bridge->subordinate);
 	}
-	free_list(&saved);
 	up_read(&pci_bus_sem);
+	free_list(&saved);
 
 	return ret;
 }


