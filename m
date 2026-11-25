Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624063;
	b=02r5PG48M1i8qAosVi4+haJMAgLtCYDUQZ/J90chfEv2pfTV/rI20RM0wp0SOiwA4DDZ
	 yI14ehBoiVcvf9PrB4BXPzLgdFw0Vme7d63zRwJU8J0CXb2hsGaXTt4a/cXixDvwfA4Ca
	 Efl2Vw068e/ItSZRihKTSSRWFsJPcexEHOBKWzbca8e5FTkMEgW7X/qWEr5ZOd+DUUZAL
	 aT+8dngD87D/f2goXwo5XBZR+AtoTnpSI4rcYCUIrP1NwzFPktocjJwePrX+DR0kgvmC2
	 Hd2rTymssPiapcYd59rUwIEQBWVy0rQY92hRtGyRf5C1CzWbSiCbeMITaqzhg8rLHhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bjsxO/h/RxFuFmlkyhZNClVOMYtEyjnmQWn9GWp8wWM=;
	b=jDXfRrpeUIdJ07D+AoCChvtQmPslHjG9otc9d4HpZoNizKQudkGH9zk4B7DhpMnTOd8D
	 0ta/GTTd6+YmYVhkE2UjZm4Zc6oIcmPb0pLoEzr6p6dkaWEDwRSVePTBol1Taii9b1HIj
	 ivcdfWijm2UzxztI8zBQKhkioc970NACRkYknZnITgupSYeDpiR5Rj4dRSmOERS+Xbraz
	 QBAJIIdQjI5EAiUltXiJ6mrpRH1w15Y80sDk3JHw133czqthbN+aC4ZHXkqm76HwttHdJ
	 2EDZgPUfz98WkfAWtQpWi3mTZx8qUm63HCj9Efk0y+DcTZFH1pVUajHVu17hrqIP+VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZB5xi64;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC1606A323;
	Wed, 25 Nov 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZB5xi64
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ACD1F000CA;
	Wed, 25 Nov 2026 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624063;
	bh=bjsxO/h/RxFuFmlkyhZNClVOMYtEyjnmQWn9GWp8wWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZB5xi64OIQDP0LjqvtADH2IeBxR8/e/ayiqzO1w8DADYqKMuJQ1tprl63o1MOto/
	 T5NX9xkpPyiMks3JnwkBt9w3A+bw+RvNaQjRMIY5Au9c3rKsVO2IAT3VidIVfjiz2Z
	 fAqSdvLxSKhvz6KdWpSmGr/+YHyCE0MJA5eDG2hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/816] btrfs: zoned: fix double free of bitmaps on clone failure
Date: Wed, 25 Nov 2026 15:27:00 +0100
Message-ID: <20261125143850.888127574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 8c66a6aa59a5df1d672d72b7cd379d897ff73200 ]

btrfs_clone_dev_zone_info() duplicates the original orig_dev->zone_info
with kmemdup(), which also copies the seq_zones, empty_zones and
active_zones pointers. The clone then replaces them one by one with
fresh bitmaps. If one of the allocations fails, the error path frees all
three pointers, including those not yet replaced, which still point to
the bitmaps owned by the original device.

Clear the three pointers right after kmemdup() so the error path only frees
what this function allocated.

Fixes: 21e61ec6d0bb ("btrfs: zoned: clone zoned device info when cloning a device")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e417613ca9c60..b4bb02bd99ae5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -615,6 +615,11 @@ struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *o
 	if (!zone_info)
 		return NULL;
 
+	/* Don't let the error path free the bitmaps still owned by @orig_dev. */
+	zone_info->seq_zones = NULL;
+	zone_info->empty_zones = NULL;
+	zone_info->active_zones = NULL;
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones)
 		goto out;
-- 
2.53.0



