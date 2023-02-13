Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8378F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A14C433D2;
	Mon, 13 Feb 2023 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300375;
	bh=ymx/KVjlvPR1PgNJ2dutXtAwc/uINXNTi0oCV538hPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVcsLendBzwRiBKPTUxLq+/CbtjLYUonA/7YIrCTGhdCE3Nx1UWqMCDennJ1zLGhn
	 uaR72kInIev9lgNhENxQSeHi5pDL1TdTCIhZ8qe9oSLtpgjYetAFayKB/7FgfIzWX1
	 4IAlzrnHBh5hKcOc0OVPcibuQB+UAgsfJvimDCRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 55/67] clk: ingenic: jz4760: Update M/N/OD calculation algorithm
Date: Mon, 13 Feb 2023 15:49:36 +0100
Message-Id: <20230213144734.997035467@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

commit ecfb9f404771dde909ce7743df954370933c3be2 upstream.

The previous algorithm was pretty broken.

- The inner loop had a '(m > m_max)' condition, and the value of 'm'
  would increase in each iteration;

- Each iteration would actually multiply 'm' by two, so it is not needed
  to re-compute the whole equation at each iteration;

- It would loop until (m & 1) == 0, which means it would loop at most
  once.

- The outer loop would divide the 'n' value by two at the end of each
  iteration. This meant that for a 12 MHz parent clock and a 1.2 GHz
  requested clock, it would first try n=12, then n=6, then n=3, then
  n=1, none of which would work; the only valid value is n=2 in this
  case.

Simplify this algorithm with a single for loop, which decrements 'n'
after each iteration, addressing all of the above problems.

Fixes: bdbfc029374f ("clk: ingenic: Add support for the JZ4760")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20221214123704.7305-1-paul@crapouillou.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/ingenic/jz4760-cgu.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/ingenic/jz4760-cgu.c b/drivers/clk/ingenic/jz4760-cgu.c
index ecd395ac8a28..e407f00bd594 100644
--- a/drivers/clk/ingenic/jz4760-cgu.c
+++ b/drivers/clk/ingenic/jz4760-cgu.c
@@ -58,7 +58,7 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 		       unsigned long rate, unsigned long parent_rate,
 		       unsigned int *pm, unsigned int *pn, unsigned int *pod)
 {
-	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 2;
+	unsigned int m, n, od, m_max = (1 << pll_info->m_bits) - 1;
 
 	/* The frequency after the N divider must be between 1 and 50 MHz. */
 	n = parent_rate / (1 * MHZ);
@@ -66,19 +66,17 @@ jz4760_cgu_calc_m_n_od(const struct ingenic_cgu_pll_info *pll_info,
 	/* The N divider must be >= 2. */
 	n = clamp_val(n, 2, 1 << pll_info->n_bits);
 
-	for (;; n >>= 1) {
-		od = (unsigned int)-1;
+	rate /= MHZ;
+	parent_rate /= MHZ;
 
-		do {
-			m = (rate / MHZ) * (1 << ++od) * n / (parent_rate / MHZ);
-		} while ((m > m_max || m & 1) && (od < 4));
-
-		if (od < 4 && m >= 4 && m <= m_max)
-			break;
+	for (m = m_max; m >= m_max && n >= 2; n--) {
+		m = rate * n / parent_rate;
+		od = m & 1;
+		m <<= od;
 	}
 
 	*pm = m;
-	*pn = n;
+	*pn = n + 1;
 	*pod = 1 << od;
 }
 
-- 
2.39.1



