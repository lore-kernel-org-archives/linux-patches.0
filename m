Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CC72C11DE;
	Mon, 17 Aug 2026 15:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979122; cv=none; b=Xei9MBZMrOzoiwCAZ68lEr5zH/8G/KUl8G4l4ZQ9IdYjNHTMuBDsnNChJSWgXPx6tke+HdUcEfnG8JmPFuj25kPgCs04jjeXxYW48G+4Dg1K1cErKf9oYTiHhumkM5V+yJdO+jbXWhx5dZSvag4zcFdCpYRJKkmmakNshl81KNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979122; c=relaxed/simple;
	bh=0D4pFgEfkW2pRN2rD5T36PXqYir5NyIhp2I0mE9NZK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SM8IX7oEhSEvyEPJxOGppafuKlDwRnFBEd0sJgFuPwBmjZd/uVkGhADyWrp+hZZm5g0XrbAkEsrUaPL8AjHsYhaUSplXNX0o4wU56G2UrO6MfigbyI4yEzh4cgH9dgtO13aRrEvrFwC9uwJs+X2q8ZA1kvjKsvrzYADorIqU/J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBVG+c9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBVG+c9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FFF1F000E9;
	Mon, 17 Aug 2026 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979121;
	bh=HEodnAe+QGupMHrfFXdCaGRNg9JUlTEdSGLbKaHIJx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBVG+c9jP6kANDewPTuW7ifFj7jwo0bd2VIyLykhqwxV9uoqfjycVFj7NH/7pM47e
	 T4H6VYRqrOrbjVRZ/c3Mwq5Kt/1Kdkt8EgatkB8PulA9XPS6n5vYc0jaFvpKbWP1WA
	 WI/y2pnipqaJqUHSToOEYxjZiVJ1t9vGhrpMZIuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/609] hwmon: (asus-ec-sensors) fix looping over banks while reading from EC
Date: Mon, 17 Aug 2026 15:26:53 +0200
Message-ID: <20260817132547.690466094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Shalygin <eugene.shalygin@gmail.com>

[ Upstream commit e741d13cc2abfc6fccebe2008057aa52e285223e ]

Do not assume there are only bank 0 and bank 1 available, just use '!='
for bank comparison.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20260711074217.554656-1-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index c9222c83ba2409..c81c6e3264bb05 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -705,7 +705,7 @@ static int asus_ec_block_read(const struct device *dev,
 		}
 		for (ireg = 0; ireg < ec->nr_registers; ireg++) {
 			reg_bank = register_bank(ec->registers[ireg]);
-			if (reg_bank < bank) {
+			if (reg_bank != bank) {
 				continue;
 			}
 			ec_read(register_index(ec->registers[ireg]),
-- 
2.53.0



