Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E84B1BDC3;
	Mon, 14 Oct 2024 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917748; cv=none; b=O7QOO4DrFSkF/NMkPM6vi04gLRA14/oBicLP+m+g0s8BdDfV/VVYjA7Ti/c/3YwadItWO5fABA4r/N+t9Q4wUjfcJ0rF1dNguCnamFQcPNatX0MaIsV0F7giQQxf0t5vk14c/Qzm+XxR3Ogm51NHU5mG38VuE/Sgada/hkhMloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917748; c=relaxed/simple;
	bh=p7U0TD5GZCnyN/k2t5qlysEzw0MY4hOFgAfO2DRUwWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8Df6/zpddgzmIDMg+396qk+v0CejQl9zER2OEnWO8IAa71nU9U1o8VtE39S3UkcSo1h54CPzUo0lFtN3f7KxOSZLfOHrHeKd493mbN/KkyDkTBjo4pE4tO1MtkT0XCfjUlWinRKzj//SjgdDcQCbfR8hhbo0c/s+381mTaQihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP4WENdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP4WENdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7E2C4CEC3;
	Mon, 14 Oct 2024 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917748;
	bh=p7U0TD5GZCnyN/k2t5qlysEzw0MY4hOFgAfO2DRUwWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP4WENdFm0Xm/LU2Q2G0ajth0iC0v8ShKjPFA1om0ps5/dswxb0j9jNtUhIxI3O7X
	 s5TaJavalKeqMHelQZ3MP7ljVZgqmr02Z56Mz+Y5QP5O3O/7CFbemqj546LP8VVJAp
	 Riu9GIb1DH23knMExvogxZNz4Fui0XGUNEm18MNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	linux-mtd@lists.infradead.org,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/798] mtd: slram: insert break after errors in parsing the map
Date: Mon, 14 Oct 2024 16:10:45 +0200
Message-ID: <20241014141221.508271197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirsad Todorovac <mtodorovac69@gmail.com>

[ Upstream commit 336c218dd7f0588ed8a7345f367975a00a4f003f ]

GCC 12.3.0 compiler on linux-next next-20240709 tree found the execution
path in which, due to lazy evaluation, devlength isn't initialised with the
parsed string:

   289		while (map) {
   290			devname = devstart = devlength = NULL;
   291
   292			if (!(devname = strsep(&map, ","))) {
   293				E("slram: No devicename specified.\n");
   294				break;
   295			}
   296			T("slram: devname = %s\n", devname);
   297			if ((!map) || (!(devstart = strsep(&map, ",")))) {
   298				E("slram: No devicestart specified.\n");
   299			}
   300			T("slram: devstart = %s\n", devstart);
 → 301			if ((!map) || (!(devlength = strsep(&map, ",")))) {
   302				E("slram: No devicelength / -end specified.\n");
   303			}
 → 304			T("slram: devlength = %s\n", devlength);
   305			if (parse_cmdline(devname, devstart, devlength) != 0) {
   306				return(-EINVAL);
   307			}

Parsing should be finished after map == NULL, so a break is best inserted after
each E("slram: ... \n") error message.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240711234319.637824-1-mtodorovac69@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/slram.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index 28131a127d065..8297b366a0669 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -296,10 +296,12 @@ static int __init init_slram(void)
 		T("slram: devname = %s\n", devname);
 		if ((!map) || (!(devstart = strsep(&map, ",")))) {
 			E("slram: No devicestart specified.\n");
+			break;
 		}
 		T("slram: devstart = %s\n", devstart);
 		if ((!map) || (!(devlength = strsep(&map, ",")))) {
 			E("slram: No devicelength / -end specified.\n");
+			break;
 		}
 		T("slram: devlength = %s\n", devlength);
 		if (parse_cmdline(devname, devstart, devlength) != 0) {
-- 
2.43.0



