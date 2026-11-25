Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620240;
	b=RgGu3e/SJznHBlIvW1LNeujk8ae38QJz57SCPbnH5V399uxAeRqpWSj4Zl/HK8FBa4Gy
	 BwWzN3xvAtZL8fq9myUVI2amMh9+AIqux2+SvxSgPS2AOiSmWNm2F4PO3CC/ZzR1Hv381
	 GdZliOZK2ECknslbi6oBSZ/FeztE3NEOOc9ufmHq7l6Ps6/g4ZHIYl6i5mnhGrOWUxIv6
	 zOvVlmcCNjCf1CZSPytwwGFXrhbqf+tzQktYoHFEioFUdnkGMH4RNK1ytPsc5bXyhY8uT
	 dYUuvJTplQJVKCM+xwDN2hSQ3eaiAiAJpTAza3jhHgWGT6Az0ziD0WS8mlx69puFvpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a6nj/pWGgyfG/Z6VClBehBd58vbj1XhZVK0QXaFD6+8=;
	b=W+eicmdMTQg682GCeBi3GSJZtSbFOZgERNX6zMHCHD/ZkpjKp7OkzjNUZzSz2Q2mnZS9
	 8YdoPcZWDn/WvGtd5VRVWP5v1b7kYhXfP4R9C9DA2DapnRSh16+vKzV3pyUooBgioOsZI
	 DnCJXETzVnzIpZL6Nbzovj5aytxpC0pn9mgo+5beAKdvx0qk4eucxnhZJ2moR4GgmJ8YW
	 d2LZYl+jGQV87zndqwt6qc7x7w6P+xhxmHDkpVK0Ey1VgBs7yVnvghK0pZ2Ga/bc/0xlx
	 OJ27JVLQGSt2dpCaPsOY/Z5YZKyI5xqHbDWJqq06/NpjGcm/LizQMkAp2l1s17rmgyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkJmG8e4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20B606A33D;
	Wed, 25 Nov 2026 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IkJmG8e4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C7E1F01576;
	Wed, 25 Nov 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620240;
	bh=a6nj/pWGgyfG/Z6VClBehBd58vbj1XhZVK0QXaFD6+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkJmG8e48BYGIRcKP/MGdnzXV/7gRJdI9FZpp29EbakCzX8x5AApblKzCOymqZdhi
	 NTjNVzus2iqF/adltmUmLPMGh1YoP08L8nZ6ssWYWRSD3KMT44MfIfinGTx02+X9WP
	 xSbitySky4UsGe0lJZETg3D7GGV/io3rO0XgG3GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bundschuh <mkbund@amazon.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.3 0855/1005] dm: fix infinite loop in dm_blk_do_report_zones()
Date: Wed, 25 Nov 2026 15:36:33 +0100
Message-ID: <20261125143841.737994458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


