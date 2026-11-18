Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055751;
	b=osES+uqi+ZcLVithvxm+K9u69RgEvr5FoIZi262IWc7s5ULSW0DUTx6gAuImjseGJbC0
	 1JmOD1rpy3hIKIh4fWyErbfvdsxvwHOeqLFyThBQ/rTyKNbJ/XfoaoYpZrhda4H6gr0HL
	 2PsSizvK5zGqkF1BLFUpKspTqXw9Xb+SbhVSS1+3cQ8kV+vab9NfJM/ReJkm+IF8co5oy
	 QfGvXDDG6YQehAQwpolmZSpBYut8ywREjTNp5k/lmxTLnvqD1ciBBPRgnw74rmr6/7/HD
	 hRS+foBTLndfKUeT4fVBwXvPxeXaijhdwLCiOUAzOJHXsjn7CGvdKyNAj61d9SethZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UqILexQz7gVxuRBeNu1ayaDDPQs9k9q+gaLbulDbSqc=;
	b=d+urHdJywLuMy1soCk2PIds4/Ln19EZBDHVIRGDFT3PZpkmS5V/q+ZmNPjDXZb1bSv9u
	 KA7jiwFhufvUDYw45B8WyJVB1JJvFCZWkiG59ET+stLvqEjia1xuZTAqZWDGvZPglh++E
	 YwYCgx6pfjN4NJS6TwjDq7vu3CbdS8fzWyzMMMjootwljn2MLvSKO2i3Qnea4ckCRRKB0
	 JKECFARUmTZ6TyNetqgV7xUphDmfuKNbMKH72WCGHO55SJv5wpKtwt7gzEYw2UXRWPZNT
	 zpTmV3w9sGBZbhT5xDxD7e/+Y4aPiEj+kHaLk2HAaJdgKwIdP6BlRt5c42g5XohQ3gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ile56rxI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD30606A31C;
	Thu, 19 Nov 2026 02:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ile56rxI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911DC1F000C4;
	Thu, 19 Nov 2026 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055751;
	bh=UqILexQz7gVxuRBeNu1ayaDDPQs9k9q+gaLbulDbSqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ile56rxImUak5P1yEWRVoT5xmi24PIq+8BmvMCME6p5LTDM2+jBSk2bArtr06HaVL
	 ftjVn6Bmw5MzhFmyn190LTli1BIzXO82XeJ02vncixYJt0fi8XlcgBczhz1bc/6t3r
	 DklpTXlIXBNzZ+//vbEJ5AdUSbewyaOaNf4fEjx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1726/2214] power: supply: ab8500_btemp: Fix event temperature reporting
Date: Wed, 18 Nov 2026 15:56:42 +0100
Message-ID: <20261118150120.754080907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 95990cda8e42dda4bd3f1475d578323981bd8579 ]

The event-aware path initializes its local temperature to zero and
compares that zero against the thermal thresholds. Consequently some
events report the measured temperature after it crosses the event
threshold, while others always report the threshold.

Start with the measured temperature, clamp it according to the active
event, and convert to tenths of a degree only once. This path is used
by AB8505 and later variants.

Fixes: 1f855824757e ("ab8500-btemp: AB8500 battery temperature driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-5-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 896309d3cadfe..9380c38adfc34 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -750,39 +750,29 @@ static void ab8500_btemp_periodic(struct ab8500_btemp *di,
  */
 static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 {
-	int temp = 0;
+	int temp = di->bat_temp;
 
 	/*
 	 * The BTEMP events are not reliabe on AB8500 cut3.3
 	 * and prior versions
 	 */
-	if (is_ab8500_3p3_or_earlier(di->parent)) {
-		temp = di->bat_temp * 10;
-	} else {
+	if (!is_ab8500_3p3_or_earlier(di->parent)) {
 		if (di->events.btemp_low) {
 			if (temp > di->btemp_ranges.btemp_low_limit)
-				temp = di->btemp_ranges.btemp_low_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_low_limit;
 		} else if (di->events.btemp_high) {
 			if (temp < di->btemp_ranges.btemp_high_limit)
-				temp = di->btemp_ranges.btemp_high_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_high_limit;
 		} else if (di->events.btemp_lowmed) {
 			if (temp > di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
 		} else if (di->events.btemp_medhigh) {
 			if (temp < di->btemp_ranges.btemp_med_limit)
-				temp = di->btemp_ranges.btemp_med_limit * 10;
-			else
-				temp = di->bat_temp * 10;
-		} else
-			temp = di->bat_temp * 10;
+				temp = di->btemp_ranges.btemp_med_limit;
+		}
 	}
-	return temp;
+
+	return temp * 10;
 }
 
 /**
-- 
2.53.0



