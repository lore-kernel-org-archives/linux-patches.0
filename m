Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED2235358;
	Sat, 12 Sep 2026 07:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199620; cv=none; b=b9bFFEmAvhH0IX0hEupzKILtH38khrejO6j4I5+XFDvI6dg1XNJmqm55Iob02aL1FUv2ZXzJOCkP6YiyjphzM71oIXxlSsCiuP/uIUcbYkQtbZeaUyQZRDlsJn0U8dEYJdF/OSdVhCjcxkHMIs3G07AgDVHxfFZZEODJ2A/Oidw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199620; c=relaxed/simple;
	bh=mBW3IiUi29hzMfB9DmJU4IvjUdxbUrt5nUakT1qq9/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhmHkHl6xMjGucqRYEy0YGHNRNG69YARE6nHuSBx5lQTUBgmNb0utfB4UiTkCNDtrNSJ5eB10vjKuxCVWDDy+OSEf6oe6ITDstd9RjACt4Iemdl31hqL8JO0aNO39OGfmFU10jrmmYm0U3wPLDZUy0cByCysZOGQGywzMW653+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHe7+Jng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHe7+Jng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C371F000FF;
	Sat, 12 Sep 2026 07:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199619;
	bh=qnCFTMTgdJA78+z1gHLJdZMK497GQxiSBZXEtfJxrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHe7+Jng2bJVxbNK5Cwq2FHMujl0W9/AugV4R/12a8YeX+VVZdalbSlrronqqyd9z
	 bzsSi+gB1ztAJnvoLUAByZYVSBBG56bXMOGltyWSVEId0tjkMPNWM70jBGw2whvmwS
	 DrzhFnIGNViXaQQZhgHH0eZi3Ohgu8PSEWv9CAwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0621/1815] firmware: arm_scmi: Unrequest devices if driver registration fails
Date: Sat, 12 Sep 2026 08:39:31 +0200
Message-ID: <20260912065703.458848594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 9f7cd6a62aa754ed6b48cbd5d50de40add1bcc86 ]

scmi_driver_register() requests protocol devices before registering the
driver. If driver_register() fails, those requests remain in the global
IDR and retain pointers to the module's ID table. Once the failed module
load releases that storage, later request matching or SCMI device creation
can dereference the stale pointers.

Unrequest the complete protocol table before returning the registration
failure. At this point table registration succeeded, so every entry is
owned by the current registration attempt.

Fixes: d3cd7c525fd2 ("firmware: arm_scmi: Refactor protocol device creation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260722173521.2184378-2-sudeep.holla@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index d520910eb2515..e060edbe7e832 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -395,10 +395,14 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 	driver->driver.mod_name = mod_name;
 
 	retval = driver_register(&driver->driver);
-	if (!retval)
-		pr_debug("Registered new scmi driver %s\n", driver->name);
+	if (retval) {
+		scmi_protocol_table_unregister(driver->id_table);
+		return retval;
+	}
 
-	return retval;
+	pr_debug("Registered new scmi driver %s\n", driver->name);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(scmi_driver_register);
 
-- 
2.53.0



