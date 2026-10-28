Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209506;
	b=qXrRlvfAknx7eUn7yyAVhIhbb5DC1kvNkDmnBP0J1NevJqlV8A5spEkVtLC+NT3ixko4
	 79UEDJcSmRmz1Hn07FDnkZ5zODqM08A6dxK/cvGC7NIhjLg+rHba5OeGO/YHA12TTsXzV
	 f/WLy3IlJpBxgzcbadBoVFdIcg64LhIYDyuF4Rnt9GoZYdSOh0km2jZhvcmwQaqvKThdU
	 hFn5RWc6Mv0XrcsU3UlcijWROzwaWYY96Nk+BbAEydt0nK6dgJs1nQbPGHucUTPHCDm5s
	 hfeO1EBA+CyETtD00SMbr8O26ItIv5bQ2+DwfBmM+bbGyXpCXDT5jukPvNfdfSXX1iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJzwLPhxifLm7EZIZbevufdA6beIPwoRWYEgLKSm2MQ=;
	b=wf8YT4eM2R2gewGyP0kj/e/BNDbWFj3xP4qb+ZoOGhNftGB7xoCXwsgl2zsYkef7QI4N
	 Ambut8SbNBITgMx9DqNqm8UBlYcV0TXIfhfNYvFcSP9H8NkqhYzpOe2RHPo5tvAXfv+xl
	 ucESWs5z+6ItawrDxJQw8smDA3GbbkrRk7+2SaUvEeimAxWYpLkdYeK7d0W2eM7SDX7iM
	 3gqY0rQ1B5FVVSXyDPX35pxa+YpKXqoAcOcoDVUnJL/SQ9DrIJQtfRq47vhcPJ+uIBXHM
	 E69pYbXo6UUPo314SxcebJDOPK6r1f9UYlr7hN0ibyu73AbCUqEYpV73oHvGIbMuSYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+pQsYbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C208606A31E;
	Wed, 28 Oct 2026 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+pQsYbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD7C1F01825;
	Wed, 28 Oct 2026 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209506;
	bh=yJzwLPhxifLm7EZIZbevufdA6beIPwoRWYEgLKSm2MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+pQsYblPLiGYnVit/WvIvP1Ps7gqQNjTdqweiNXDAiK0p79AM6orMrIKbRF/2IUt
	 QuIBVDgDhkRjNG+TqyC9lNVyxlJ0t+r1atDrmaot4gfWQUJylbQkLc+8vVk38hasM2
	 T+VHXvVnTjoQTztPy5dxT+9wAP8Mz8dZAW5fw2bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 468/516] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028170014.567276650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Genjian Zhang <zhanggenjian@kylinos.cn>

commit 7ac81e2d2240f2c57bd073b0733e0b2abca38e82 upstream.

<offset> is a backing-device sector offset; ti->len is the virtual
target length. Comparing them rejects valid tables, e.g.:

  dmsetup create ebs0 --table "0 1048576 ebs /dev/sda 2097152 1 8"
  -> ebs: Invalid device offset sector (-EINVAL)

Drop the check. Bounds against the backing device are already
enforced later by device_area_is_invalid() via ebs_iterate_devices().

Cc: stable@vger.kernel.org
Fixes: d3c7b35c20d6 ("dm: add emulated block size target")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -263,8 +263,7 @@ static int ebs_ctr(struct dm_target *ti,
 
 	r = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1 ||
-	    tmp != (sector_t)tmp ||
-	    (sector_t)tmp >= ti->len) {
+	    tmp != (sector_t)tmp) {
 		ti->error = "Invalid device offset sector";
 		goto bad;
 	}


