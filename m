Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5787393DF2;
	Tue, 26 Aug 2025 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214609; cv=none; b=fBzt0CWEdjggGz8hLIO/tbVoQ63wIAPJmJgD+j12wwUb+iR3cBocC8rIBQ4B9er8QMtEXaPqwomV0xp6pWweqTrnokcykBFjD8GaLjZ2hRcIM2vAhs2gbiObHDJMFtMQNkIzABNUNE3Mkt9JYARaPXEN6T4j3vrVdEdrMuAM+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214609; c=relaxed/simple;
	bh=rZRjRGqdwoIV5o/FrvCZ+Vv4LkHC7LNv9e5oTdDXnjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9T7K8cS6SP/1Y3FVpuqtiM9JtziLQduYZIVbav+9H+U6f7N8PVZA/n2KipQwTZINhxyQcQ9rCj16Ia/+iL8nfGHB8rlceB+ikBiRy64NZ/alSAR9+4UOc7pTT11N7EuPnaXQJ4eyJJcUFN8lyQCMgHmpcjuEwglwveGmWgxEXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4Ugd+rR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4Ugd+rR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018ABC4CEF1;
	Tue, 26 Aug 2025 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214609;
	bh=rZRjRGqdwoIV5o/FrvCZ+Vv4LkHC7LNv9e5oTdDXnjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Ugd+rRWAVI7ohjvhBG+CMlngJ7u72x3odVij0Gpg7KRbtksHC2vmwXJdmYAg7vP
	 do8ntetfN+xjgkKkb09KpF6K9+t8tmrslveC1WUdd8sTIJHmKS2Bc41PWxhH9DBRI1
	 1NpKkhl803kqu/KIJZ1v1mDx0A9uG1Lb1FnhEkEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/482] media: tc358743: Increase FIFO trigger level to 374
Date: Tue, 26 Aug 2025 13:07:35 +0200
Message-ID: <20250826110935.780146101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 86addd25314a1e77dbdcfddfeed0bab2f27da0e2 ]

The existing fixed value of 16 worked for UYVY 720P60 over
2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
1080P60 needs 6 lanes at 594MHz).
It doesn't allow for lower resolutions to work as the FIFO
underflows.

374 is required for 1080P24 or 1080P30 UYVY over 2 lanes @
972Mbit/s, but >374 means that the FIFO underflows on 1080P50
UYVY over 2 lanes @ 972Mbit/s.

Whilst it would be nice to compute it, the required information
isn't published by Toshiba.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358743.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 0f9fd9cb77b3..d13e8f19278f 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1939,8 +1939,19 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	state->pdata.refclk_hz = clk_get_rate(refclk);
 	state->pdata.ddc5v_delay = DDC5V_DELAY_100_MS;
 	state->pdata.enable_hdcp = false;
-	/* A FIFO level of 16 should be enough for 2-lane 720p60 at 594 MHz. */
-	state->pdata.fifo_level = 16;
+	/*
+	 * Ideally the FIFO trigger level should be set based on the input and
+	 * output data rates, but the calculations required are buried in
+	 * Toshiba's register settings spreadsheet.
+	 * A value of 16 works with a 594Mbps data rate for 720p60 (using 2
+	 * lanes) and 1080p60 (using 4 lanes), but fails when the data rate
+	 * is increased, or a lower pixel clock is used that result in CSI
+	 * reading out faster than the data is arriving.
+	 *
+	 * A value of 374 works with both those modes at 594Mbps, and with most
+	 * modes on 972Mbps.
+	 */
+	state->pdata.fifo_level = 374;
 	/*
 	 * The PLL input clock is obtained by dividing refclk by pll_prd.
 	 * It must be between 6 MHz and 40 MHz, lower frequency is better.
-- 
2.39.5



