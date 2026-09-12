Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB03E3939B3;
	Sat, 12 Sep 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239145; cv=none; b=pFm4XFdm5jWirmq+yboDzgUg1N4PH1tc4rFJI0gVJpL21FDeNcX10GqevkLb589TfuhY41yWneo1T2kWmwq6E9IcnJetRF3lLib8E1fMve6d6rGSuA/3wagELTCvWMrsH25GrDkIjwKtEytd+f9fwyDXx0dYFEsBQyRlPRK5ASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239145; c=relaxed/simple;
	bh=hSIsbA4EUAQBlqjUlFMD83xLf7Djjs42r7NXTTIqyhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qct52toxX2iAr+WnZg/eIB4PB2X9i3t9NShkxFzkJyHjL1xiWtSdoNxnj7ZGngWwEP+C8L53xexINRCKEjEVVa2QU9NagmJ+eXlCKXrUC3q+t/sX2DSaDzKbzjPl3qJvfNzV2DMPOr0xUk9xuMxg+L+Ci816GExx8RlTPOOymNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqX3wHsy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqX3wHsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80551F000FF;
	Sat, 12 Sep 2026 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239143;
	bh=Ux/dl344mZBf7GZODsxzyo4pl8NkcHN7c50obfb/y6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqX3wHsy2vYaMqXVFg2CfcNbbHGpEbUrBjvGSmoRJdZpuxNcv4BH/RoFW/bsLSy+t
	 2cNeYx0SpBGe4/yKXCOBBEU0D0vMa4gHYp4E1oHwoWkbziC/2G4Y22uJwU2XFbxaCC
	 zvniviRllOke3gEt+uoJWoLRZD/enO5ku0ZjPdIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 605/935] w1: ds2482: Fix signedness bug in ds2482_w1_triplet()
Date: Sat, 12 Sep 2026 09:00:35 +0200
Message-ID: <20260912065540.718606500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c962e88501c0..50451ba345efb 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -312,6 +312,10 @@ static u8 ds2482_w1_triplet(void *data, u8 dbit)
 
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



