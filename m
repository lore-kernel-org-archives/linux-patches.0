Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2695B361DA6;
	Wed, 30 Sep 2026 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788795; cv=none; b=V1j6a2jieKN7CKWYnJgd3Xbu+Ga3cT0eZElhGetRyXln4QwryRUpxZHPZ+U2qma8r3b0h3bHXYPniLW/8anetXvDqqJwz5oOFSaGXnpiGvaLBML6j7z+Q+CqJs6HUVftRzi6+KERIxDMxhntA3y5TWzg82hQILsFllcMtjoW8B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788795; c=relaxed/simple;
	bh=fMq1lJeV8Scn7PqExo7Vxw9p1CmRvl3l64LUuChLmDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prPltgUcx84mu0fy+kCr/bQ4WdH/4yVQHVdkLZo/LWewRc+iiABLY7VUu1mumkhguXXVzwZ8/atrztcndfuUqtiGQfhLMxmYSf7Vi8G3XaB28v5JIYoRkKqRlRQ1+tL1XJS+4NsX2rhOGFuqO2iHL9iJmDX8u32QnH5ZD7m+xUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N19OZfsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N19OZfsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B3A1F000FF;
	Wed, 30 Sep 2026 17:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788793;
	bh=JQdbGuYnmgGZzmgLtjq14udZniI6Wqw1j2QW1mNZCvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N19OZfsPXH6ILF0zbK5i6uF7uxkI5qVRglXFMCymyBfAzyFlFyCitL2bd/KeyLwsW
	 R0GWksvtcnNQKocybM3n0xuoz2bQ0ZCI9bj/wnjklXkHrklKE229fv3x9lOx3zXZeq
	 BTM6KTRK58f3g3sDQNANI6lhwAASHWAlYFkhuJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 248/877] hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding
Date: Wed, 30 Sep 2026 17:19:19 +0200
Message-ID: <20260930152420.074891647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


