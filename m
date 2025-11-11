Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886B130E82E;
	Tue, 11 Nov 2025 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823712; cv=none; b=MmmXMR6AukDMsjPK3147R0gjz4O4v8rsImAn4pyewsYRawfcWGKhFGPNySapRMuTUS6phf0r5puQQVuqwY0wFy6v6CvTLj9eFkCnSXGsIE4R2nX97fdh5ZSyhWbrc/kX7DKQkIhr+8IHCg0ngjiTokuAZec+ECW2AO/3JTxUODU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823712; c=relaxed/simple;
	bh=zySNiCsldtvD+yfbp5bZj8dORD9qJ2O7NsplrNtQxLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWAp9LwyPGF8fU5XBeZ2aRgNw9yyYM+hRfj9kiBgsxzMKJCLhbKtBn1sERFNFzc4o7BuJeTSSYWj6rYDnHMxELo9vtdM+jr4HFUqTdjb6eU2isnj0bEs2jE9AOn5XoMkdo1XkH/Wsna3jHk5ltFHm7RzXjs4VdN1Xz+zOrxWhno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqJXhHsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqJXhHsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28215C4CEFB;
	Tue, 11 Nov 2025 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823712;
	bh=zySNiCsldtvD+yfbp5bZj8dORD9qJ2O7NsplrNtQxLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqJXhHsyHkZ9MRxlvfyH3OKySBbQQL1P4a25YSHxbwlA0wChhYy+LtEu7joe0gCuE
	 OwJ7xVYVsFeXurZgIKY5jNQNu9db4/LNbUCwpcXEsrjuiTjN8vBaBmMQWrBkRPuRZO
	 9vTmAXjyuEZqs2iZqFntoxwllMTq+zqjbUx1WlKY=
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
Subject: [PATCH 6.12 305/565] iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs
Date: Tue, 11 Nov 2025 09:42:41 +0900
Message-ID: <20251111004533.741830219@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index eb1e62cd499a5..e8d7bcbee1a22 100644
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
@@ -1073,6 +1075,9 @@ static irqreturn_t apple_dart_t8110_irq(int irq, void *dev)
 		error, stream_idx, error_code, fault_name, addr);
 
 	writel(error, dart->regs + DART_T8110_ERROR);
+	for (int i = 0; i < BITS_TO_U32(dart->num_streams); i++)
+		writel(U32_MAX, dart->regs + DART_T8110_ERROR_STREAMS + 4 * i);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.51.0



