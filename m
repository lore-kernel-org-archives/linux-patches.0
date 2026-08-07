Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DF126B2D3;
	Fri,  7 Aug 2026 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115417; cv=none; b=AQjQ2qx5FQh0YpLkNNQJz1hTuM7ikr5vw9pvNser+yj5wxCdCfwYorBpiFWsOg2OPuCgLWdXdlOr2EZ3WHigbC7+iXAm3HSoyvuda9TxHdjzzB7j8pt5n1Hb1ScAUHZqNArcgQySdv/3wcaEZRsmIFG0Zk06hXLYzh1Sxs0O3N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115417; c=relaxed/simple;
	bh=TFfnbuwJd8vHTOSD5Nr4lQdE/s1BrrgBIgEuGsbwanA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mqprcgg7m+rZnbrElqbjm6HWv9sKvjR0sRmKeK4/O20igKEuxtDSPG1/N/gj3ssTxAw41QVNKqgkvQROc6QlUa1OlhZRVvpIAh02BWXczoUZLgSn/ArknEhm/rQ7sr+9OBzORex1KOO45pvL71q4F0IiY+3eFTKq4NM8xr3DU9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBgkkNa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBgkkNa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F286D1F000E9;
	Fri,  7 Aug 2026 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115416;
	bh=arw+E2BpF61dHIJIblhbeOGCAzl2Yup3D5kVFamGW/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBgkkNa/gThXLP5n+UakSk5RMfkeufSnb04SKKv7oosCdk8dIJm25amQgMeA5gcWG
	 LYqnZr7728wH+k5WjfILXu70JdpBnSRw1//Jw1S0ruLxzetAr0qCOuY9yp0PgKbZ+7
	 ZjMbfxUTLdclJB688Zu2UcxbTunKgOkYLbLG8QXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 268/396] power: supply: bq25890: fix the -10 C NTC lookup entry
Date: Fri,  7 Aug 2026 16:37:08 +0200
Message-ID: <20260807143430.037551989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


