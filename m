Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0421E43CEED;
	Mon, 17 Aug 2026 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977294; cv=none; b=GZIdZhGMpq3aDm4GsakcotNnSlZG5xO+BIu02MmIdiUva/n/J92LnrtmbALxzdltYznne5VpY4nOjckOqvuR3LYDWFQQg9nlNLQADPS4apaIpnWn5xHaY/bMflLN4rTF3REGc5sMTN+TIcIon8gx1Y7JCYujhCwhQSKiYvk3up8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977294; c=relaxed/simple;
	bh=zjCA6zl8Wdkss+pHysfVUhN3Sj04WH0RUIrp1T+iy6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI4vrnG4zRHVthZ6bU43PR16V+EaAWjZ9n7ZM7hX45yQpsjXqsNWP2pDGtBqfMYbvh8AN2MbP0TM+mVsWmVre37Kh8FhON67rS40e+CrASM+eLLqQFfvp+B0YT+A34g+Btu/x7AVBDCmqZS0Pb/6RQzOuxqj11VIj9cl+rjD7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/ubitbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/ubitbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5691F000E9;
	Mon, 17 Aug 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977292;
	bh=7GK9cF8PteEFAuwAPjmcfNKTHIN7yzgOUXQs7Odt0HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/ubitbiLnBft1LyHUUs7uFRnywP8fktcoNebtwboZKuLRfhMp3WTWFPeRRWb5ycn
	 CYXp/8EYmgS1oCRZRPOHtDjWe8r8xwYqZvwfJkqWumWh+7QzEjy44VhgPNLPavqMMy
	 UoTE4T4rmbk9GQhoufGK7KhL7vZe9omrSFITaKjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/456] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Mon, 17 Aug 2026 15:31:10 +0200
Message-ID: <20260817132550.896957573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 1ef214a8a01b7..84497fd177d81 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -419,7 +419,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, PMBUS);
 
-- 
2.53.0



