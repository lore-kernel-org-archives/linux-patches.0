Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017F1E8825;
	Wed,  6 Nov 2024 12:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897919; cv=none; b=UC1GVN+9KzeSBzqXZtd9opz6zvO3SNSkuOvH/T6mbCOC0OthvHsqxKQrnjHFY9ND87CK42XGGB4RrPmoJsQJA3iJdgTqcLC6Aq9Pm4jQG+wXbarUGWcdFav5k6wA0foDRMrpg8UsAB4NAO0f73LuLCWRSXHqDrghRFPmcjw+YDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897919; c=relaxed/simple;
	bh=2ujlV6ZxWEgsq+pvm9ddS3hkueG0y2+bUAhtEYCGcAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W++tXxpUGf1EONAiOJWC75b07zwiVA8A5KgRWwkVZB47EcpfY4tMDCJxCZoNDDVNllLwUd4WmbwGLpB6ThcCeTW1PyeXvcpDFFO4ayPAHW3pJ17OQV5MlNPmqdoQvOlLvH1sbMw/8ru/M2Z72/jNYND2jwc98ouKTQ1Gpic4KP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+XgNCec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+XgNCec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690A8C4CECD;
	Wed,  6 Nov 2024 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897918;
	bh=2ujlV6ZxWEgsq+pvm9ddS3hkueG0y2+bUAhtEYCGcAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+XgNCectM4aNV3cFE4imKwYcNZX+AtnT5g6IWX5SstkX2u4x3Szda55QdwP8Iac9
	 GP1tU2ZpZ6dCXlpt1WIiXBHWDCn6T9zOabm1awDevTWbmneHy6DLLfiGvBR6vDN2Cx
	 pPArZftoc56yz2URshMLwArpVm5kjMY6LX7qHorA=
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
Subject: [PATCH 5.4 062/462] mtd: slram: insert break after errors in parsing the map
Date: Wed,  6 Nov 2024 12:59:15 +0100
Message-ID: <20241106120333.046274159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



