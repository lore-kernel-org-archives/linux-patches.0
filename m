Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44F4472790;
	Fri,  7 Aug 2026 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117485; cv=none; b=ZOGH64VdeMmBXQFy1xjYW2g2XRIiw7zmoMV9QCSrFuTHxSflAhYqdmF724tl8gVPfXlk32DtO5CVR4uhlKUSQQrWudN1gEwvVoqvM0d11SYaxZuDYWLA8elZ97KXBu89B3+VM+QT9dFzp5j+8uuTkUUonqfNqpzcBbJ2SLD+/l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117485; c=relaxed/simple;
	bh=po1J7daejPkpE2+tXbNXFJ3tsvXMEdzLiseYQyG/ne0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABJn9mSpX8eHUQIPtG9Py9VqAZ+8UtgMGbMnk5jeFUZKBd3oKUm5EjAWbDGmZMvVUobTY4pOsOHvFCIEWDTSCaRKPH8RfCRdynR5Zxy7yIaxt59kEZrP/F91L0S+8BG2Htw6eZh+/jZ5tM+N3K99Q6Xc2JIC9n74V39tiLKMYl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGskqObt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGskqObt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451671F000E9;
	Fri,  7 Aug 2026 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117483;
	bh=oq+f4fAQVbAdwgLIzK8BQBNjTPBYP+cFnN3wHIcNoHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGskqObt4NSv4yUeo2upqAViI87s0BrxcBsjyKuooEg5wuVEgUHHV5FCV9afgIPZM
	 0WlfT2YZi5oDZiFNJ/ZXavEJnZQje2+z8DwaLBT3/xFi1a+F9Jesep+l4OW5XdPYdc
	 DAZ+b2ucOZrTYdzzOqaWNKKhqr08uijQJ4NPaP9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 334/438] power: supply: bq25890: fix the -10 C NTC lookup entry
Date: Fri,  7 Aug 2026 16:38:50 +0200
Message-ID: <20260807143435.093571229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


