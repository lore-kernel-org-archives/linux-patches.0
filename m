Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0347A872;
	Sat, 12 Sep 2026 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220289; cv=none; b=Qsvt04zIzeiC1XN4IVQzwoTWs1Rfo+n9Q1oaOnMI++nUZmT96Bn5NBlN4+wRFCODoU7nPBDhkL5h2qGJmYpKaqP5jloOkGWf2mtO+GJLUpvf99pWVkJY8IYpETtA/Q6ajmesL/gB1It9rvVKN78kYph6QyJgamVkxMT63v/lINI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220289; c=relaxed/simple;
	bh=IAgxxz5JHP/F0XUCCyZmy3EC7PGIewOa/nOx82PWMKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw9zsY/GBzS398Q7xwdy1EIks4MiLiZ1bXE6FL7YY6AXyUOa3JHCd1IuJxoOiOEGTeNTsgt5t4eBMdOS7IgDGJH9/YI5osiMmh+3T/xTQy/b+2neKqM5n1PqP0uyGI8h2AwCPpG+b67kF75jhICU1wz/uBiThY77RMCw8NShiw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaF/FFON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaF/FFON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18FB1F000FF;
	Sat, 12 Sep 2026 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220288;
	bh=k7KhUnhRgKGdjx516e7eSjghvOUHUfP6VcPayTkXa6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaF/FFON/xKXjZU8OXclYmv98i84J7Hmp+0AHKlRA7Hsjn524djwzSR5oxbaH1eML
	 WwiaWT9n/ok2V3B9Gm6EM7ln9PWUSFM9hqbwLbLTGB9YVTDGI0u4s3dvzTIUXEUq99
	 j9vO10JK16KVP3kgKZz6XNSfNafW7bE587cXCjhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Adhikari <adhikari.resume@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 6.6 0145/1424] md: do overflow check for sb->bblog_shift in super_1_load()
Date: Sat, 12 Sep 2026 08:42:57 +0200
Message-ID: <20260912065610.545691131@linuxfoundation.org>
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
@@ -1726,6 +1726,13 @@ static int super_1_load(struct md_rdev *
 				  rdev->bb_page, REQ_OP_READ, true))
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


