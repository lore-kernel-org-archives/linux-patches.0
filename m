Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931A9146588;
	Tue, 15 Oct 2024 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992562; cv=none; b=A1INRFBjJHFvbYPuhmbUSIcfOAnbGlrkbigKm5sbczCaDohpqJJHNMyOZt9zisx7RC2RsbfmkG/FcxSnbgfSsvkIgAn/oNoJDAGT3+0GLRJGMwrAYs0yi7a/kPjBo2let63J+psz9BTU7IlaI9O+p8pzPi6688oey/qsaDaWAE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992562; c=relaxed/simple;
	bh=FElow6OyCn59uo2OLrAbnvT7VdYHBLyQPWXnigtZGy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LwQYOlcEUC221l6LR02NNyr7m8AHW2ioQ/Z2n9W03cSY5dy6cF2BNB6T0P2DFRO6ljjvD4IUEtYTzoSiZEHgumdXESlNmkO+nW4DwPekVsvGX34aMoag1o2FMBxX3EfFBl0E58bKlcgdW6QZjBjIcv/HK8xDUSBtOK4BhAXfMeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1fnXmCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1fnXmCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4F5C4CEC6;
	Tue, 15 Oct 2024 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992562;
	bh=FElow6OyCn59uo2OLrAbnvT7VdYHBLyQPWXnigtZGy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1fnXmCIaPW/unNzP0PPmIpNh8trQbCoIfTXihVr7tcPvLNDyW3dT70l0qFS7Wm35
	 c5+b20ohVUfetbydvK606P+w+L3lmcqFuRuixLhay/K8xSkIxURjxb/dFkhEaZWBrB
	 v4S/KGhCloT6GbrgvkqE0pnPyxVU6esj7FZWzfsU=
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
Subject: [PATCH 5.15 153/691] mtd: slram: insert break after errors in parsing the map
Date: Tue, 15 Oct 2024 13:21:41 +0200
Message-ID: <20241015112446.428458124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



