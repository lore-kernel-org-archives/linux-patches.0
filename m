Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062249;
	b=isikjQViwdDkSc6mc+KRNBk+nCk1vsIqpkzk3va6NBl43LVQdYKm7WziIFMD6l1cRkoe
	 zQ+mDXgYp5Cm0e5Wtdnd3I0UQxzg1t0jEFckPEmYhYJacA6BfvJg/RDQeyeqPHmCiteb/
	 B58PbGkjkSXg37//pHT3cRKjlCOeUFDAxmd1lz5aFX0dIIhoK48Yp42Al4xo5jZ/d1d5z
	 dH7RYmJoj3Fhe5nMrHHjLXVeuAR38wkgFIGP9W0YEYb4gkIgH0lhdveniVuKTXcY3CVwi
	 jvBL2NRwC4R9TKmD9oXwv674Q/jcLZcGAFgCQRz+pkb3PDGV/uY3wNZlzjk1X73zA/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5cCog2zTk5fJ/OrEGN6pz1O/g6pGd/vooA0se9nOqfk=;
	b=UQGx0QT59W/h31ECRippnsnCC9guAPcBEWtuobPh4WjmmsbA3DHD2WIyaBjSH9W59y1f
	 i8X8OnMi36V1qeSSyTQwfPj20ThYUDgc6GBDSEbRIsozvLvreg/xhQsbnBxHHAdPMhX60
	 qNwEU/TEULGZLGxfIvLZ8/BvkLSwHscDXuajeQwidekrqYUDlgNAhSBssN2AQHsr+vAJX
	 y/xxpxT29VGupqwgBCgO/ifucmDaelA0K27XsSXOuiqgzaRpOWKM7uNEZSOfaJGQUV6uL
	 MVtbcKZOXm5NJGy9pbwpuaYau34/NmeJ98N0Svbqx/bsAG0jENMw5sl/h6UaET90f0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY819mW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E9E606A320;
	Thu, 19 Nov 2026 04:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY819mW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4B91F000C4;
	Thu, 19 Nov 2026 04:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062249;
	bh=5cCog2zTk5fJ/OrEGN6pz1O/g6pGd/vooA0se9nOqfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NY819mW8M9+sp6E/jgD9lIATTy+r/WihUFR1s6q/inLOM4rfycEf0l1nXCf/SRzeP
	 tRtL52aqU0OKvMmO2X8dBlzuRxksspMOw53aHBb/ANeB2ngT9vO7nOhHg7jCgjXGH1
	 RyH9dbAAIU/y3IBrS3rqvZX/5isIIMnVVYzlD1DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 1843/1848] power: supply: ab8500: Fix error handling in ab8500_charger_init()
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150036.712791376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit c4d33381b134da188ccd1084aef21e2b8c3c422e upstream.

The ab8500_charger_init() returns the platform_driver_register() directly
without checking its return value, if platform_driver_register() failed,
all ab8500_charger_component_drivers are not unregistered.

Fix by unregister ab8500_charger_component_drivers when
platform_driver_register() failed.

Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ab8500_charger.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3740,7 +3740,14 @@ static int __init ab8500_charger_init(vo
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&ab8500_charger_driver);
+	ret = platform_driver_register(&ab8500_charger_driver);
+	if (ret) {
+		platform_unregister_drivers(ab8500_charger_component_drivers,
+				ARRAY_SIZE(ab8500_charger_component_drivers));
+		return ret;
+	}
+
+	return 0;
 }
 
 static void __exit ab8500_charger_exit(void)


