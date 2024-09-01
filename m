Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B5C17B50B;
	Sun,  1 Sep 2024 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209963; cv=none; b=ijYYgCphUyAF8AeRXQKoduRLNKTA6hLWw1KIYCHg021teB6HfOiRQQWpVPebUTfxa0j+Smkt9cZdrVyGe/Jx/+UgrSxgSzBV47W6nSwY0cZo5Gjlarn6oWyv/g1pf95mvtEdrp+b7hzUFSmpPz1pHabGBpc0qMm6IggxQV5IiWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209963; c=relaxed/simple;
	bh=cn51zkRozQ2pvUsNgV3An/rD9GAlJeTn/fSnzvIDzSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he/nZrypV2XzMhiWjTgI7B9KJ/iMmOKZfyJc6aWrM0AfDAsD+aUjuURwAs7/wOUGS+3Dd2Fmpov1pqTwhLcQXwEP5sjXrf4ZLkz70LiMLTRKdux2ekx5InY0VrDD0ZvPUVsGdBc55WD2A9OgVah5LeaTb4Uqcauf7+EshNZOAFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfrw9W+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfrw9W+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025CBC4CEC3;
	Sun,  1 Sep 2024 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209963;
	bh=cn51zkRozQ2pvUsNgV3An/rD9GAlJeTn/fSnzvIDzSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfrw9W+HQocr/xis+KMQFzBVggVOqnvPdxE7r4fi50cZiB0zYXxKchBz01vE3uqGS
	 bBgCQjflfPusBfuT1G1d4IUBCwYZnc+ALNSz4P/D2C12o2NbO2mDoSRIvNKFtnqYec
	 PsMpjSk7B/I9aJ8qgMm4Spcm7LSofUe8d2MN6XVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/215] i2c: riic: avoid potential division by zero
Date: Sun,  1 Sep 2024 18:15:59 +0200
Message-ID: <20240901160825.132029857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 78b84445ee6ab..1d3dbc1bfc259 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -319,7 +319,7 @@ static int riic_init_hw(struct riic_dev *riic, struct i2c_timings *t)
 	 * frequency with only 62 clock ticks max (31 high, 31 low).
 	 * Aim for a duty of 60% LOW, 40% HIGH.
 	 */
-	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz);
+	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz ?: 1);
 
 	for (cks = 0; cks < 7; cks++) {
 		/*
-- 
2.43.0



