Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506DE257437;
	Fri, 17 Oct 2025 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716247; cv=none; b=rwkSeCxa1QH2dxyq0V1M94eUwdEGikfHDJj+/NibWmdhVAqWLjGTaM6hCTsX1e6qtc6xgamFQWsKOVhq5CqwQiQn9vFDby+2zbU/i3P8K6yBUi+oNNzfh/Td6ndDqeoH+o+AT8cdvey7NY9zFlGWJGVZZSWrLRedMEVu/7N5AMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716247; c=relaxed/simple;
	bh=I1TaytGV5QJX2+8NcXEtp+PJw9OzDX8kslkSDxO5UBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFWMeKOWZgAMAPH1lY6fKaYexRTWq/JmNTqFGAkLVhQSTYzzHzfb8LVWLXUxzRRNRXRjETiwEeumihFnZiOTfPWzgN7dAcyO8XVqKvgrcS0l99ESJJ83dqp9ZOTJ7wYabWw1prc8auXsz52lRIoDRWQ9P6I8RM0tAQMnYLOW690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8rHVrwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8rHVrwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFA5C4CEE7;
	Fri, 17 Oct 2025 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716247;
	bh=I1TaytGV5QJX2+8NcXEtp+PJw9OzDX8kslkSDxO5UBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8rHVrwHYZRx/OTqmgxL1KiHtMQ+lbWmjGjUqZRuLBFC0+XPeyrsdTSVqFrQtN5IE
	 O8ahYA1brI9jo5qDlfo7LrljtdUkTdJCqMf1ah01uwaccXLhBtcAAvLO3o19BIaLR3
	 TSmd/KyIZm3DmebmTbb+/s6mJip4nW7jevv5QbWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/276] clk: at91: peripheral: fix return value
Date: Fri, 17 Oct 2025 16:53:38 +0200
Message-ID: <20251017145147.044245739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 47b13635dabc14f1c2fdcaa5468b47ddadbdd1b5 ]

determine_rate() is expected to return an error code, or 0 on success.
clk_sam9x5_peripheral_determine_rate() has a branch that returns the
parent rate on a certain case. This is the behavior of round_rate(),
so let's go ahead and fix this by setting req->rate.

Fixes: b4c115c76184f ("clk: at91: clk-peripheral: add support for changeable parent rate")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-peripheral.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 7a27ba8e05779..7605ab23dc8ed 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -268,8 +268,11 @@ static int clk_sam9x5_peripheral_determine_rate(struct clk_hw *hw,
 	long best_diff = LONG_MIN;
 	u32 shift;
 
-	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
-		return parent_rate;
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		req->rate = parent_rate;
+
+		return 0;
+	}
 
 	/* Fist step: check the available dividers. */
 	for (shift = 0; shift <= PERIPHERAL_MAX_SHIFT; shift++) {
-- 
2.51.0



