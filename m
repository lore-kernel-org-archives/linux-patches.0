Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39943318BB3;
	Sat, 12 Sep 2026 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220817; cv=none; b=FWtDLgwUnaTJuV4FOI7gqHkl7livhzupg1v3vd8m0p7Md7V+oyyAMvBmOoFkXDG2O+l3dAiHFQJxk6sjmdYVJfKhaSaiUOVjQhn1wubymgae+647P9fBmrsSf10Bur7AXStBu6ikYoRdMO6pyt6Q5slpkwF2Mf3J9lv0jSAz54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220817; c=relaxed/simple;
	bh=SRQWKmwZvKMNGwK7QM01pxrKgCn1qb7JsFRQJX0R+zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbBcUsOaj0IuuvP4OOLYRGv8rCbPAo+yBxWKXdxGikSeWbNDsV0z8Peh1FlcFML3oOuuK0bn4UjLEurRN1nG3Zq8zust4lXb8VwmrT06m1onHKWbbICCfuiumJqJutB4x7xQ3nJ3C/Gq1440FI5aD1f4F8vX8IagCyEJ2WJayM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtSP9Jv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtSP9Jv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81911F000FF;
	Sat, 12 Sep 2026 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220815;
	bh=m6g76XmB+81aznDO7fX1ElAbZ9JshA9dSruVYt2aA1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtSP9Jv9UBdm+8CST/pyki9w+IinOqMcGc6kPCotP4ETxd68YkV0dGL1CHdN2DZM8
	 bDp2UFRcuIPaNrJTcbcVr/Ge2eojA7jUdSqGZR1eAHU8HbcJzpeVZUHaXRd3EqkwiE
	 yqLlExwN3MeZZQhQGZGXNb6JXNqNtF07iRy2zJAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0212/1424] power: supply: qcom_battmgr: terminate the strings from firmware
Date: Sat, 12 Sep 2026 08:44:04 +0200
Message-ID: <20260912065612.035989561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit ab1112df8f4ffa88cb024dd370c432ced80f77d8 upstream.

The qcom_battmgr_sc8280xp_strcpy() takes a Pascal-style string when the
firmware sends one. Otherwise it copies all BATTMGR_STRING_LEN bytes and
leaves the destination without a terminator.

Those destinations are model_number, serial_number and oem_info, each
BATTMGR_STRING_LEN and declared next to each other. They go out to user
space as val->strval, which power_supply_format_property() prints with
"%s", so a firmware string that fills the whole field makes that read run
into the following members.

Use strscpy() so the copy always terminates, the way the SM8350 path
already does for the same field.

Fixes: 29e8142b5623 ("power: supply: Introduce Qualcomm PMIC GLINK power supply")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260727074119.2585463-1-sammiee5311@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/qcom_battmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -972,7 +972,7 @@ static void qcom_battmgr_sc8280xp_strcpy
 		memcpy(dest, src + 1, len);
 		dest[len] = '\0';
 	} else {
-		memcpy(dest, src, BATTMGR_STRING_LEN);
+		strscpy(dest, src, BATTMGR_STRING_LEN);
 	}
 }
 


