Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF040343219;
	Tue, 26 Aug 2025 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215906; cv=none; b=JD7L6w88GPzsVsXO6c4t0gF+HCjF80UP1qGzS4t1jUDYuNNlVrWvIhRKJOgnjHmWS7qiUaZdRUmCXKaQCg+YaaRevzvN70u5ixQ8GTQzTRW4ARvnlhgZC6KuRLyvH1Qmb/PgEbCNsrihWG8u8FBKxmmhrWiQTmlPUuRpSo2K+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215906; c=relaxed/simple;
	bh=iN/uTxgqu5098RxegTUldWC6T5YaFUgLecyAEmbGo3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMhBsrfIMEec1LFjZXoKsCwTQxrn6v8g2TkB4rsmvH5tYIZ0BNhy43/P9vMmqyhzy+m+x4NZgfk7Fa3ybxUCrz5JKBBYkhyghrdHnsS57X2kamRlaBeLmLt4ETlFieOXfoXZ6hLd94MJqFHOISWSv9/g2fme45jHs+d3dW7avWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCewOloz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCewOloz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF9AC116B1;
	Tue, 26 Aug 2025 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215905;
	bh=iN/uTxgqu5098RxegTUldWC6T5YaFUgLecyAEmbGo3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCewOlozJ8GMF4vgPmdkN42aYJaI8aSfUoXqtRaVMt8zZibSwHXmmoQMEj+DS6HUJ
	 QYDYhdXj+arAJo938jFUCM06GS5qE7seyZOevIOY8zLp+yUyNxgSv9/PIxI37aGNUy
	 K2HYoa42bnBgdZCMpWdP/ic1XMGcikh1x2rB7BQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/644] rtc: rv3028: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:05:02 +0200
Message-ID: <20250826110951.667030335@linuxfoundation.org>
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
index 12c807306893..fdcca4bf1ce2 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -669,7 +669,7 @@ static long rv3028_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int rv3028_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



