Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A166306D3F;
	Tue, 26 Aug 2025 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217469; cv=none; b=VY8G/xWmaJYMgGiKCFNwaoz7LwZMTqYnb8okGLAzi6E8FMmRPBApPjNW77VPVaS99cxMA7uCFoRnRbKWOpB1iHPu0fbp/SHjTpIHwfsCxjlUGq8K9ggOAAHWmUli81ghXb6BQ1Wv+zi0ClwAcERVnLm7gXjUq0I4ks7rh4qwlFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217469; c=relaxed/simple;
	bh=06Kowqjy4EAkCJxmUxiDfSEzclUQwiHwPFUclxZ3uN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keDyICNJVTdsYzxPC9fNduViyDXWqMGAqKlmQlokQJTDE28ytb7nqS7So0BxnD5Lyk2GoKIkkOTnyNDZeZkoa5cEePzBNSKNhAmzopZDEdq0mq0X1E4KVtGGjCzfOcnsJcjP/w0oUw8LexNbgoe+5Roo2bIiUA1sa9qTsCcuzjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwbHEhom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwbHEhom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88494C4CEF1;
	Tue, 26 Aug 2025 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217468;
	bh=06Kowqjy4EAkCJxmUxiDfSEzclUQwiHwPFUclxZ3uN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwbHEhomdpu4U0GzuTsPUGFMt81GPgbe/V6lKeNY8PIql9uC3wX3ceDcdhMymwEyt
	 kLIFrEQjR31Zs5LAU+WsjnWtUBSSJIYfYss0zE/ZUQVuKG71OMUQ2arZKSwMb+RRhg
	 Kic/ynfGQySSbgRH721T2G3/GErmYX16OblemjBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/523] rtc: rv3028: fix incorrect maximum clock rate handling
Date: Tue, 26 Aug 2025 13:06:04 +0200
Message-ID: <20250826110928.278038682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fa226f0fe67d..56fa66b6cadf 100644
--- a/drivers/rtc/rtc-rv3028.c
+++ b/drivers/rtc/rtc-rv3028.c
@@ -672,7 +672,7 @@ static long rv3028_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
 		if (clkout_rates[i] <= rate)
 			return clkout_rates[i];
 
-	return 0;
+	return clkout_rates[0];
 }
 
 static int rv3028_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



