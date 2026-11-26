Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705596;
	b=XUAA70aPUe2XGr/ym6mvNI1xbHZvrMXbllAY/4uKIdT0RXiXh+zPEZokGTUW2uZoDjvj
	 EG7GY9kQcjhaLrTY9XpeLRnhZyoptydJmQSSiC5pozaTQlzu9/4YrbhTTaGBgQgcd0QhH
	 NCS4zJd+7pVLC6E3CPfpYcc9HAOqprvotqkje7/nNVVdBefRD2YDLhqW6ZcUz39ruKXMP
	 s1anizw1mOsL1+RyHULi6fKRVlP9khaGV9N/Yt0Z7eZBNl/mwo47UojVaOH9r2hwiA7O9
	 XTKV4jFDVcyjbeMPj6U/ebnbdmNBKzjbtDc82M9SWwuPj56c5bOA4SrsuTHB30XwZ0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVTEGm+B3qqoZ14D4hzlZ/xo3kXfDYweXzTw55staVE=;
	b=qoqPL+kH5H53nB0GJh4B+cahKxTQX+1kuhhXCsxnaj20lYAVAGirOT1ETbQJlf83iolv
	 h/5VauepRAioeMMXom30NT0dHRBjNnqRatHdueCdAX1+9ucmo8IQFZCCjSST7/KtZzWzx
	 NjnPF+fAOWt5x/7gtcvxfp1Niz0DNG4q0oE3dIf4dwJRuNSRBIykf8UjjS1Y4O75LPLkC
	 0hFx+HgJSo4ZoPJuZ/A1gmiXAlxGHMY5QXdeDAWQNyUXxkZb9PVIY4a+MPCNLlNyEzqw6
	 iSY5tmarmGZp39eUBeJZvGI6b4A30+45zpXTF5Oe+lALN7pd6alTnqPPgrURCcMWIlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIsO0OXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C023606A31C;
	Thu, 26 Nov 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cIsO0OXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797541F000E0;
	Thu, 26 Nov 2026 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705596;
	bh=vVTEGm+B3qqoZ14D4hzlZ/xo3kXfDYweXzTw55staVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIsO0OXOtzto2aiX6xVYaxPiVx9qlW9f/qlx6jUQvEaUn1AnMzZZIQOAv/I6UVMfR
	 5fva2blHZ6DdG5YNdACF0fxX1uWhZuXJFv/GkUaPAyP74cRnMBjX4y81iozdZPCSiY
	 W2/+oc2dGKpguD0ede8VimUYEvpqUr4xmiGYaBvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 250/319] dm zoned: do not reclaim a random zone into another random zone
Date: Thu, 26 Nov 2026 15:40:18 +0100
Message-ID: <20261126144012.386137660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyrylo Biryuk <illofspeed@gmail.com>

commit dab527d83462a618d99bfc96370ce45ae3428706 upstream.

dmz_reclaim_rnd_data() falls back to a random destination zone when no
free sequential zone is available and the target has cache zones. When
the target is idle and the cache zone list is empty,
dmz_get_rnd_zone_for_reclaim() selects random zones of the zoned device
as well, so a random zone is then copied into another random zone. That
frees nothing: the next pass picks the next random zone and copies it
again, for as long as the target stays idle.

Seen on a two-device target (256 GiB regular cache device plus a 27 TB
host-managed drive) used as an md RAID5 member: after a full rebuild
every chunk was mapped and no sequential zone was free, and the idle
drive kept reading and writing while the free zone counters
in "dmsetup status" did not change.

Only switch to a random destination zone when the zone being reclaimed
is a cache zone: moving it to the zoned device still frees cache space.

This depends on "dm zoned: back off when reclaim cannot make progress":
without it, dmz_reclaim_work() would retry the resulting -ENOSPC at
once, and run dmz_check_dev(), for as long as the target stays idle.

Tested on 7.4-rc1 together with the previous patch, on a two-device
target (a 512 MiB RAM-backed regular cache device plus a 1 GiB
scsi_debug host-managed drive) filled until no sequential zone was
free, then idle for 60 seconds: the stock module made 877
random-to-random copies; with this series it made none, and each pass
failed with -ENOSPC once per DMZ_IDLE_PERIOD without a device check.

Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-zoned-reclaim.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -290,7 +290,13 @@ static int dmz_reclaim_rnd_data(struct d
 again:
 	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
 			       alloc_flags | DMZ_ALLOC_RECLAIM);
-	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
+	/*
+	 * If no free sequential zone is available, a cache zone can still be
+	 * moved into a free random zone of the zoned device, which frees cache
+	 * space. Do not do this for a random zone: moving it into another
+	 * random zone frees nothing and, on an idle target, repeats forever.
+	 */
+	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_is_cache(dzone)) {
 		alloc_flags = DMZ_ALLOC_RND;
 		goto again;
 	}


