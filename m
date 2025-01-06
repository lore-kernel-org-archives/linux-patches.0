Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D655B1DC991;
	Mon,  6 Jan 2025 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177189; cv=none; b=KYQ37ULFPGXXiFSJVWaHxnxKYd8aTmJcYRw04/lapwfWFNqjoooVB1mVUTMVzgmRjpMacK0CFdWDG/oCDxhwO485Lfxuy5nnpswfi+SFUg0mcHaxLHLmNl08X9x5u9qULeeLj+5StpD8SjRhMF2oI+iDfcPXSXeWFsnXqUQ7PgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177189; c=relaxed/simple;
	bh=YOyPtahmBqjU6gsnG5YF0xD3sntndWvKRa992XRODb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogy78wQVpvnI0FHEuQE7qGYK6sgOex23Y8XTyGHoTQ62Pcc6w3Mkv/Ty9EhI1WYdt6Aw6EGvYyK+UYPeO6PcXHBgnrq5laQMddSTLBdYw9H5UZWktVuz5egdoBSvOtmr1A9YOKnt9LvjpX2l2DrUvaizUsItWEqLLCpNXcmFEYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBxEnuc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBxEnuc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3BDC4CED2;
	Mon,  6 Jan 2025 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177189;
	bh=YOyPtahmBqjU6gsnG5YF0xD3sntndWvKRa992XRODb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBxEnuc5JdcCP4bloHpUwKF8xGuAkbi0PNh9+W7axEULPyklg81qexiSpAf0qVC1j
	 UhzWjrVO+pj3JOvEIoQTmcROOBNz9e4vEIN/eX+7mFu3MFTw7Kn3qLJ1Moxun9krhA
	 AYIUaRJGj7dl26D74VmqzZ2cL1jeUjg3UfQpT+dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/222] of: address: Remove duplicated functions
Date: Mon,  6 Jan 2025 16:14:45 +0100
Message-ID: <20250106151153.668104932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 3eb030c60835668997d5763b1a0c7938faf169f6 ]

The recently added of_bus_default_flags_translate() performs the exact
same operation as of_bus_pci_translate() and of_bus_isa_translate().

Avoid duplicated code replacing both of_bus_pci_translate() and
of_bus_isa_translate() with of_bus_default_flags_translate().

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20231017110221.189299-3-herve.codina@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 7f05e20b989a ("of: address: Preserve the flags portion on 1:1 dma-ranges mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index dfd05cb2b2fc..cfe5a11b620a 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -217,10 +217,6 @@ static u64 of_bus_pci_map(__be32 *addr, const __be32 *range, int na, int ns,
 	return da - cp;
 }
 
-static int of_bus_pci_translate(__be32 *addr, u64 offset, int na)
-{
-	return of_bus_default_translate(addr + 1, offset, na - 1);
-}
 #endif /* CONFIG_PCI */
 
 /*
@@ -344,11 +340,6 @@ static u64 of_bus_isa_map(__be32 *addr, const __be32 *range, int na, int ns,
 	return da - cp;
 }
 
-static int of_bus_isa_translate(__be32 *addr, u64 offset, int na)
-{
-	return of_bus_default_translate(addr + 1, offset, na - 1);
-}
-
 static unsigned int of_bus_isa_get_flags(const __be32 *addr)
 {
 	unsigned int flags = 0;
@@ -379,7 +370,7 @@ static struct of_bus of_busses[] = {
 		.match = of_bus_pci_match,
 		.count_cells = of_bus_pci_count_cells,
 		.map = of_bus_pci_map,
-		.translate = of_bus_pci_translate,
+		.translate = of_bus_default_flags_translate,
 		.has_flags = true,
 		.get_flags = of_bus_pci_get_flags,
 	},
@@ -391,7 +382,7 @@ static struct of_bus of_busses[] = {
 		.match = of_bus_isa_match,
 		.count_cells = of_bus_isa_count_cells,
 		.map = of_bus_isa_map,
-		.translate = of_bus_isa_translate,
+		.translate = of_bus_default_flags_translate,
 		.has_flags = true,
 		.get_flags = of_bus_isa_get_flags,
 	},
-- 
2.39.5



