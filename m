Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096713431FD;
	Tue, 26 Aug 2025 13:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215897; cv=none; b=TccbS8FlJNMpXOxCoyO22zPKz6lmV1fgf+1jr580lGePpAJTq0ceAIFid3H1Nw6JOAHt1IrOi9Vd9SRS/rD9woUwLftv9l9jW+AoJ6ojHvLvW3jPAwaVuZlLJCshBa9KBjkv6dapWqPaFLRY91o1qaq0FdSMMFD7sCO6bj1Kj4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215897; c=relaxed/simple;
	bh=XUUwuuQhXeMhU7yUX6JdWrdgnn3c2a08WPUK5333qRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udRlwJe0Pql0Txkjv0loXIlrZDtXmK/PGZU4F0EcgM6xh/25EZjmH8E1fBlKqoAYST30LOP0eH/rOlQbzZOW9G9U3QynofxsPS13wgJPse3ouzc6D7IfpDozuc1SVJsz/gPlo0LgAG/qN5MyqWnBychgrw+F1ceJESIR1XJEpBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7QjAsqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7QjAsqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF6BC4CEF1;
	Tue, 26 Aug 2025 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215896;
	bh=XUUwuuQhXeMhU7yUX6JdWrdgnn3c2a08WPUK5333qRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7QjAsqc5aksdP+8QPuKLsTARP+XgCFV/lp1HHvHOGiRxexliAHknImcEQ1HsPd31
	 IF4sMmnvou3jB3pr+UBMOrN/IUcdghx+gE6hecTXRN1wiFIQPgxIuNrh6W9PGHcior
	 6uoUGYR2HNUvlPnMEyQuhCP3toyYdccQ8OPtFI4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/644] rtc: hym8563: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:04:59 +0200
Message-ID: <20250826110951.597345243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit d0a518eb0a692a2ab8357e844970660c5ea37720 ]

When hym8563_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: dcaf038493525 ("rtc: add hym8563 rtc-driver")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-2-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-hym8563.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index 0751cae27285..93fd182d440b 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -312,7 +312,7 @@ static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int hym8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



