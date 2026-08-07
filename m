Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0790B42AF95;
	Fri,  7 Aug 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114941; cv=none; b=AkkN5AB6sZ58yBD7a+oQtknSJBMyNLsu5zbW3OyJSwvYLz/srQxM7AH/zKnvC5ca3G7gtGTTekp0dXMKNX/0XjAnFt8dQgJmZXypmQUNa478bjSHlm6c9kQ059BvZ7Vnla11QH+O30Bo5N0tKzVBtCj85Loa0BcNGCTCECU+N2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114941; c=relaxed/simple;
	bh=DYzu1tlRoSVfuCeyWF6y7Wfu/ViGrbOk0uYKMSYcmnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACVF/uuAE6Ut583htqNDTKy3Zc6ZFhcqaLnFwVbw7BYP0iXPj5NAd1wOHMxUWH+kPWK6jUjX7VyXXEJU0T1YZKflosmOuhomB5o08b2Ej+Ei+ksJxNSzNJ/8x2gCOCzX0jjsslYYQXYYWKnzbouVaxaSdTvjhMgruLF/j6SZ+4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC+5GHkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC+5GHkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE1D1F000E9;
	Fri,  7 Aug 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114939;
	bh=jh7QsSgNf3PWkprc97ChAh7IcsveBR578AE5ZJNJhvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC+5GHkpH3O8Y0ysIoxWZBe8mczGk4rfkbPOyMF/Tlki3IwaFEp0VS8BGsuecgaqU
	 9cqKL07vZCL5529R8RleX2t44CVctE0cSLu0NTsqIdFxxxCx3lFP3JPNiIjjh96SSc
	 vB4RE8UuzHY9k809dwX8isHI9NMo4gOWU0EawLRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/396] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Fri,  7 Aug 2026 16:34:22 +0200
Message-ID: <20260807143426.492184128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit a19038a200f18d9e74ac30081797917d0886e16b ]

pmbus_update_byte_data() is supposed to return a negative error code or 0.
However, if no change is made to the register, it actually returns the
register value. This can result in problems if the calling code explicitly
expects to see an error code or 0.

Fix it to return 0 on success or the error code as expected.

Fixes: 11c119986f270 ("hwmon: (pmbus) add helpers for byte write and read modify write")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ddf64e72751cc..4e1c66670ead9 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -512,7 +512,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, "PMBUS");
 
-- 
2.53.0



