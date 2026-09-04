Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183092F9DA1;
	Fri,  4 Sep 2026 05:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501035; cv=none; b=OLMCiOEOdY3oALZKEGpx6gG7ZRZpH/viT16HmTipFCWZ9nttNmWw3F1BSiAsvfk4Pp0gobqyI+lfqul++5AOCofXMpt4BF6Qruy7AK70JGWrOVxDgPo5AYfdyiMRSHUv8790FrdjZTlgF9FdKHwtyG3ydpsKQDWTe1ejHpxJeQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501035; c=relaxed/simple;
	bh=pcCAtf0n9pFdGylkEnrJIFgMZR/oLq5n7Um7KFE15qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M57ygUh/bWM4DZ+npJ93RGpr2ScZrM+AMqjUEQtXZWx2vCCPmi8VktkVxEZ+hjWCtsFjphPq4RI4SO0qCwHlcPRvdoQVCsJDHNIIrV3fHeJeHNtZsZsKucUZIzbAKWaT6pNGwNZYqhHA9zE6qpZo/1uxYz+VF8o8zKjBAlAyuNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9sIpNby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9sIpNby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733191F00A3D;
	Fri,  4 Sep 2026 05:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501034;
	bh=tfijud5p6/ZyySaXsXY+Y96zv3ZnXSLgLfVTF/vcQ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9sIpNbyjAY8MNHkZPTfqxD5bbAa3WHE3KlGWnJWamCmgNdtWXeT1xDjSfcjh1Fm9
	 rUEwzE7WShkiBNaHMZQlKCaTIRv46/6JJ4+tuatnZTiBAnwM7f70ZPT2ZLHVQPtYcM
	 fjoxEEOpKMkSJBvaM8+c2vbUBrmmMohnBlqqKfeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramesh Adhikari <adhikari.resume@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Yu Kuai <yukuai@fygo.io>
Subject: [PATCH 6.18 268/552] md: do overflow check for sb->bblog_shift in super_1_load()
Date: Fri,  4 Sep 2026 06:57:05 +0200
Message-ID: <20260904045756.048605176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -1917,6 +1917,13 @@ static int super_1_load(struct md_rdev *
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


