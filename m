Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290ACDDC1;
	Tue, 27 Aug 2024 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769999; cv=none; b=awAC4So5b0WEGJtMe8u6Z4fIuAHRVhGEQOt6EedhEq4nJGcNOzJX5wGxt1SU4nDHggVVRrAKqmi+KUR2OlXmOJ3hXBANAOToZs2gUMw7XAxJiDAfIrxT7tj0kg03uhlnxE+y/71nc8U+Re9BAgRdusblidlpTg1MOk5FHVj4SNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769999; c=relaxed/simple;
	bh=SbuzdZ/qifsWudlJkh9o0jb53ym5EJ7Kpt5rPxntN3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufee9FZLkDxzzyDQ+8t4VMKWGZiie4WZor8R5mCV0CPKcuXRr0dpmuL5J53NocjWCPyMvKKjiJUl6mjt8v138BM1STwlgn+r9KqjWPakaoeVsNbTDvuwaLayW9H3cisE17LdHi+Hq7b1ArG4TteMoCSDOq/45wtE59D/y0h7Sko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgPNTniP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgPNTniP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F148C6106D;
	Tue, 27 Aug 2024 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769999;
	bh=SbuzdZ/qifsWudlJkh9o0jb53ym5EJ7Kpt5rPxntN3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgPNTniPnUcJkMwxsBMduqOfWTFyiQU5PZQ/+KG/paga8NemWlPDvfoaqjDnvrOYO
	 dIicPJ/KpZvDM/nNLOkgamAAzVTILpNOqrxG5xlJhhlq59DPriW/uL3pBuLB7HlHGP
	 9WwQaIBxD6lOm69osnqcoG13mG9+EP0q4EabfWQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/341] i2c: riic: avoid potential division by zero
Date: Tue, 27 Aug 2024 16:35:29 +0200
Message-ID: <20240827143847.135995576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 7890fce6201aed46d3576e3d641f9ee5c1f0e16f ]

Value comes from DT, so it could be 0. Unlikely, but could be.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-riic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-riic.c b/drivers/i2c/busses/i2c-riic.c
index f0ee8871d5ae1..e43ff483c56ec 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -313,7 +313,7 @@ static int riic_init_hw(struct riic_dev *riic, struct i2c_timings *t)
 	 * frequency with only 62 clock ticks max (31 high, 31 low).
 	 * Aim for a duty of 60% LOW, 40% HIGH.
 	 */
-	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz);
+	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz ?: 1);
 
 	for (cks = 0; cks < 7; cks++) {
 		/*
-- 
2.43.0



