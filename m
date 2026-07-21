Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E543E068;
	Tue, 21 Jul 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673506; cv=none; b=R244jQyxlYrgOSKKP0kUAVYzcy4lhBu7fio13jbh128QYW1iyJv/CxjBZX+F2JPnQAHDBh13AIRboYamgkT+XgL5b4azO2EP5I/fslQ0d1qhrkXILMvQCee/FLrfZmXi4lNT/52FCIKKURaEc7yE3/2i7HfkoAGNVl15I1ns+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673506; c=relaxed/simple;
	bh=ITvOcmSn0HqG3RGbNR1sM8M4tUrInQA7X8I44wVxaTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwJPD64GaH7nC3+Cv+WWrtib0/X222AXLlcEeaKx8jx45Ewvu9larJA095N1M/gE/zvsjG4zzW2iLE7N3+NDDFIbElY2ckcIs2K6zz8JMe8uweDVYz/njBdDFWiYFBFgYEEzVf7nGJTa9ep/dTgRL2b2tIJXUDWjk2OimIx8zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EL3cUaAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EL3cUaAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE9F1F00A3A;
	Tue, 21 Jul 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673490;
	bh=ZxvKptKltIPW04WoPiuHRxvYwgjvHtrbkeJBVQyfrMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EL3cUaAe659/b4U1690csJorpfrmO3Y7/VjtNGsevOn9F3NTpm1TI6Z3+QxJopbVA
	 LFpGJiqiTkVNcuGs1j94wBaOGOyrqSZOq7mp8dAp9oGn3gVCHz4GpE/GdSc0uo6Itl
	 IcZn7/AWnaygUR+Spq/cIVIWodNQ2uBxAYDQ8vvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/699] clk: scmi: Fix clock rate rounding
Date: Tue, 21 Jul 2026 17:19:02 +0200
Message-ID: <20260721152359.827215999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit d0c81a38d06d446d341532700b3a4a43d3b00eb1 ]

While the do_div() helper used for rounding expects its divisor argument
to be a 32bits quantity, the currently provided divisor parameter is a
64bit value that, as a consequence, is silently truncated and a possible
source of bugs.

Fix by using the proper div64_ul helper.

Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Fixes: 7a8655e19bdb ("clk: scmi: Fix the rounding of clock rate")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260508153300.2224715-2-cristian.marussi@arm.com
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-scmi.c b/drivers/clk/clk-scmi.c
index c62636fb4aca8d..659f26d839eb5b 100644
--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -9,9 +9,9 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/scmi_protocol.h>
-#include <asm/div64.h>
 
 struct scmi_clk {
 	u32 id;
@@ -59,7 +59,7 @@ static long scmi_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 
 	ftmp = rate - fmin;
 	ftmp += clk->info->range.step_size - 1; /* to round up */
-	do_div(ftmp, clk->info->range.step_size);
+	ftmp = div64_ul(ftmp, clk->info->range.step_size);
 
 	return ftmp * clk->info->range.step_size + fmin;
 }
-- 
2.53.0



