Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE6B17B4FF;
	Wed,  5 Feb 2025 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768103; cv=none; b=sJAmrmjCUggCn18vr+5wi/zoMrjNTEPq7JFpFvrjG9BRr70P3BrISsO4m3yyfwWonZGT17O4xw4uSUjOBEbG0dKQ8QmvNRt9jN2vBpmy2fnroXAPdlnkteVmmhTNZhiLHGu7ZUBOM5lstVsCxKIkh4SfywAP8lhCkX6OX8bNrmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768103; c=relaxed/simple;
	bh=LXrLHrERX85vU2EA/4nGBy4brntInv6qxjVjpfSNnaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNBNx5oa5HbqeQTyKRcZnu+OpmdFJ7+8kVfzl03PjQAEAfRbc+HoK9z1jEcrEPL8KhXYeSgokIbT7/Odnza0PEEwUJfDuXZUnldsXCUG0+xgCoJSXzJ4OVcsTn7bnU1Uws36R4SEH7mnQJiSFGmZOermZ6iaMKUCb+nibnGggf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW0Ay/S5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW0Ay/S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93C9C4CED1;
	Wed,  5 Feb 2025 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768103;
	bh=LXrLHrERX85vU2EA/4nGBy4brntInv6qxjVjpfSNnaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW0Ay/S5sJubzwUgV7kMgu2wkHzUNgo/67n8Mois/li5XjbxQflGDv9JXINUHkn1t
	 LyGVg2cG87G0y/s4Vush/mcMnEtbdDZD73X0sLCCEigO5EYMJVxvqM9gVsYDhfNbDv
	 dTtuBtzJjYgjfZWi4+7Sf21W7vea8wgFnBzzURQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 498/623] rtc: tps6594: Fix integer overflow on 32bit systems
Date: Wed,  5 Feb 2025 14:44:00 +0100
Message-ID: <20250205134515.270292305@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 09c4a610153286cef54d4f0c85398f4e32fc227e ]

The problem is this multiply in tps6594_rtc_set_offset()

	tmp = offset * TICKS_PER_HOUR;

The "tmp" variable is an s64 but "offset" is a long in the
(-277774)-277774 range.  On 32bit systems a long can hold numbers up to
approximately two billion.  The number of TICKS_PER_HOUR is really large,
(32768 * 3600) or roughly a hundred million.  When you start multiplying
by a hundred million it doesn't take long to overflow the two billion
mark.

Probably the safest way to fix this is to change the type of
TICKS_PER_HOUR to long long because it's such a large number.

Fixes: 9f67c1e63976 ("rtc: tps6594: Add driver for TPS6594 RTC")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/1074175e-5ecb-4e3d-b721-347d794caa90@stanley.mountain
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-tps6594.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-tps6594.c b/drivers/rtc/rtc-tps6594.c
index e696676341378..7c6246e3f0292 100644
--- a/drivers/rtc/rtc-tps6594.c
+++ b/drivers/rtc/rtc-tps6594.c
@@ -37,7 +37,7 @@
 #define MAX_OFFSET (277774)
 
 // Number of ticks per hour
-#define TICKS_PER_HOUR (32768 * 3600)
+#define TICKS_PER_HOUR (32768 * 3600LL)
 
 // Multiplier for ppb conversions
 #define PPB_MULT NANO
-- 
2.39.5



