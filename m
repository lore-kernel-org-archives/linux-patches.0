Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5334C9AB;
	Tue,  6 Jan 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720437; cv=none; b=m5qxc5kbbPXoPK/1mkZcsjHG6XQSpr22v43SjiPKFA0J/KoBG6pWYSQHF6wxLNZ9KaveZQIubV6ukGpE8fuP56+uOqg4bGCDZBibut0PgkjfiWkn/E+OuSQN6gHX2MGrIXTx6M+lGK3NhUP9fWFVF16VEkCABudV43WIL2JF3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720437; c=relaxed/simple;
	bh=EWetHNAYKTNCelMA21YhVJUMg/C2IKg0NjwyiYt+/SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0GyaiQBN0uh0o/6eNTjD5MCkePcg9lAtKaf2wTtDMkGwaRQe0QtPsidhcWz64naESfVhduLCV7PjEUl8Co7VYyLz/bGMvITLf7sk3gzPpc3NSFyEODIZLvY9GdvbR7KRE8pFad6/4FLTgWHI41xCW3tqbTbTW3mPUnKaS/xOLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jk15JP8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jk15JP8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD0FC116C6;
	Tue,  6 Jan 2026 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720436;
	bh=EWetHNAYKTNCelMA21YhVJUMg/C2IKg0NjwyiYt+/SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jk15JP8KURPRfGv66fsjDTJFQEOszp17WRyjQawAqAUO6mwuyuW88SDv4qZIzijRY
	 GG8oj3U8gKKeP4J6K1a/O/YlwrcyJzmn2uLL2pNDNrF2TnSBcovLC60rlwQmLH2Kjd
	 FG0mBcQKUFz2CJRHqi4APBS+JDhsVl0Nf9LkU10s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 236/567] net: phy: marvell-88q2xxx: Fix clamped value in mv88q2xxx_hwmon_write
Date: Tue,  6 Jan 2026 18:00:18 +0100
Message-ID: <20260106170500.050501874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit c4cdf7376271bce5714c06d79ec67759b18910eb upstream.

The local variable 'val' was never clamped to -75000 or 180000 because
the return value of clamp_val() was not used. Fix this by assigning the
clamped value back to 'val', and use clamp() instead of clamp_val().

Cc: stable@vger.kernel.org
Fixes: a557a92e6881 ("net: phy: marvell-88q2xxx: add support for temperature sensor")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251202172743.453055-3-thorsten.blum@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell-88q2xxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/marvell-88q2xxx.c
+++ b/drivers/net/phy/marvell-88q2xxx.c
@@ -647,7 +647,7 @@ static int mv88q2xxx_hwmon_write(struct
 
 	switch (attr) {
 	case hwmon_temp_max:
-		clamp_val(val, -75000, 180000);
+		val = clamp(val, -75000, 180000);
 		val = (val / 1000) + 75;
 		val = FIELD_PREP(MDIO_MMD_PCS_MV_TEMP_SENSOR3_INT_THRESH_MASK,
 				 val);


