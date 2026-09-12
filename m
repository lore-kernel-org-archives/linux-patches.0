Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BBB33993;
	Sat, 12 Sep 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232892; cv=none; b=KhdmJQWBT/wgo0IVzAuXHamXWpNh0YhN68jiMfQNFu22FnOGsB4yTNXxqkAYM2EK3sgVnxE0CJuLwm4JXLD029ta4875RtkT9A6DQgxo1d6RL+ywFCNObBQMYcdyHawMybw1mAfa0UcJ3OLuPxYi3oVq2A/AQP6ZXSdzRJ9IgI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232892; c=relaxed/simple;
	bh=xjTlG7OzsnRKnaOZFbVZENiinPtWRpZI3HllsHHA22k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxdH7fxGzQgwtmslyV1RT8AjT4yYT86nSq9DTtT+Y+YDqOZZkF6N48Ak98rCljrgiU5cIMnFJ8J89ZpKP840OE4juIdjVwmKllO22zhX+TiTjLxkNKOWFJVcebTbqacNNkSxXSUjaoWdN5+EOs4Zt4gwBNEmFs6kl1mj0KgrJ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXHXML1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXHXML1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACBC1F000FF;
	Sat, 12 Sep 2026 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232890;
	bh=2LRXknGNxknwI3x4oHbIGev3dLL9KD4fFKj5bshQolw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXHXML1cMgnX6uy/WLepI5SBk4MQNA3wgFRCPweU+AayNGvJ1hAp3q34b13ZonCZX
	 zsdnyrxXdJozT71WvvYt6LzJpDqjvZYrcNvmVMmKShDcM9MWDQyy7Ar+5G56A+DYsD
	 pY+581HZwTaQPjrSc4iAdwoOJAUJsPm8++gV+3So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Adhikari <adhikari.resume@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 5.15 103/935] md: do overflow check for sb->bblog_shift in super_1_load()
Date: Sat, 12 Sep 2026 08:52:13 +0200
Message-ID: <20260912065529.183431611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@fygo.io>

commit 35d522bd32462afcf1981dab6da8a9256c26c1e0 upstream.

In super_1_load(), sb->bblog_shift is an __u8 type value loaded from on-
disk superblock. It is used for badblocks API badblocks_set() by the
following sequence,

 1930   rdev->badblocks.shift = sb->bblog_shift;
 1931   for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
 1932           u64 bb = le64_to_cpu(*bbp);
 1933           int count = bb & (0x3ff);
 1934           u64 sector = bb >> 10;
 1935           sector <<= sb->bblog_shift;
 1936           count <<= sb->bblog_shift;
 1937           if (bb + 1 == 0)
 1938                   break;
 1939           if (!badblocks_set(&rdev->badblocks, sector, count, 1))
 1940                   return -EINVAL;
 1941   }

bb->bblog_shit is in range of 0-255, variable sector is 64bit width, for
an invalid bb->bblog_shit, it is possible to make sector be overflowed
by the following calculation,
 1935           sector <<= sb->bblog_shift;
Then in turn when call badblocks_set() at line 1939 with the invalid
rdev->badblocks.shift set at line 1930, may result an overflow inside
_badblocks_clear() in block/badblocks.c.

Although there are many places to call badblocks APIs, the non-zero
shift value is only used in super_1_load(), other places always use 0 as
the shift value. Therefore it is unnecessary to do a general shift value
overflow check inside badblock API, and just check here as the caller.

This may avoid unnecessary check, make the badblocks API code more simple
and elegant.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Fixes: 1726c7746783 ("badblocks: improve badblocks_set() for multiple ranges handling")
Cc: stable@vger.kernel.org
Cc: Ramesh Adhikari <adhikari.resume@gmail.com>
Signed-off-by: Coly Li <colyli@fygo.io>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720111400.2120834-1-colyli@fygo.io
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1746,6 +1746,13 @@ static int super_1_load(struct md_rdev *
 				  rdev->bb_page, REQ_OP_READ, 0, true))
 			return -EIO;
 		bbp = (__le64 *)page_address(rdev->bb_page);
+
+		/* check for badblocks api. */
+		if (sb->bblog_shift >= BITS_PER_TYPE(sector_t)) {
+			pr_err("md: %pg: bogus bblog_shift %u for badblocks.\n",
+			       rdev->bdev, sb->bblog_shift);
+			return -EINVAL;
+		}
 		rdev->badblocks.shift = sb->bblog_shift;
 		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
 			u64 bb = le64_to_cpu(*bbp);


