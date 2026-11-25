Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625799;
	b=pWYu9F6MwjCpZE+FRIf8LZzK4pK8paS4NwG678VY9U0cAeE5oDfRBviTgGm9UbOFZ8w+
	 WmPHzQvK/PuuUwph00kFMyXAITSB5aTacCdgUKnttgqet+s/hQMMtM74DXodVVd2MHbn3
	 sxYIlhH+tumlBOGOfqETyAdSMpN5RUleYHSBS00b+m6vSVii/YhTQdpulY7aIRJi/PNog
	 B3Yx+2sompQCsCILpdtgiir340WuMHsOCpwt/aupCknepYoHk82chW1+WcbG4b+W0C47R
	 NgkkQlIyx8peX/9o1FJWtmLmFctYRNCx2yJopS21VX632NAlgvZ/EKkfZDAZM05HoQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcqRi2CcEPPlPyqkMBu9PzzxT6/j+mSgT3g/bJx4ZxQ=;
	b=LO7Xto/C0Jc9+LH0qnLZhSWqcxZnBqJn9Q8jH+aLtSa9yv8rWFmvRGRuUtDXYmIPr8yY
	 +8ac9xGHfABnrkr0SOYtqAMwFaootCXjaGxq6uSzcHn06T+8IEaGhtKOhsfF80oWLxICW
	 LwF/KgLp8k6Waj9aqMWmNTh5Vuh7QaxBlJxHD/8vJ7NYHbyM8i0l3CyS82Q/Sa41w+3cj
	 EHSTSxzxg0ZDUhEl+wk4GVAVPI/F4ERsutU8Gc4L66cSB51AUSx8CfMJP+4GiklVCGP6f
	 IHkh8XK7l1LhwPr2ZCArr5DCliu66FA2gN8p5cRCf/PMNmQZkw8IY+eMKT6Dkgkxsdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s42A8Ww1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BDE606A329;
	Wed, 25 Nov 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s42A8Ww1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398341F000C6;
	Wed, 25 Nov 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625798;
	bh=IcqRi2CcEPPlPyqkMBu9PzzxT6/j+mSgT3g/bJx4ZxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s42A8Ww1cYmCa0mvRiHw4p4WDha8Gu1KmZCF4cIT4F5OH1ml02DFQRXClNxVeb+J1
	 2TUopip89guE8PgqBxEINJbPAveSB+7rZEw1gkNo2yx34wHPlIaxMfnHI/DtBmylx2
	 tJwughvkxDi8H1I3l2IV6E9lqA5W7n+K+S2rR3hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 635/816] hwmon: (aht10) Fix update_interval overflow on 64-bit
Date: Wed, 25 Nov 2026 15:36:23 +0100
Message-ID: <20261125143903.881594263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit b5c5b67e02406fb48acf57cf2c30a570230fd6aa upstream.

On 64-bit, update_interval writes are clamped to LONG_MAX ms, but
ms_to_ktime() overflows above 9223372036854 ms and the interval wraps.
LONG_MAX becomes -1 ms, so every read starts a new measurement and
update_interval reads back -1.

Clamp to INT_MAX like sht4x, so the limit is the same on all platforms.

Fixes: 8c78f0dee437 ("hwmon: Add AHT10 Temperature and Humidity Sensor Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Link: https://patch.msgid.link/20261108172651.220121-1-zoone.rupert@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aht10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -229,7 +229,7 @@ static int aht10_read_values(struct aht1
 static ssize_t aht10_interval_write(struct aht10_data *data,
 				    long val)
 {
-	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, LONG_MAX));
+	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, INT_MAX));
 	return 0;
 }
 


