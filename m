Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623415;
	b=2qk/tG24wE5GIfaeX5frteMSUL2hECDVz8QqJJBnuqShJFP4TcMi/rMbfnEmTTF9WNXi
	 WTZ+CiU0nveZU/641Cap5gmoWef5aMcZEbWdpSgvKOgYnr3yy017CPWYJiEGj9x9MHJNL
	 Sz8QiTSkQuk3D067hBGNsrZiASTUsD6va2eH3Rfu5rNd0VbSu9ZqqzgZ+J0rcc9R4+lnv
	 xxJRJ5aEtkWD3hSEOz15Ul5qz7nHsL7PyXhZB+F6DvdF06eXwiK+xNWoG/sPbRurgaMod
	 VIq/fLRiZ0+JnMKoyppuq03w18QGNIgyhhjh8SuO2A5paICYWGXxsG8FhP4oSYKDPIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtRTh6nfDAbRYN6tit7HmtpR15Cu0nlThewMWf0Fo2k=;
	b=vRSA9YDSfsEuh9EPE+ZKfBTaTX1FXJfm7Ja3DQgExEfg8ixaO0HSm1YYIV4LEQDp6ING
	 whWycXaG45jLe6RNGGxInOasHFOa17TQqFpImxtXBtUfgy7BwrZXnPGiTznywo+zvVb98
	 uldtt7SF6P0C3SOTKtLCNTBOiouQiVnx13fMcuF2LvbvPdiPdx6opI6RqqUiwlFH4sJP1
	 Jqb9L+1nygy4cOefBLmi7lSGSNFjzmDsUOcUBDBYsfIWd7v5rF/u+BLKF+t9Uj6Ja7+pR
	 qpYUC0DfynU/T+lWhpdzQ6P2J84UFdIHskCOlaqxFdicloBSKF5pvyvR6UfJZErUW3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2YkBklP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D24606A326;
	Wed, 25 Nov 2026 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H2YkBklP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521531F000C0;
	Wed, 25 Nov 2026 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623414;
	bh=WtRTh6nfDAbRYN6tit7HmtpR15Cu0nlThewMWf0Fo2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2YkBklP93Np2vAT0/J3K5PVoKtrXlrSuLvAaSx//13MPtPfwb75ZdFCYrXmmUvsQ
	 IEJlZGlb6d2hiwtssDyFpQ8+dJbxkrmrX3u7wTS859nvX+Cc5HPXVFFW1XJqE950QL
	 ljw4Wd+7ZS85XQo3NSfm84Qfwu1wgO3MZ8Hwxaqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bundschuh <mkbund@amazon.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.18 852/990] dm: fix infinite loop in dm_blk_do_report_zones()
Date: Wed, 25 Nov 2026 15:36:59 +0100
Message-ID: <20261125143841.984773991@linuxfoundation.org>
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

From: Mark Bundschuh <mkbund@amazon.com>

commit 648320de920b30ae1730bbf0e8b86c0df0fb490a upstream.

If the device underlying a zoned target is removed, its capacity is set
to 0 and blkdev_report_zones() returns 0 without reporting any zones.
The mapped device keeps its old capacity, so args->zone_idx and
args->next_sector never advance and dm_blk_do_report_zones() loops
forever. On non-preemptible kernels this causes soft lockups and RCU
stalls.

The following sequence of commands triggers the hang:

modprobe scsi_debug zbc=managed dev_size_mb=1024 zone_size_mb=64
udevadm settle
echo '0 2097152 linear /dev/sda 0' | dmsetup create lin
echo 1 > /sys/block/sda/device/delete
blkzone report -o 0 -c 1 /dev/mapper/lin

Fix this by returning -EIO when a target reports no zones. The target
always maps args->next_sector, so a zero return means the underlying
device no longer covers that sector.

Fixes: d41003513e61 ("block: rework zone reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-zone.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -33,6 +33,8 @@ static int dm_blk_do_report_zones(struct
 					      nr_zones - args->zone_idx);
 		if (ret < 0)
 			return ret;
+		if (!ret)
+			return -EIO;
 	} while (args->zone_idx < nr_zones &&
 		 args->next_sector < get_capacity(md->disk));
 


