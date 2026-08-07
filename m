Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B413F327A;
	Fri,  7 Aug 2026 14:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114284; cv=none; b=iEhJAUgzD3hWb+yjUNBOF0PKtLSobEbOHNM53wxDYM0j/eH6yyUEusT1eUtNBXy2lwvojJKWb3Ra5PRxWQMDKa7em0FLqWmL/+aAae7s5ckrFzJmDGYx7ACxJ8qzUlWZsepduElfy2qd/H+Si4v6zz9CGR5LLe8Aw60urW9N3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114284; c=relaxed/simple;
	bh=e1B+qHrUXRH/l0mT4GCy6RIPk93wQxOYdZ5XrH74xkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unJE032GtC/Nmd6Tu4fuiEGTDS7rX4eNMh0B8y+sg0f4zpn9ni9SwVSOxoWrUIU6BMrYP2i+Efpmk2gI0Ki+FDO7p23E7hGLzM4xYREPT4Cx4DgRYyFZ2GbnKFbK1aIXkE7e4eoEc7a2sStAxwu28irb6RsLaxX+ftd+dvfcCXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBJk/3y7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBJk/3y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215DE1F00A3D;
	Fri,  7 Aug 2026 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114280;
	bh=jAxUMjkvBRGhRwws4r9QfdkBGlLOLW7IyGz7aWNrECM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBJk/3y7LqbVhnrXeDelC4OUbZ32onh65ptY1g5xNo0lIvsi0sOfd3rqbrTtOxtb2
	 dgn69NCNsYAWe3bSo9fCEHzXDVhSOo8Xcfr2uNk3pAMAHbbtb1UWMr/zxqjOcPW1rF
	 Ao6dzWqngbvtygRVVPBok+reEnwq6CLAlSy8lT4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 207/337] power: supply: max17040: handle missing status supplier
Date: Fri,  7 Aug 2026 16:36:50 +0200
Message-ID: <20260807143423.043617716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Jianing Li <m13940358460@163.com>

commit 725668c6b6aa3971fe850659102c250d0d676e18 upstream.

MAX17040 does not report charger state itself, so the driver forwards
POWER_SUPPLY_PROP_STATUS to a supplier power supply. If no supplier is
registered, power_supply_get_property_from_supplier() returns -ENODEV and
leaves the output value untouched.

max17040_get_property() currently ignores that error and returns success,
so userspace can read an uninitialized status value from the battery power
supply. This happens on systems that use the fuel gauge without a charger
supplier relationship in firmware.

Return POWER_SUPPLY_STATUS_UNKNOWN when no supplier provides STATUS, and
propagate other supplier lookup errors.

Fixes: f4b782af61ae ("power: max17040: pass status property from supplier")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Jianing Li <m13940358460@163.com>
Link: https://patch.msgid.link/20260701061042.1008-1-m13940358460@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17040_battery.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/max17040_battery.c
+++ b/drivers/power/supply/max17040_battery.c
@@ -405,7 +405,11 @@ static int max17040_get_property(struct
 		val->intval = chip->low_soc_alert;
 		break;
 	case POWER_SUPPLY_PROP_STATUS:
-		power_supply_get_property_from_supplier(psy, psp, val);
+		ret = power_supply_get_property_from_supplier(psy, psp, val);
+		if (ret == -ENODEV)
+			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		else if (ret)
+			return ret;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		if (!chip->channel_temp)


