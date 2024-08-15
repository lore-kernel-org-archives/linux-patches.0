Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40DE1A01D2;
	Thu, 15 Aug 2024 13:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730218; cv=none; b=BEh/aB88/Eh3qFE+IkAeH2mx3El/CZ3DJL8OsrhZtzfbc/AXRCHmPzmfDhBMiOsDQwAlOvJuk6MeecP3aDpzdtavNV+jAhAWQuP7RblyM57gOt7iSspRpNQAbpKDPHzlsESt6rdp+6+6ydxUc4+3uQEsrbndUXYo1dQJiWwTnSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730218; c=relaxed/simple;
	bh=v2++EbYLAxZrEgombunXWG/Ea4r7g/m+WGiQ3Q/bbN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaVGfZhNlgwaZXLmD46P7LGd05tbrgDH9igd92M+7Vr1kswdWy9MXxQ3++3KzwgCZFuvb5U8lvdy5+oM7A3puqYg3YosEr3HBQyse2Xi1U3lam4l5/NeEIG8gYZlQ135SbooaSc675lDXAETm1GaL2OkdQDkKO8pchgXocBVly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYbj9jkx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYbj9jkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B745C4AF0F;
	Thu, 15 Aug 2024 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730218;
	bh=v2++EbYLAxZrEgombunXWG/Ea4r7g/m+WGiQ3Q/bbN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYbj9jkxdipOlw8mo8bS0mSpKoOZsFpifbTKrSGCfLjuap0T8AAzP+zLyKu9Nqkch
	 jNh1gpvPMe8bI2SSkJuMMVco5Zsut4iF5QZu6KXlz7Z6tbO4VglX9X3cIpdqQluW3r
	 3UzIqL3vCL9BrNc5VuBVuFNfQpOX/+Uf2Efd2SgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/484] power: supply: bq24190_charger: replace deprecated strncpy with strscpy
Date: Thu, 15 Aug 2024 15:23:19 +0200
Message-ID: <20240815131954.589989595@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit b0009b8bed98bd5d59449af48781703df261c247 ]

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect bdi->model_name to be NUL-terminated based on its usage with
sysfs_emit and format strings:

val->strval is assigned to bdi->model_name in
bq24190_charger_get_property():
1186 | val->strval = bdi->model_name;

... then in power_supply_sysfs.c we use value.strval with a format string:
311  | ret = sysfs_emit(buf, "%s\n", value.strval);

we assigned value.strval via:
285  | ret = power_supply_get_property(psy, psp, &value);
... which invokes psy->desc->get_property():
1210 | return psy->desc->get_property(psy, psp, val);

with bq24190_charger_get_property():
1320 | static const struct power_supply_desc bq24190_charger_desc = {
...
1325 | 	.get_property		= bq24190_charger_get_property,

Moreover, no NUL-padding is required as bdi is zero-allocated in
bq24190_charger.c:
1798 | bdi = devm_kzalloc(dev, sizeof(*bdi), GFP_KERNEL);

Considering the above, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20231020-strncpy-drivers-power-supply-bq24190_charger-c-v1-1-e896223cb795@google.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 90ac5e59a5d6f..8a4729ee1ab19 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -1727,7 +1727,7 @@ static int bq24190_probe(struct i2c_client *client,
 
 	bdi->client = client;
 	bdi->dev = dev;
-	strncpy(bdi->model_name, id->name, I2C_NAME_SIZE);
+	strscpy(bdi->model_name, id->name, sizeof(bdi->model_name));
 	mutex_init(&bdi->f_reg_lock);
 	bdi->f_reg = 0;
 	bdi->ss_reg = BQ24190_REG_SS_VBUS_STAT_MASK; /* impossible state */
-- 
2.43.0



