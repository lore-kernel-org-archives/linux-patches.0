Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7675318B9D;
	Thu, 28 May 2026 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001327; cv=none; b=iTC4cKJwdvZgy4QSYOk9I1nKfGTF1xGQ8CrDxMUEmjw03617pgEXuShfHgZUpfhRxnFsgk9qhUDc/Hp4uXbNhZluxvupuVLlxArOam35iFM/1TAL1v5DbQ3OzDGbPcndSUA1YGDNswPRkPDzm/k4TccbLJ+A5PEzFpx/F0V30Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001327; c=relaxed/simple;
	bh=mtdIiWRabvQzYjhb0cdlnxpY5OWlkUnCrov1jl15qLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJrnHdzQbhrJ7stTVQ0oKBipsbPGt/mgmoDfsVKuWnL9BdJg/8zyujEtAdHEHVhCGp9c1rdD/R5jBIplhbheMk8Wzn1qpvJ3Yqfcp5ADRUFzcT8atdP3wmCmKdJxR6IFUUDVqzUz2F/vqKhjNzaB+2J/cCV8mfIL4qSuU1As7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FqlAWtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FqlAWtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A831F000E9;
	Thu, 28 May 2026 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001326;
	bh=Z7nwkpehKAf+SzjY5jb9bcpFvVwapIy9wPxuLEe3NdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FqlAWtTGrVgrFy7fGT7km/PcYj6YWcPqS9DUfY2mnadj2PgPPjQVTb8vkD8RnXhZ
	 xX73OFoXPLOn6UPh8avzolKC6k9hSZF5/jMKex0bmxBkWxhxEvjTGpHf6dl8RygELI
	 8TdmDrxlgTSh7L9ZuD2EgWmKzxrEEgAaOesf+cNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 088/186] hwmon: (pmbus/adm1266) seed timestamp from the real-time clock
Date: Thu, 28 May 2026 21:49:28 +0200
Message-ID: <20260528194931.312633994@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit b86095e3d7dcf2bf80c747349a35912a87a85098 upstream.

adm1266_set_rtc() seeds the chip's SET_RTC register from
ktime_get_seconds(), which returns CLOCK_MONOTONIC -- i.e. seconds
since the host last booted, not seconds since the Unix epoch.

The chip stamps that value into every blackbox record it captures.
Userspace reading those timestamps back expects wall-clock seconds:
that's what the SET_RTC frame layout documents (datasheet Rev. D,
Table 84) and what every other consumer of "seconds since epoch"
assumes.  Seeding from CLOCK_MONOTONIC gives blackbox records a
timestamp that is only meaningful within a single boot of the host
and silently resets to small values on every reboot.

Switch to ktime_get_real_seconds() so the seed matches what the
register is documented to hold.

Fixes: 15609d189302 ("hwmon: (pmbus/adm1266) read blackbox")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-1-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -432,7 +432,7 @@ static int adm1266_set_rtc(struct adm126
 	char write_buf[6];
 	int i;
 
-	kt = ktime_get_seconds();
+	kt = ktime_get_real_seconds();
 
 	memset(write_buf, 0, sizeof(write_buf));
 


