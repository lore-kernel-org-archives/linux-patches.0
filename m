Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA57514753;
	Wed, 30 Sep 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786120; cv=none; b=XcdCjGJ+vpDv/qP1Kba0787kZzpWRnfoI/ZttPWeAE5aLkAufaqnfR8RgkTt8zflUBiTlyK+oUSz8TkQ4pBnemKvrQVSjNzaBdj732zZmNfPVJga2Kc90yhyyJ0/kVRPSFxQPmsm5MZYbKFsoQlv9GTIwBLRPM+C2D9LBf7g1C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786120; c=relaxed/simple;
	bh=WNpFUfgiimhKXy+njKnRW2ZuYKlpb61rCgVu4mK/7C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgdChgjDZcQSXQKxE6Ay75Gw2TYC58dhq0QPCvqRkbDQgtovznfpEHJm9BPvedQ8xMboi1LoNVehQrIekHhyRkKkHI6do6wKS1eJL3o0ETbnC4Y/tei+NLWINb75cauVP9Jfd8z42jqA2FPGC8JDWxjtRjMXbfWBsziKRXuEgWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKniu7Xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKniu7Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A601F000FF;
	Wed, 30 Sep 2026 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786118;
	bh=hsr+tXea/iZX6gvi9iHEHyIPpno3EC7CjStL2wHVVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKniu7XncMXoV8wEdQzE2MZpCaAQgxTT8mb7hnQZvHjY8mD+wroPS8DXwtxpsTEu9
	 ytIQ+vj0YxN/JiscIGQ1sxTclY1MgNLHPda3B6pw0NoLlq05j5fgFzlDWn5oo2UQYW
	 mK4GB+qrR4Mr0KqbF5BjXj2lpSEWR+TcxAAd9+EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 750/982] hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding
Date: Wed, 30 Sep 2026 17:24:46 +0200
Message-ID: <20260930152432.864099809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit 1d12fb94ac0975566545871dda100df34df5f845 upstream.

tps53676_identify() reads the USER_DATA_03 phase configuration to count
the phases assigned to each channel and derive the number of PMBus pages.
In each 16-bit phase descriptor the channel (PAGE) is encoded in bit 4 and
the firing order in bits 3:0, but the code tested bit 3 (0x08), which is
part of the firing-order field.

TPS53676 supports up to seven phases, so firing-order bit 3 is never set.
As a result the existing test classifies every enabled phase as channel A.
On a dual-channel configuration the phases assigned to channel B are
therefore miscounted as channel A and page 1 is not exposed.

Test the PAGE field (bit 4) instead.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://patch.msgid.link/20260915164823.160977-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/tps53679.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -168,7 +168,7 @@ static int tps53676_identify(struct i2c_
 		return -EIO;
 	for (i = 0; i < 2 * TPS53676_MAX_PHASES; i += 2) {
 		if (buf[i + 1] & 0x80) {
-			if (buf[i] & 0x08)
+			if (buf[i] & BIT(4))
 				phases_b++;
 			else
 				phases_a++;


