Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD72913D635;
	Thu, 13 Jun 2024 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280479; cv=none; b=T6C+vfW3ZRrviupn6MVe9LDgu8yL+dnYUC84sJXsN25BNQBtTdnjX5lsopIFAi+0DVXKoB9thTJmwB2/Rcv7fjdeoHla4rCC5S1hNP0byyVPZc/3wDlWHoQbhNpPOZax/xhZ5n/e+sPJRG5EMnvdWg4BtJZ+uQiRr5oMPMedSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280479; c=relaxed/simple;
	bh=BDoma/6ZSQoW+gsljdlHF793t/dAmvznBwiV7qN4OUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArhhoV+iY7pM6BX2PyP/CZQ1IXAPbbGUA5cPNzQDvIwt13QphZFXTMfsiZVswC/jvHT7hlIHThIYh4clA8r7SBVFFrZIArISYQj8tx62Q2qtTMaOfQ2ASjxSi3ZX+675yj8IvBwkqARC04vLRvMri7SgIJawGVtkysXBRcVhwsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTDqEcIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTDqEcIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D0CC2BBFC;
	Thu, 13 Jun 2024 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280479;
	bh=BDoma/6ZSQoW+gsljdlHF793t/dAmvznBwiV7qN4OUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTDqEcIHVnHUfkc50hVcOWDQcMnrm6xZg4RYZkKeJCNLjzJGgP0J++Lx3UzZVvgaX
	 ZqRzBqwds02QMBSr+CyvjcJxR5/ML+/4Tch5zR9CpR1Gl3L75FR/IRHtCbySk8FrTi
	 Fgysz4QyfcOHL0pJ3F2+wnnjqqZ+9DsD4sb4RlPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 067/137] clk: bcm: rpi: Assign ->num before accessing ->hws
Date: Thu, 13 Jun 2024 13:34:07 +0200
Message-ID: <20240613113225.898955993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 6dc445c1905096b2ed4db1a84570375b4e00cc0f upstream.

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer about the number
of elements in hws, so that it can warn when hws is accessed out of
bounds. As noted in that change, the __counted_by member must be
initialized with the number of elements before the first array access
happens, otherwise there will be a warning from each access prior to the
initialization because the number of elements is zero. This occurs in
raspberrypi_discover_clocks() due to ->num being assigned after ->hws
has been accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-raspberrypi.c:374:4
  index 3 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

Move the ->num initialization to before the first access of ->hws, which
clears up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20240425-cbl-bcm-assign-counted-by-val-before-access-v1-2-e2db3b82d5ef@kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 829406dc44a2..4d411408e4af 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -371,8 +371,8 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 			if (IS_ERR(hw))
 				return PTR_ERR(hw);
 
-			data->hws[clks->id] = hw;
 			data->num = clks->id + 1;
+			data->hws[clks->id] = hw;
 		}
 
 		clks++;
-- 
2.45.2



