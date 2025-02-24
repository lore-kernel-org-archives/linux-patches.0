Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B41257451;
	Mon, 24 Feb 2025 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408522; cv=none; b=aDkhwn2fl4szWKAfVdxU0/YE1YImrqyN6EOw7hCbMc4WvxGNJp7Y4Os9V4XBAxY/6I7O0UNummxqtT3Gs1iF1GjZw3RXqpabn5y9D6JAgkQqWdp36amYyXLSh43LL51ejNsBL6foIYpTJ0ELXOxcXL27Px/8RmVCAY3QKq9YwNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408522; c=relaxed/simple;
	bh=oiJDQmN+kSbLCd79WJ8k72RxAVTcEJzEHGuDMDAEEhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spuM9qP/qjDSgllPFJNDm4zoOLQDJgsrChR6qqz4MNqaS1WVXFAp9WVIsdpWNOs93zT4BwS8kICYiT41rJjyx53gwlUkB0qTrM+fDdWzNbMs5tfcbgGy+9uUD82PmPSHbXTMydrbPU4WS1oCtRpGim+n8FRAHFoOJzaj1Zf/H6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKAszPFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKAszPFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4CBC4CED6;
	Mon, 24 Feb 2025 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408522;
	bh=oiJDQmN+kSbLCd79WJ8k72RxAVTcEJzEHGuDMDAEEhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKAszPFw0m1YgDPAe3/uvH1XG9MYeFcm9MvOJOP2mIoF2K7hx5xMyc7RbjPiHUTws
	 uwDfmyYqmvyaSdJAE6s2VC/SLDRSyeQFDLbib2V68icYQJJ68Jxilyuhr3CMuussJt
	 brL6Y+Ab8e14tapl3T1XM1623NwRfL5FvNCdUpAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/154] power: supply: da9150-fg: fix potential overflow
Date: Mon, 24 Feb 2025 15:34:41 +0100
Message-ID: <20250224142610.288860462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 3fb3cb4350befc4f901c54e0cb4a2a47b1302e08 ]

Size of variable sd_gain equals four bytes - DA9150_QIF_SD_GAIN_SIZE.
Size of variable shunt_val equals two bytes - DA9150_QIF_SHUNT_VAL_SIZE.

The expression sd_gain * shunt_val is currently being evaluated using
32-bit arithmetic. So during the multiplication an overflow may occur.

As the value of type 'u64' is used as storage for the eventual result, put
ULL variable at the first position of each expression in order to give the
compiler complete information about the proper arithmetic to use. According
to C99 the guaranteed width for a variable of type 'unsigned long long' >=
64 bits.

Remove the explicit cast to u64 as it is meaningless.

Just for the sake of consistency, perform the similar trick with another
expression concerning 'iavg'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a419b4fd9138 ("power: Add support for DA9150 Fuel-Gauge")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://lore.kernel.org/r/20250130090030.53422-1-a.vatoropin@crpt.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/da9150-fg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/da9150-fg.c b/drivers/power/supply/da9150-fg.c
index 652c1f213af1c..4f28ef1bba1a3 100644
--- a/drivers/power/supply/da9150-fg.c
+++ b/drivers/power/supply/da9150-fg.c
@@ -247,9 +247,9 @@ static int da9150_fg_current_avg(struct da9150_fg *fg,
 				      DA9150_QIF_SD_GAIN_SIZE);
 	da9150_fg_read_sync_end(fg);
 
-	div = (u64) (sd_gain * shunt_val * 65536ULL);
+	div = 65536ULL * sd_gain * shunt_val;
 	do_div(div, 1000000);
-	res = (u64) (iavg * 1000000ULL);
+	res = 1000000ULL * iavg;
 	do_div(res, div);
 
 	val->intval = (int) res;
-- 
2.39.5



