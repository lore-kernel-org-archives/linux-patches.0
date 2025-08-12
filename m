Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1260D2FAC06;
	Tue, 12 Aug 2025 18:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024751; cv=none; b=cGA/b1UVoUwGTlhuMFaXf//imLfA/0Hx0JX/QeM6nfjlBDRWkIcVlymHx6s4Dc7OjkfEQgLhUN+Dwj2jueBpRs4gRLbTkDYWxGNlBk1/ygvIwCyDZyY6COurmI0WY/J0p8mWOkcbFVTMCMU2i5RT4SuJ+jeCJyrM3kSb6VaENlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024751; c=relaxed/simple;
	bh=Dj0RjNbHHkWAzjql6CXrt3Mpy61jeIBT96ecaoHxcp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uigl3M/uR+EZAXkpxKdXtJBahF7G8W2GR45TxeuJEjRDthjarpWmvqRYZOIZ3kxkiFPpnWNcohnQnsEEyykIUKwFkgrtB+c4dWCdn5Rc+fj8GMokC0MnnLRydGFg9gvNPgpesX/wKyAqianWLVk1P41n1m5TvCGWyWBQPKab8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3fipSqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3fipSqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB6EC4CEF0;
	Tue, 12 Aug 2025 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024750;
	bh=Dj0RjNbHHkWAzjql6CXrt3Mpy61jeIBT96ecaoHxcp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3fipSqCBeVP8to3EBhxF6/GIP5udoquHEDu5IF+wnhqqGHASjdKaPl2n+lLhZvcE
	 sWKiILL/0ir6esR2SJLAhUA25594SB0RPqj+T00DnpGwSc1scKod7iEoWuroRfjX8d
	 QTgr/84P5CZxD4lnYnsOR0UxzDSO/AUYsooFCHP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 467/627] rtc: nct3018y: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:32:42 +0200
Message-ID: <20250812173440.374171564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 437c59e4b222cd697b4cf95995d933e7d583c5f1 ]

When nct3018y_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: 5adbaed16cc63 ("rtc: Add NCT3018Y real time clock driver")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-3-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-nct3018y.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-nct3018y.c b/drivers/rtc/rtc-nct3018y.c
index 76c5f464b2da..cea05fca0bcc 100644
--- a/drivers/rtc/rtc-nct3018y.c
+++ b/drivers/rtc/rtc-nct3018y.c
@@ -376,7 +376,7 @@ static long nct3018y_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int nct3018y_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



