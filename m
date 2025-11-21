Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02237342526;
	Fri, 21 Nov 2025 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732650; cv=none; b=ejaFY88aRyWAkaZjy91O3eomNgyTgMffVcWsTE8U4DOZwEDZjpfVxp9AhSwP3QGHdTr293MpI37w2th0ITjD9Vb9M8156aSHnFz7YsLgx/+hTzgFbyX1en75RpLy2MmnTOHsDpQGD5imTgWc2Xug6UUiyAHkYigg7NLf//ubHEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732650; c=relaxed/simple;
	bh=vkbOVhC4Kd4UAqlK3NE8exIvk9SCGFm84shPtbybdEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaMbJrLS5orKZ7wLkterBOvmYD6E8VKW6e5+wxmkntAB9rp4OQKg4jrb89Uoq7BpMP3NBuFIHCfAgo4JoL6N3kvqxLM9Ng0oIgc37YYuhvWcrpFopzJG1cZ1EHK5vdvgRfP/i9P2UZ1pa/tzqECmYq7BhAgT+hRqcNxcLNpfhtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a86fnrkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a86fnrkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C97C116C6;
	Fri, 21 Nov 2025 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732649;
	bh=vkbOVhC4Kd4UAqlK3NE8exIvk9SCGFm84shPtbybdEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a86fnrkOGF5hrdsCXFfhj3g9RWplJ+hfKEWelsCFsaHfg5c5arh7cgLOByXC+/nEZ
	 /48UM/ytmGrEsi57aHi7PnpW/ZuQcLHB2YOEaovBISiLGHaGcjgbbTrp4grJJhFXdk
	 KUJOQIegZ2O4mfrWyKax/nC2/H5n+3EvB/uFEA4A=
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
Subject: [PATCH 6.6 195/529] iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs
Date: Fri, 21 Nov 2025 14:08:14 +0100
Message-ID: <20251121130237.954780317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0b89275084274..0ea450cbb7786 100644
--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -121,6 +121,8 @@
 #define DART_T8110_ERROR_ADDR_LO 0x170
 #define DART_T8110_ERROR_ADDR_HI 0x174
 
+#define DART_T8110_ERROR_STREAMS 0x1c0
+
 #define DART_T8110_PROTECT 0x200
 #define DART_T8110_UNPROTECT 0x204
 #define DART_T8110_PROTECT_LOCK 0x208
@@ -1041,6 +1043,9 @@ static irqreturn_t apple_dart_t8110_irq(int irq, void *dev)
 		error, stream_idx, error_code, fault_name, addr);
 
 	writel(error, dart->regs + DART_T8110_ERROR);
+	for (int i = 0; i < BITS_TO_U32(dart->num_streams); i++)
+		writel(U32_MAX, dart->regs + DART_T8110_ERROR_STREAMS + 4 * i);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.51.0



