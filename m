Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0894D1C84D0;
	Fri,  7 Aug 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116216; cv=none; b=Y4MydNvhWLNW8LHH40KY1BDKoE0/iSxf7AJD3eWfHNodXq2qiH1qxGKH7yJs/4tyP3LLWb9L3HiN8iL9Obnod0E3eAxPlcm+x+JAYMUIuKQzkvXKx/YkU/XGHr5y1TePumgyldK98uEfRigbzVXWa6zF2mrVYpwJc5hzudQoX6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116216; c=relaxed/simple;
	bh=CIYjeXB1Qdma/JwqYKl6H9J/vJkDqA2AKYx0egrR3oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awzBqMcLR1J11dyfijwWrQ54IPVqVBMCnOIVL6VG/P2vrmFhKcKRMIT1JuCUUGJy/cDBcHuKbLo7H88W2fePT5s8rDQyW6/Et8wsKlZHWfWFYJ0Jb2AIshyM/yxuUY1w/xKQkmD1op/8XX+D4URSC3B01KWI1gjXPOTQuwU/MUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhNxaBPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhNxaBPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF481F000E9;
	Fri,  7 Aug 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116214;
	bh=IhzfLaP/lnOvVG1Ow+ywPwvs/A3CSL0ys9T9iJ88vp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhNxaBPxlYg9o6maEXTHW2sMc26G2V0xBX9mWdwoJA9snKh4RrbXkc6kg1FI4nngA
	 KYWTsVe9bQvlFMiJusFmtcMB+WH5xAkRdl2Cx2lFT5V/feXifdXE7U+XAPgCAmXQ/T
	 kINTxLeWClZM9Y9REEJZ8K0+W29OrXFa3/1FH74E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 152/261] power: supply: bq25890: fix the -10 C NTC lookup entry
Date: Fri,  7 Aug 2026 16:38:29 +0200
Message-ID: <20260807143418.643818409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 160a783aa65b74782bc17cb874af1a6d3f5fba3c upstream.

The TSPCT lookup table is monotonically decreasing except for ADC code
121, where the sequence reads -9.0 C, -1.0 C, -12.0 C.  This makes the
reported battery temperature jump upward by eight degrees for one code
and then downward by eleven degrees for the next code.

The entry is a missing zero: use -10.0 C so the sequence remains
monotonic between -9.0 C and -12.0 C.

Fixes: 9652c02428f3 ("power: bq25890: add POWER_SUPPLY_PROP_TEMP")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/0619C8BF15F43B7C+20260723065444.1796002-1-raoxu@uniontech.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -320,7 +320,7 @@ static const u32 bq25890_tspct_tbl[] = {
 	145, 140, 130, 120, 115, 110, 100, 90,
 	80, 70, 60, 50, 40, 30, 20, 10,
 	0, -10, -20, -30, -40, -60, -70, -80,
-	-90, -10, -120, -140, -150, -170, -190, -210,
+	-90, -100, -120, -140, -150, -170, -190, -210,
 };
 
 #define BQ25890_TSPCT_TBL_SIZE		ARRAY_SIZE(bq25890_tspct_tbl)


