Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326123DB983;
	Sat, 12 Sep 2026 12:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216068; cv=none; b=ktGCz5o4qrGrjrS640nJ4KTzBhZYApgVXlQqmtx3PQnXQE41oBERcDFiaIZlG0rgmrB1ndWpzCY4/NoKLXHhGKYaIZZ2kGIC+6M+39lirqOHVYkhFqgcoa/RpIRcFlbvgVAt0qojspl5jmMK0elkrv6LV+MXmoLrQmPp8LJtZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216068; c=relaxed/simple;
	bh=TwpD4YCEv1HdMGBRUBbRg3SBbrQRoO+LsM6OkLSIrZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDDCvSBMC7oX0GgdsqcYK7v9FWmF09qDjXHNm90n3098JSve0qNMjYmypRwNQVFjD8w+sDS9OzZuu6Qtx/cZKaGaK/0XdJFQ3ca28+bp7/oD3NnctfKGHnKAjOTKAwBT5KceYtaxbk1Xe8I9jM6Fe0eMIf20AmTEAN/94mTpnUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzaT/tDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzaT/tDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3908D1F000FF;
	Sat, 12 Sep 2026 12:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216067;
	bh=loHRnVOXzJ8fhZ3spOdJYCNJb+PkasoFPTWv9PgN4X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzaT/tDubc13hAh2sDEnIbZ50+HCTVbKGcLAJ1ryB/Z1/fITJ6mpG6I/2y+mqPIG5
	 BTCWpcGbtFe3G5Rcztrc8Mb780FzNp1zsMj7Faarx0HlETtpTUWFEe7FIw2t15rgqx
	 b+bORAI3ul8GCNhO372yDlU+cJv9mI/cxf+A5JxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0662/1376] firmware: arm_scmi: Unrequest devices if driver registration fails
Date: Sat, 12 Sep 2026 08:51:28 +0200
Message-ID: <20260912065622.295572907@linuxfoundation.org>
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
index f39d46b587fd5..771b6da2d83b6 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -314,10 +314,14 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
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



