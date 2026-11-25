Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623469;
	b=hu26YKyqf45I69aH5IA8RL7AvrSC57fN1z2uoOSUphFgaaZnhq4EkbPg3hJa3rPVBwgV
	 uxuDHL0tPj7rd+y87bc3QSje/ZxK7MAz+BWTYA2SZQWJ6yElGeU2JyV6vnXQli46oQTz1
	 608nMecbhgbo9OfTEmyNj2EWIK9H2tqtb6611j3FNeADaNcusXaYXpm1Ss/yS+g0GMrUV
	 oaB82KaExzjLUfb0loJHVAfnwRJkSHR4+cFSI0g7CxB9wRyQCM6Wetk1QiTNmq9wU7H5A
	 guVuGyxdczaDwVk+tvyKTORazYs3paIlu7NfW+/XdjDBwaDyGtEnT1HLQL8xZedNwxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jQfK/7gtES1jReouWPhGlUeWgcwUwdU83HtCBDXUSY=;
	b=PXEhNWdTrsd5kKC7zIIrwzKy/8sr0q0nQXgmcIusP5qecOFMzd/JkYAiD6eSqyimdS6e
	 1/z+4pYQlp9P1IV+lNdWyDszeXhHHQfRpzSXRKNe8km2J81dtPYjLbp2bJsAYA8sIh439
	 tFFuXrtefEicsmTZKqRJwagjJo2wK3lAngjrokH5oPB4mB0jrPao05D0GBbFju/08gBct
	 8XwmXXCSnBSjiLKtqWn6gaWWkbdejvfNEEzgvC+T/rzPJS5EXjNN4GRPRY+RZj0zeZNMS
	 4WImbcE5327m8g+E+87Ot7DYUdCuO+U+vNtOovGqsmPqv0sgPShNcUmcI+gEdOm4CJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC87BBpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB06606A321;
	Wed, 25 Nov 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC87BBpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD7B1F000C4;
	Wed, 25 Nov 2026 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623469;
	bh=9jQfK/7gtES1jReouWPhGlUeWgcwUwdU83HtCBDXUSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wC87BBpDbRuaL3GpXfX4uy5UGuOminHRbLz//Ke+cPLX1yfQlByqiffALZxLmgiXR
	 4RuPPxjRHU4/vx+7KxcP8Vk7WYtUCicp9M0prpeKB1QUDIreRctM5KGbYsFcl9dVEs
	 o71SzgMv0pAhAnLspzSZIICTgg3AD82dkIrejmjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Kyrylo Biryuk <illofspeed@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 869/990] dm zoned: do not reclaim a random zone into another random zone
Date: Wed, 25 Nov 2026 15:37:16 +0100
Message-ID: <20261125143842.377175343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


