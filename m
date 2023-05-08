Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F22168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC44C433EF;
	Mon,  8 May 2023 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544252;
	bh=C3TNWy7E2eTHc/6V+meOjr38etecp82m9YMJVtbCKiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLGrYOPnVf9OELrWaZIF8bUQaG8/3igvNxcfi9ZJNjab8O4t1GKCGad40X2pNAUIg
	 R3TEug0DOxxbmJigNFQYuvVqOE98caI1KwGFP+alPweWqmlUuBJgoEa8JlYny1GffH
	 7klxV6v3JyQmWEHgcxcux8wvdqMYhfv3Qc/VcIIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	=?UTF-8?q?Tom=C3=A1=C5=A1=20Pecka?= <tomas.pecka@cesnet.cz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 319/694] hwmon: (pmbus/fsp-3y) Fix functionality bitmask in FSP-3Y YM-2151E
Date: Mon,  8 May 2023 11:42:34 +0200
Message-Id: <20230508094442.661805487@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomáš Pecka <tomas.pecka@cesnet.cz>

[ Upstream commit 93822f5161a2dc57a60b95b35b3cb8589f53413e ]

The bit flags in pmbus_driver_info functionality for YM-2151E chip were
joined with a comma operator instead of a bitwise OR. This means that
the last constant PMBUS_HAVE_IIN was not OR-ed with the other
PM_BUS_HAVE_* constants for this page but it initialized the next element
of the func array (which was not accessed from anywhere because of the
number of pages).

However, there is no need for setting PMBUS_HAVE_IIN in the 5Vsb page
because this command does not seem to be paged. Obviously, the device
only has one IIN sensor, so it doesn't make sense to query it again from
the second page.

Fixes: 1734b4135a62 ("hwmon: Add driver for fsp-3y PSUs and PDUs")
Signed-off-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Signed-off-by: Tomáš Pecka <tomas.pecka@cesnet.cz>
Link: https://lore.kernel.org/r/20230420171939.212040-1-tomas.pecka@cesnet.cz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/fsp-3y.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/fsp-3y.c b/drivers/hwmon/pmbus/fsp-3y.c
index aec294cc72d1f..c7469d2cdedcf 100644
--- a/drivers/hwmon/pmbus/fsp-3y.c
+++ b/drivers/hwmon/pmbus/fsp-3y.c
@@ -180,7 +180,6 @@ static struct pmbus_driver_info fsp3y_info[] = {
 			PMBUS_HAVE_FAN12,
 		.func[YM2151_PAGE_5VSB_LOG] =
 			PMBUS_HAVE_VOUT | PMBUS_HAVE_IOUT,
-			PMBUS_HAVE_IIN,
 		.read_word_data = fsp3y_read_word_data,
 		.read_byte_data = fsp3y_read_byte_data,
 	},
-- 
2.39.2



