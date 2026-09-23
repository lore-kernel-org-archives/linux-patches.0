Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F285372DB;
	Wed, 23 Sep 2026 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173884; cv=none; b=Yckv9+bOUzHhaspw1N6kHOO0neyt6O9WCHk1511Yz3iU+1MSh7XQzGPGc33UQXIcYIGG5BK37ebC/0cNkM8fhNBuRYzsGvzb9xl6+R312I8ug7Oq7i2jEKhkEPeTMwKoKK+YmeOMfkgDMPIc2Oe/mSbaagDul6AJq6JaVeytvEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173884; c=relaxed/simple;
	bh=efiD8YfuakoKqCVBOojT+Ig14LARR16BXaWLEOA1uZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhWS+QMeweU1I44OnHsCxS8s/PQx1QyApaRU56aAec+r733o8WxujHnYb8qPTfXJh0BAhqf2BnLm6LcpYOvMzWbxoGF/0CpnwtsrllynXNxLJ3MzI+v/ffkeNsdkv7zR3/Cb0h5kGrcGPcHVKCO51fq/zu+L5dS6+LZRMTkHDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/Avcq2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/Avcq2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4133D1F0089B;
	Wed, 23 Sep 2026 14:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173882;
	bh=bg/EJW/BMvgV2r9Qg0s1AYoXoO87X6TM9HGaoohCFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/Avcq2gha9VS2LxmdkOtn1mEu4oK85BXRdbjj0uV7qomwShWsEWsF8T6T7Mw3pVA
	 mVbQk2GGcLSNKgjMlT9Q9WgCkj+qx6O3Jx7CsgCmlNedlaE3ZDTscikBpd9TDKKnkr
	 3pU+b+1/wxBaLp6oFqxER0ItVGu5O9OVf/dVXV1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 367/438] hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding
Date: Wed, 23 Sep 2026 16:06:28 +0200
Message-ID: <20260923140654.368837101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -187,7 +187,7 @@ static int tps53676_identify(struct i2c_
 		return -EIO;
 	for (i = 0; i < 2 * TPS53676_MAX_PHASES; i += 2) {
 		if (buf[i + 1] & 0x80) {
-			if (buf[i] & 0x08)
+			if (buf[i] & BIT(4))
 				phases_b++;
 			else
 				phases_a++;


