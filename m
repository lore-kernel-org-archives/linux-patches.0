Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFBE3AF666;
	Sat, 17 Oct 2026 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256323; cv=none; b=LF+w8+EgyQk3tLAmk28UNyAxcdvB7E+hUoDbBIerdPLi1WpqwGERE0SvA+BmA+eJQW5/0fw+Td1BKD5TCKe87ONplvp+qQ83Zv1n0GRab/NZhGUXEGI+rh+WOu/NWSixZn/WIefa9Y9RRhau+tP9GsbDluJV6C8mdO3afPniouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256323; c=relaxed/simple;
	bh=lGjd3nILj2dBB3W57pvV1HJu2+frQ/4nKrjSDQVWC+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLvr6Y8rucApYhv+iveVgxzPkNFbolB6VCRPxTek7spiZN2fxUlHsq+0ngCa1Hny8u785K6iPErcyu2UfhIHCY8oY0nMUMLQGWHp7M78Oibxo/Vw0c/9IjuCs81SFB3MTo9cFD0uqRy/86n5gR6Yfw6ffsbkI3gArykEX/otvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQa1r+an; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQa1r+an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886841F000C4;
	Sat, 17 Oct 2026 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256322;
	bh=Cn/3QCDYBx+nKxZjiUEHwxA94rnGCK/Vvroynmp9ti8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQa1r+ankOV06f94y4xfH0OkxpuIhnaQxMGy+9qWP+LZBBmOTf6UGFeJh2NtR5O7g
	 N4wAOQZNPViSTvAQ2XKSqeHnJCAqSohu4QzaGN29cCRwZ9umyTstCJ+FL8xGCllU1J
	 SEiZ8B+eP5BigsmrS7w2gRlCoZhDsXPmOY8k9YX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manush Prajwal <manushprajwal555@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0197/1674] rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()
Date: Sat, 17 Oct 2026 17:41:09 +0200
Message-ID: <20261017160436.210730298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manush Prajwal <manushprajwal555@gmail.com>

[ Upstream commit ac41b05d15db3134e839148290d67415ee0bdb58 ]

devm_clk_get(&pdev->dev, "rtcref")'s return value was passed straight
into clk_get_rate() without checking it for an error first, unlike the
"rtc" clock a few lines above which is correctly checked with
IS_ERR(). clk_get_rate() only guards against a NULL clk, not an error
pointer:

	if (!clk)
		return 0;
	...
	rate = clk_core_get_rate_recalc(clk->core);

so if devm_clk_get() ever returns an error pointer here (for example
ERR_PTR(-EPROBE_DEFER), which is the normal, expected outcome if the
clkcfg clock-provider this RTC depends on has not registered its
clocks yet by the time this driver probes), clk_get_rate() dereferences
that error pointer instead of returning 0, crashing instead of letting
probe defer.

Capture the clock in the existing 'clk' local and check it with
IS_ERR() before calling clk_get_rate(), matching the handling already
used for the "rtc" clock in this same function.

Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>
Fixes: 0b31d703598d ("rtc: Add driver for Microchip PolarFire SoC")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/6a9d4b02.7d74b517.206c4c.75f8@mx.google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mpfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mpfs.c b/drivers/rtc/rtc-mpfs.c
index aa724a945c088..8335e8c7357e9 100644
--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -256,8 +256,12 @@ static int mpfs_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	clk = devm_clk_get(&pdev->dev, "rtcref");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	/* prescaler hardware adds 1 to reg value */
-	prescaler = clk_get_rate(devm_clk_get(&pdev->dev, "rtcref")) - 1;
+	prescaler = clk_get_rate(clk) - 1;
 	if (prescaler > MAX_PRESCALER_COUNT) {
 		dev_dbg(&pdev->dev, "invalid prescaler %lu\n", prescaler);
 		return -EINVAL;
-- 
2.53.0



