Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488CD1DF249;
	Wed,  6 Nov 2024 12:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894930; cv=none; b=PeU1hrjFY78SbHT8YiwtXrH+wZgsXhyUjgnCqR5yqXKSNE7y+7kkhLKZOSP20TSmO/oHquHGu8lnmQR/4l+65Pd91dGusPxHZ3ef1KeEWsBhYYBmdzWbPqF06JQ/C9JLdY0V+kpqvmHFT11pR2WD5+N8SJlogt0B8inFyfXhN0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894930; c=relaxed/simple;
	bh=nAdIhSuR4xtFb5QAFc/zDGaq7IQHAYD7jdw2HT60cTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X77/Q2EifE/c4rCryUcHyDRvBRIYsD+uD/xBNN2QFh9sepgUooSb1NjHRyyYHJof9sg5oiH71m8PdxrmqFIXXNK3Lz2znsFGkxwzhPN/0p1qTE5NqmxtDqbUJSNL+uqcwotL9bxRvxXKyeyIcND7vQLWHXb0oRZn59S/iaSHs3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0PrAoA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0PrAoA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A1FC4CECD;
	Wed,  6 Nov 2024 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894930;
	bh=nAdIhSuR4xtFb5QAFc/zDGaq7IQHAYD7jdw2HT60cTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0PrAoA8HWoaH3vPCda/ow+O2h6Zy2VpD/DciR1U+g0aqf3dt6qNu/MPoVaaRbBTv
	 rT0rk9Q2MxBeTrFYMvQePBvQ5M4+29QE0ZAusZnn6w4bi8Lu6YBfAfE9nTqJbDRakt
	 fyKSuzrKF80mmtkLyoTWelHug0q5xVoHb/b3+8+Q=
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
Subject: [PATCH 4.19 046/350] mtd: slram: insert break after errors in parsing the map
Date: Wed,  6 Nov 2024 12:59:34 +0100
Message-ID: <20241106120322.025170796@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 10183ee4e12b2..aa4f73aef3626 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -295,10 +295,12 @@ static int __init init_slram(void)
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



