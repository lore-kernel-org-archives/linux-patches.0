Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6F747DD77;
	Fri,  7 Aug 2026 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117009; cv=none; b=rfhlUX/E0Hl8Cqw0w2vGXdRg/TtGmVSUtwogi0YlC9Xj1Ee8a6Vx4fTPMb7Uzpv3S6DIyWk7fc88j+mK8YIs3ksvHUX8qpwU4KiK80YjpNpHktbk+h2bCvUOnlJysQvnlRd9JzMesWGbW3WDDU0DSeFoiwZHJ2YFEU238ENLI9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117009; c=relaxed/simple;
	bh=gPIE/zupC/llvsNJKoVpKMWs/45yzmeAVFJYYFhUvm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/gegzDqA+iAkiW+no9HLpKPqNu23/zMa4HZXVvcpRpaguO+z8zxEus17Etz8Q3fRlTBd+sj+PpZZrT40mGyqMq6BWBRb1ry8/c8Auc/aQOaVJKFXujHFXbVqtmepa5rUbykUeKC2pVD4v9CcJQTt/cU457I8f4V6Kzj6Y/ORQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY1W5fLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY1W5fLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08111F000E9;
	Fri,  7 Aug 2026 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117008;
	bh=MuyNqpCXC6wTYtlBkxYybKoYfEG08QI77XNfm8PkOKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY1W5fLRVAAEQ7BHATB2Gzzh73Acqrb5HnO4H/5DvraVTyNro63c7ezlAbxGOE5zN
	 b+hEPBQxv0frC2mOjqmLNX5ckpncDdM/P1mrQbIcvamdIY5kjgvS5SDiJlJh/LSYc8
	 liYDx4APQtvKAE5rhFzCJAeLoKORnXQalSPPiitg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 123/438] hwmon: (pmbus) Fix return value from pmbus_update_byte_data()
Date: Fri,  7 Aug 2026 16:35:19 +0200
Message-ID: <20260807143430.617687928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3143b9e0316c4..7f2d28e41d816 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -513,7 +513,7 @@ int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
 	if (tmp != rv)
 		rv = _pmbus_write_byte_data(client, page, reg, tmp);
 
-	return rv;
+	return rv < 0 ? rv : 0;
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_update_byte_data, "PMBUS");
 
-- 
2.53.0



