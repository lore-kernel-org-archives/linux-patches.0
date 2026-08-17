Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5623B811F;
	Mon, 17 Aug 2026 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976021; cv=none; b=CoYkrz3JC61cMAaFQwtgHW0Ys38oSnF6X8BATinS0nQmf1hau/qLKlZDQCJQe6XU70RxEtr4c8fylK4+6K8VdD0J70vSrWNwkW0aP9Oz5eOj7WXrFL69IxhTTUzTx1iILT4GI0ERFbznMtZJuavW6N39ex0vn7IDN3IgwVwdd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976021; c=relaxed/simple;
	bh=a6KuGadbUzGtGXd543FfsAE/k35igWImPicN5aDOuxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx5SZwGUJO/z4fVZcKQMfq64CLT+q03c6JKjGCgIjLc3isEBDsi/cNnN/fz70xjUU2RdeE0ojgz6O1VMLq0uudW+BoaOXGluq8uvY+zCCoqnpXipaqkw2rYIjzbwdO5x43E0gIbedCz5tr7fJ59OLf0SFRhRBpYOIlGDjepaZvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4kbE2YX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4kbE2YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7576F1F000E9;
	Mon, 17 Aug 2026 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976020;
	bh=kqVoZ5hB2f2VuwEuVj1PVdq1XIywKVVC9UYy0C6Eb0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4kbE2YXCrMPNN/ofKALsEfaoWiIJG4yBHVd5GMHRI6lJfcqXVsbSkrWRIAKVjBzA
	 6MOtkTSrDKViLUNYqQwuQURJJ0OyTGpxiAZ3jYu+SCYPoKQ+jeYhI3Nu4BnbAneKtU
	 2E5dwestq+2qmwTIG/M67juqS5rvTaSq5n3p/YAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/389] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Mon, 17 Aug 2026 15:31:07 +0200
Message-ID: <20260817132548.128679379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e90ab980b836f..ddd8399a7feea 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -408,7 +408,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_GPL(pmbus_update_byte_data);
 
-- 
2.53.0



