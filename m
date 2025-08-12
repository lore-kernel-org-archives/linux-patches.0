Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F83D994;
	Tue, 12 Aug 2025 19:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026460; cv=none; b=gZ794oJux0CfdEOVtnuzB51bbagcxjgatm9Z19hPdA8PmcxltjBOXQKSGZYPqq2uFo3gqWnCoDZvu3mg4whPjw5dZgdn03VUoIZDqPdOqAbAqRiRTQajSZccHccti3GUnjPR7PBkQk6haO7Z4eFE7+TKZgaFLl9tyD02vo1b2u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026460; c=relaxed/simple;
	bh=qyE3zz8FHBwcs3eq4WoJsOAlPvpnuR6PSYKcP6G+wFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa5c/j9Caa/2056d2A270TXrBOy2yTIR/DWL9NEfaGmBn+JyhfIO5iEgg2X/22zkefl2+3BGianzC0VwYiB1yXUKJ2dd32hfrYsPR08dlww4HLinE7/olJfOwV7J+sY2ZfzQTxBz/X3vEpytVxMtReyHIpwYkDNH9CoEtLCSjPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3naew5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3naew5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CDFC4CEF0;
	Tue, 12 Aug 2025 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026459;
	bh=qyE3zz8FHBwcs3eq4WoJsOAlPvpnuR6PSYKcP6G+wFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3naew5tw/jPuWEnIVlYKFryDfbchJcHDzkkDQhikuMUy8yko3eZcg1hTckudYmcM
	 iX7KmzMxyNKzRv3mscRoRwZ8gsTuGM3HJdVlir747AYV0B6staJjbtIroptx9w5nYq
	 HBjxodXRbXqhJLfC8Z4EEK4pkmg7eFyFuTcFooso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 344/480] rtc: rv3028: fix incorrect maximum clock rate handling
Date: Tue, 12 Aug 2025 19:49:12 +0200
Message-ID: <20250812174411.623897304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit b574acb3cf7591d2513a9f29f8c2021ad55fb881 ]

When rv3028_clkout_round_rate() is called with a requested rate higher
than the highest supported rate, it currently returns 0, which disables
the clock. According to the clk API, round_rate() should instead return
the highest supported rate. Update the function to return the maximum
supported rate in this case.

Fixes: f583c341a515f ("rtc: rv3028: add clkout support")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20250710-rtc-clk-round-rate-v1-6-33140bb2278e@redhat.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv3028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv3028.c b/drivers/rtc/rtc-rv3028.c
index 868d1b1eb0f4..278841c2e47e 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -740,7 +740,7 @@ static long rv3028_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int rv3028_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



