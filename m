Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D3830CDA1;
	Tue, 11 Nov 2025 01:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824174; cv=none; b=NjSoFCtITvmFjkaZ21saIEDMXcPy2hWVtOwh5VNSilIclXBC08uV1HMnYqWDG+wrC3gibi8UakWQ55LB5SXfiU2Q79bbY3Y+fcPIIsnp3YKBhLhkPaEDnPElqwdx/PQ72DAIi/Lu46DiRDZf2Kqbwf64/z8v+mrgil/oADBa9TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824174; c=relaxed/simple;
	bh=94ojWWIbS4aCMJr6H9yldB0TJMiybIZoD60U+UQkre4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtDDoof70nkHWX58xBB89rxZi+pi9efu05CgnNByutd/4c7HaWgLMRQfE3V8dn+byLz6I9UEReAuB8uV35zGF1FvxbdtBO+UJrtYjdkdrZ4CHgz9lZSiPrsbGC1cPJZeTVZZQCiWpJdKGbV3Oqm33tgk5uvlPRgtyKzeBkvhVtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzTgvvik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzTgvvik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6DEC113D0;
	Tue, 11 Nov 2025 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824174;
	bh=94ojWWIbS4aCMJr6H9yldB0TJMiybIZoD60U+UQkre4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzTgvviktVkHPb1R4MIdaeVEiYnupTCI2qeC25N1arZ4g4CV3PRsWSjizFitsV4Rd
	 oCzSL1k7M+/592PaRnXXvNOfJw9HeZaSUpcgP5gEbB194c1P/gq253V2xZ7bGRsOae
	 XBW8Sp7IkVMuL2/zFXOogV7tRTP8RwpcYyc0F2vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 451/849] iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs
Date: Tue, 11 Nov 2025 09:40:21 +0900
Message-ID: <20251111004547.334939003@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit ecf6508923f87e4597228f70cc838af3d37f6662 ]

These registers exist and at least on the t602x variant the IRQ only
clears when theses are cleared.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Link: https://lore.kernel.org/r/20250826-dart-t8110-stream-error-v1-1-e33395112014@jannau.net
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/apple-dart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
index 190f28d766151..8b1272b7bb44a 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -122,6 +122,8 @@
 #define DART_T8110_ERROR_ADDR_LO 0x170
 #define DART_T8110_ERROR_ADDR_HI 0x174
 
+#define DART_T8110_ERROR_STREAMS 0x1c0
+
 #define DART_T8110_PROTECT 0x200
 #define DART_T8110_UNPROTECT 0x204
 #define DART_T8110_PROTECT_LOCK 0x208
@@ -1077,6 +1079,9 @@ static irqreturn_t apple_dart_t8110_irq(int irq, void *dev)
 		error, stream_idx, error_code, fault_name, addr);
 
 	writel(error, dart->regs + DART_T8110_ERROR);
+	for (int i = 0; i < BITS_TO_U32(dart->num_streams); i++)
+		writel(U32_MAX, dart->regs + DART_T8110_ERROR_STREAMS + 4 * i);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.51.0



