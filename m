Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D09253956;
	Tue, 29 Apr 2025 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945874; cv=none; b=j+xhxK8NfLR2xFviwMZY9OpNa4qlG6cvDsxnsXjXtaPe4Vj1TEDtYLzBwfoYoBSRjA7KZc9NJSEITWwpFHv1o2vJVsNo+KkLnyDU9eI+tfA9t114BY1DWgoMyTBL3SHhOMK977jRqxts7SF3tHE+n0nXjoh6/SH6oRNqG5KEDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945874; c=relaxed/simple;
	bh=X28t/Sm99cCSDrHT36+EQ9HBvLUgZLSI0DYd9vsr4C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLUT4VximbBEltHKqi5f82TE7t7awuUy07L0cJYF/8V1nLmyPZkyfUoENHkRWzjHcVlXB2eDtKnG1mCmxA8FQ+SUXPLdf/IEQlHdaoLDTO8LQqZJwXyyqjjop5tFl3IozRc3avyGAj5zGQuJQllUVeRpa/stog21xUCze+9K/aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ6vQBP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ6vQBP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA6BC4CEE9;
	Tue, 29 Apr 2025 16:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945874;
	bh=X28t/Sm99cCSDrHT36+EQ9HBvLUgZLSI0DYd9vsr4C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ6vQBP6Ct3zlo17VNkAD1e63i2W1A44iroe6Qxwr+oIxYf1xIn/yQ5OKbqV9Fcna
	 yvwzEzFewZ+H+BI5EHWrO2NiOZ8QA0dP4xGrn6iFK8CmUtKt+9o8NVsgdUuVLFJjIc
	 RZGU7xZNbxZNVEWCF/BJkq2yRTv6wLUQyd98ejrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 078/311] net: stmmac: fix dwmac1000 ptp timestamp status offset
Date: Tue, 29 Apr 2025 18:38:35 +0200
Message-ID: <20250429161124.238583209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothore <alexis.lothore@bootlin.com>

[ Upstream commit 73fa4597bdc035437fbcd84d6be32bd39f1f2149 ]

When a PTP interrupt occurs, the driver accesses the wrong offset to
learn about the number of available snapshots in the FIFO for dwmac1000:
it should be accessing bits 29..25, while it is currently reading bits
19..16 (those are bits about the auxiliary triggers which have generated
the timestamps). As a consequence, it does not compute correctly the
number of available snapshots, and so possibly do not generate the
corresponding clock events if the bogus value ends up being 0.

Fix clock events generation by reading the correct bits in the timestamp
register for dwmac1000.

Fixes: 477c3e1f6363 ("net: stmmac: Introduce dwmac1000 timestamping operations")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250423-stmmac_ts-v2-1-e2cf2bbd61b1@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 600fea8f712fd..2d5bf1de5d2e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -331,8 +331,8 @@ enum rtc_control {
 
 /* PTP and timestamping registers */
 
-#define GMAC3_X_ATSNS       GENMASK(19, 16)
-#define GMAC3_X_ATSNS_SHIFT 16
+#define GMAC3_X_ATSNS       GENMASK(29, 25)
+#define GMAC3_X_ATSNS_SHIFT 25
 
 #define GMAC_PTP_TCR_ATSFC	BIT(24)
 #define GMAC_PTP_TCR_ATSEN0	BIT(25)
-- 
2.39.5



