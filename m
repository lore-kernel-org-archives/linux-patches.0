Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ED519F485;
	Tue, 27 Aug 2024 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772121; cv=none; b=iE1aLpu8wok/ePx+dCRfmMbHJ9Pvbr99hK1p1xdzAYMhPGSJ9yvb09IwPKWwkcodsGFs/aAZU5YvgzxAcKRDkj3YgflXL9IETrVXlZlN0EcRz2TMuIQaLDUjuqZiNvvAuC29R4kV4wpP5RvYQhiBGNdE7imhL9Hp03WqLiZf0Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772121; c=relaxed/simple;
	bh=Pygm6PpR1+Phjpd3Pya3Yid+V4A+8Vs2QLfYbaeDyAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpiNxYYzotWCp4rmml2a8DNgVQnjE4e8F8mV6pQ6KFWsFqoM8kuiAKxJNVY0qQR2Ntk/5oIi5al+Lki23uoamh2Ha0DFLq96IKCCbkENYbz+Bys9T0BeEhsSacOW8FKIWCO6fjTxiV8njzh4rWrU+/N4ckuA8ajyh7v82BEAVGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUcmgmP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUcmgmP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D09C4FE08;
	Tue, 27 Aug 2024 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772120;
	bh=Pygm6PpR1+Phjpd3Pya3Yid+V4A+8Vs2QLfYbaeDyAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUcmgmP2wyKSGxdWnOGb+h0QGneeKF5UhDDQhbBTFO/OwXsWd651Kpd+8FBS/d0Vn
	 gSeAKcMeH88OUqvk39l+8FoYyhq+20IV7NojlvBDh8ylA2ff/3+DDb7xwLPzNLWig3
	 Z5fGOCTby2q9vWQpTC8GRgxjkBy9gnssIz20dn1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/321] i2c: riic: avoid potential division by zero
Date: Tue, 27 Aug 2024 16:37:07 +0200
Message-ID: <20240827143842.772813277@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 849848ccb0802..b9959621cc5d7 100644
--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -314,7 +314,7 @@ static int riic_init_hw(struct riic_dev *riic, struct i2c_timings *t)
 	 * frequency with only 62 clock ticks max (31 high, 31 low).
 	 * Aim for a duty of 60% LOW, 40% HIGH.
 	 */
-	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz);
+	total_ticks = DIV_ROUND_UP(rate, t->bus_freq_hz ?: 1);
 
 	for (cks = 0; cks < 7; cks++) {
 		/*
-- 
2.43.0



