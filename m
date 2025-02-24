Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15EE2837B;
	Mon, 24 Feb 2025 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409030; cv=none; b=p+en3FyeCS+Gm9Q6fe00a1gywHoYpfKNSl7TTm1WNff2iMOn4Iqi8B+rQp9E5FZrRJAEUmuprf2Onsi0vmsjd/N/GCZ2Qi1gbl0OWy8J5jrdZJ6XNSOMbE4yan1hKu60bO6MAHyVeVKf2NB2bqEGbQWkj2lEYqnpaM3ECFuuOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409030; c=relaxed/simple;
	bh=s2qYv/oCo21kow6aevjQkv9pB5M5qmJHBEe9uulUsHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKlp1pklLgIVtumkhMq7cI0l/vx4I6KqWkLAPCYdTINSp3pM4NyKbBPaTXTtHLtad6YUuqiL+kyAsal6p4PA2BDozHk7Ywxr9maFk0vqaiey7cKMWDjrzPxBJlJzY/ZoX7mKzAw1e9pxHVQlq169LsvSLn6zFPLYDeIEHYDcCdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijUCWrQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijUCWrQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33864C4CED6;
	Mon, 24 Feb 2025 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409030;
	bh=s2qYv/oCo21kow6aevjQkv9pB5M5qmJHBEe9uulUsHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijUCWrQZYId1mRC3fMHKmibSNWEFqHd7e3rmaNrXQVGl0Ebg4TVDFIKKsFzPx/2TB
	 DzxpblyDkv8D6TpxdOP9KBbALVX6jWzNk+a+qwghXojfT3wCutNvJ81LWHmgr3WK9X
	 wS3YTGe1nYbYuxKztV9b9NX7+hi/DOsWBcLJT3QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/138] power: supply: da9150-fg: fix potential overflow
Date: Mon, 24 Feb 2025 15:34:49 +0100
Message-ID: <20250224142606.801030323@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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



