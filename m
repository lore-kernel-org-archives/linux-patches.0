Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733114BEE22;
	Sat, 12 Sep 2026 12:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216480; cv=none; b=HU39kmoqkmmsKUuPYANn3ddJg0VAjs0vr+gM70hUCARG9RgxSzZB/BhSozaJreT6iy0Cy9hNhXsiTesF30OdF0arFqoVow9wlsAQfInXGoZC2XmApzdFOeg7KccaFsXXj2jF4Nr0IYVQAmecXAFh2GsoGtQ39/S4N3zLnP3rqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216480; c=relaxed/simple;
	bh=KuFnTWYGqwoT0ldri/kHIdkN6WmemXlGhTnTmfYEuyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABWX+XpaLZNLcKyxMOQOno94Rh22V+jI/ftVBILxNsIK5FF5660a2YQyLKI3Zpqbb+tVCF/o0PFncHfFRuPmSp1kpYkrFqwZRHroMI19dG/1+Psl3oXrhEfq1sV2KptLChaKHa04vo/SKf6doQ+bOJRcoV7M8y9NcxE6TiqFriA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoKRRiXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoKRRiXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AF51F000FF;
	Sat, 12 Sep 2026 12:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216479;
	bh=RFm7EN5oPa5obrY4Voag9EkjXo2C5I0kDOZvc/fLWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoKRRiXTsg/YV0VFAwBj5uvfX8wz/zxqfWbyqBp4lEcEBWJ3dP4TyvRTLu/hp095i
	 b78Q7nfoPk7NQJIRgsV+bIJnHLSxbwJrCmZYpioZYFynla+8dKRJZORG6TEwBBN64X
	 3cXGNOGadkJf6qvvmXm/2jXZWVZTagS94B36SI0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0701/1376] w1: ds2482: Fix signedness bug in ds2482_w1_triplet()
Date: Sat, 12 Sep 2026 08:52:07 +0200
Message-ID: <20260912065623.169040375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index a2ecbb863c57f..a7fc6ec31938e 100644
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



