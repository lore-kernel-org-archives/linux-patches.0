Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995AD1DB13A;
	Sat, 12 Sep 2026 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223943; cv=none; b=iSb4rVYXtxQLf5Fd50aAyAFd77LARHGFVpYiHy/i+p08Ud4+/QYfpzyf46Y13kjdeupBkqrSatOtMlau5mXsnLa1MKQGTBcI5bWzfXxOMfcmvv87Y4ceBDKzlq8yL0Tz9OcUv/aitNcHNw7AkqPwBcvtqLR2v/YQG7dXVsX8DYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223943; c=relaxed/simple;
	bh=6Uw2HZ0U4MABaOSlbEM7BIk12Xnx3LTDKXAtP6Hlxu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6FYKOZBYN5TOgT9p5lUBde9Yv3VAFrrwj3JSBt1lOJtb5q1U2U6OhpLJUwDBu6VgBQjPZANb8lqqgMjg6FFOTF2xgk6Vk15o0NgNVtGssT18H773wfIKYZBgFMT3Td1GYsC6r64p/ci1rxLB7CuKiCnLw9WMprRZpONhBdQiNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCpYWcQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCpYWcQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D631F000FF;
	Sat, 12 Sep 2026 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223942;
	bh=1f2IqlUAOvpW4zy2CyotmqptP54NhkEYRY0rONJc8AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCpYWcQkNw7TRuwXQO5x5xG88gtDQjGk320FhAfhy9PUuOqiboZJWTFUq5e1jxahq
	 FphnXhVI3wJZ/QBkLtyLQHXFWDNxdzgx/hwnyxJaWu3JmC/xE4J0S/62ANkh1gixWS
	 iwDHF4dSmCsRHACH6aqiujf8oD6VN1nqPDcTERH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0891/1424] w1: ds2482: Fix signedness bug in ds2482_w1_triplet()
Date: Sat, 12 Sep 2026 08:55:23 +0200
Message-ID: <20260912065627.281683410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit 4d3721b204f961e905714954ff95633337b768e3 ]

ds2482_wait_1wire_idle() returns the status register value (0..255) on
success, or a negative value on I2C failure: -1 when selecting the
status register fails, or a negative errno from i2c_smbus_read_byte().

ds2482_w1_triplet() feeds that result into "return (status >> 5);"
without checking for errors, and the function returns u8. For a
negative status the arithmetic shift keeps the sign and the u8
truncation fabricates a triplet result whose meaning depends on the
errno value: -1 and -EIO happen to become 0xff, whose set low bits make
w1_search() abort, but -ETIMEDOUT (-110 >> 5 = -4) becomes 0xfc -
"devices responded on both branches, wrote 1" - and -EOPNOTSUPP
(-95 >> 5 = -3) becomes 0xfd - "only the zero branch responded".
w1_search() then continues the ROM search with a fabricated direction
bit instead of aborting, and the corrupted id is either rejected by the
ROM CRC (existing device missed) or registers a phantom slave.

The function already defines an in-band error value: status is
initialized to (3 << 5), which decodes to 3 (both branch bits set, "no
device responded") and makes w1_search() terminate the search when
sending the triplet command fails. Decode a negative status to the same
value.

Found by smatch:
drivers/w1/masters/ds2482.c:314 ds2482_w1_triplet() warn: signedness bug returning '(-67108864)'

Fixes: baf12ae29ab4 ("[PATCH] W1: Add the DS2482 I2C-to-w1 bridge driver.")
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Link: https://patch.msgid.link/20260714041011.7-1-bbnpreetsingh@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index b2d76c1784bd8..da801859c7ec0 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -309,6 +309,10 @@ static u8 ds2482_w1_triplet(void *data, u8 dbit)
 
 	mutex_unlock(&pdev->access_lock);
 
+	/* On bus error, decode to 3 (no device responded) to abort the search */
+	if (status < 0)
+		status = 3 << 5;
+
 	/* Decode the status */
 	return (status >> 5);
 }
-- 
2.53.0



