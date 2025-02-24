Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B542571CE;
	Mon, 24 Feb 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408215; cv=none; b=hW7yPO6WmSllPgzOIWUGRgqhDJRA80DQziU1tFuuXwWl0xoKkqfT9LYsiLzGLQPJPLnJQqeibL5RUbCdDHIHQc7ReqrCVNmjLYwdEzR+hao0neI9PidIlwrOwdES3Myr1qsNMKDVa9ABrNysVyPDofMiCMDUY6xhWWeuWkpCp+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408215; c=relaxed/simple;
	bh=5Lny5PIklB7wrsjKAyNJO+GnJN92ymzI4NhhuQWgHmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCZLyEcfpGwI2wKynS6G061F5bHaeRkSAp9IF3tnaYw41zHLwXl51Qm93Yw+W6jE3rwpJ1jEzuNqBpXchN9/V5mOTpYlMzW0fX4MR8zAn8qdsVdP+tVI4vOWDjnveK9BQUF/PQUu/08AfaqeWwL4shzo7UKM4SVZ0/e3bIbVGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtBQM2rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtBQM2rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12647C4CED6;
	Mon, 24 Feb 2025 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408215;
	bh=5Lny5PIklB7wrsjKAyNJO+GnJN92ymzI4NhhuQWgHmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtBQM2rLFtDK9dsLxlOqfRjXBmRORSuYPWX8gT+3z6iFNs5tpqtU7/RqEGiIR4Lcu
	 /YUDFw0FAewTOCUC7rTdivfzBDdiQZlrgwHQjcd3vXSiKN1i/MXdU9pGv534FRXKSP
	 IekVcj0buonbbhvhC9w7JA0mhEYzfwwFCS0bg3g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/140] power: supply: da9150-fg: fix potential overflow
Date: Mon, 24 Feb 2025 15:35:00 +0100
Message-ID: <20250224142606.985288371@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



