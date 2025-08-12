Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25539305E13;
	Tue, 12 Aug 2025 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024847; cv=none; b=NTEGCDZ6noWeTG1ddk8GSJY0IjQtWbotYF7yDQnX2UDTBWQzKcgnlqzRZcSZOXScL0Esv02IWm5ze3RobdVo843LIMf6tuH3PjtSm0tpwoGO/9ddEyzfH5UU8l3ktJksU7U2IGa9Ql8N5ORi8zVwmUk9piAYn/vAJ+iIGZVgtnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024847; c=relaxed/simple;
	bh=uJ/FoUlQHP5O0gmaRT5wpumkH7YkGtvuiIMQxEqzbyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb2DmBxM4K26pgx6nSwjqH4rGTdeqxKXRWi7kUdBDCo0QwRGBAZXTJPXPfDkhPR8pjTVtp1w/ESdFvxaw5+ucWrT4qVDR/C8sasBiFiuYSPuT4zj741oS2R7qfdOO6HRvalEcLJkdjQ6uIBLG/sVJzLA/s4YHHrpSrZmmMZt0CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ou9UrRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ou9UrRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C8FC4CEF0;
	Tue, 12 Aug 2025 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024847;
	bh=uJ/FoUlQHP5O0gmaRT5wpumkH7YkGtvuiIMQxEqzbyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ou9UrRDhkb6J2pTFKejNKYueC9d8zdSFRdJmZeOcAZt8wlrwsGrAn3Yu8dUJAdQU
	 fttCXXnhfUku8tql5doLOAN6RaHMVKJcd/GmucQOpxmoFHxSesUw1qSVatbmrKYZya
	 CIWVFC0sJo17doYSMv1ZHPiK+wvrS98SkU78ImQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 461/627] i3c: fix module_i3c_i2c_driver() with I3C=n
Date: Tue, 12 Aug 2025 19:32:36 +0200
Message-ID: <20250812173439.204636952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5523a466e905b6287b94654ddb364536f2f948cf ]

When CONFIG_I3C is disabled and the i3c_i2c_driver_register() happens
to not be inlined, any driver calling it still references the i3c_driver
instance, which then causes a link failure:

x86_64-linux-ld: drivers/hwmon/lm75.o: in function `lm75_i3c_reg_read':
lm75.c:(.text+0xc61): undefined reference to `i3cdev_to_dev'
x86_64-linux-ld: lm75.c:(.text+0xd25): undefined reference to `i3c_device_do_priv_xfers'
x86_64-linux-ld: lm75.c:(.text+0xdd8): undefined reference to `i3c_device_do_priv_xfers'

This issue was part of the original i3c code, but only now caused problems
when i3c support got added to lm75.

Change the 'inline' annotations in the header to '__always_inline' to
ensure that the dead-code-elimination pass in the compiler can optimize
it out as intended.

Fixes: 6071d10413ff ("hwmon: (lm75) add I3C support for P3T1755")
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250725090609.2456262-1-arnd@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i3c/device.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/i3c/device.h b/include/linux/i3c/device.h
index b674f64d0822..7f136de4b73e 100644
--- a/include/linux/i3c/device.h
+++ b/include/linux/i3c/device.h
@@ -245,7 +245,7 @@ void i3c_driver_unregister(struct i3c_driver *drv);
  *
  * Return: 0 if both registrations succeeds, a negative error code otherwise.
  */
-static inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
+static __always_inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
 					  struct i2c_driver *i2cdrv)
 {
 	int ret;
@@ -270,7 +270,7 @@ static inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
  * Note that when CONFIG_I3C is not enabled, this function only unregisters the
  * @i2cdrv.
  */
-static inline void i3c_i2c_driver_unregister(struct i3c_driver *i3cdrv,
+static __always_inline void i3c_i2c_driver_unregister(struct i3c_driver *i3cdrv,
 					     struct i2c_driver *i2cdrv)
 {
 	if (IS_ENABLED(CONFIG_I3C))
-- 
2.39.5



