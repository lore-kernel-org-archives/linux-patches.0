Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F89314A95;
	Fri,  7 Aug 2026 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115421; cv=none; b=H8H/up+laP/HbPAyaFtiXvtB4TKcgvL6+JTKNexkNcS98sCxcmXLGQMqJiElb7G5pA8FLhrioATWP+yIsIq/fzBpYrilizJKMDPjwJ/yXC9t0D87FnXlbgeGQoGLXjWc864bmvPU7LKUJtXAFAoyORVBNNmSYVNX0ITza+qqnj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115421; c=relaxed/simple;
	bh=CIuyVUeKkC5m6DdJv705o4yROPQ49TLhapVMjET5MjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkJqsSh/b4LwtaD3cS3Q6u8OMw6w+XJC+uHYOPTre/KKqS3zy8krBgsIBtgcjr974Lhau6CvXvw6k7UJHCua7/ZT32KgUg2vdFIokvu+0WBpnrJRZ9gqKOtOLzvVWzxwQnFwLSmuA+kFv3/C6HEkaS9AKFwV7pGRpr8QC5omWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJ728tRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJ728tRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D180A1F000E9;
	Fri,  7 Aug 2026 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115419;
	bh=Wh9SSxUUH+Jby0EHDQpaoWdPY7EuM81C3P8/FNuhlhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJ728tRnIl7sMqS8T59U2uUpANyqTYuqfRfRRzyBN8OyjZ4r7JJSYE3fmQVg9D4sH
	 fsoC1UKyXT3eCJykIWOXcPvtJxUlD4wttisAc6S8c8tnxIiBeMRmhZJKEHxo6Rsv+s
	 TzIrUxn/hdSfTR23DnYKxAd0jshvXb37GYJAsRaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianing Li <m13940358460@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 269/396] power: supply: max17040: handle missing status supplier
Date: Fri,  7 Aug 2026 16:37:09 +0200
Message-ID: <20260807143430.058280201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


