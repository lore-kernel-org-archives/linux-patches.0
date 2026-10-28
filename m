Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207682;
	b=yzbjFAkjRV9M0o1zLSA45KvU5Isr7q/iaPxH3swj6fF4tQU5z+Neopv/2+c65s4A3AnY
	 WC59BqG0xq/9Pyc5hWZiYYju8K4GvnDNGreaEQof7kjVemVV1H5i9HhxVgFLtdgJIkflx
	 mCS89Rr24iZMPwhGctN0QRT1l2fj64SNie6P9CU4F4y+xNmCyJxYDwMCfP7KY7HSkLyfc
	 vJ7+O0b429WsclcizINJv3mOcmtL8VwM93RqweWE4hcyr5kJdkbnHkVXtCW5zDDwbYukE
	 PhlUh0EkbMszI/3QKUYQGxi+bsfjHNM9OGFBNM3xapVCYXeo6ElawRpDNPeNcvnft8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fMN6Ym9pRn0vut8fx1kgyFib+TykkHA8ruTyqL9iO7o=;
	b=nBsgTzHzWGJK5tDS7klxEB6yBMGyisDIXyYTs9lF5v6vpR41SjsO/khUk30g10ta8DMj
	 z5cDbVGvuIGJ9GDYUDHnKKMb8jMwvKZ4siSJJHpuM++pGNEQ//taxHVz6sX//6FA+rEWo
	 qgP76sKi8SmsXJjfI4mTm0K0SkxL5s2Cw5ChEe5+5tMEGrTH7M973zZgNW12RYivSwtel
	 kO1WRDD0//LAdKttICbgsVhgqwxKWR/du2gVS+N3XOLKjNIITqcLSk0fsTMxLQTbc04d7
	 3tEgbpfNPwCHMePu7Fy3I1aBXmyOuzU62mew3LDHqctq4WeLca4HAJTsw8MK/QWejCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ+BJefk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B4606A31A;
	Wed, 28 Oct 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ+BJefk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AE41F01825;
	Wed, 28 Oct 2026 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207681;
	bh=fMN6Ym9pRn0vut8fx1kgyFib+TykkHA8ruTyqL9iO7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ+BJefk7JV6Lq8ORyiDpGq2eMO4pK39RSyHJLpxkFqWckY3rm49TliWxe5dHejkd
	 xFOa+wg+UGXRE0qrfRWSQALMht2LeGd9nObnJF+eRGv2OpMgCkxZb1bI/tYDOQg1QQ
	 i7tZ/ZhaAiuKYbmMObvBIQkeybKMl/0Crn54MgVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 102/247] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Wed, 28 Oct 2026 17:58:25 +0100
Message-ID: <20261028165949.813007903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -265,8 +265,7 @@ static int ebs_ctr(struct dm_target *ti,
 
 	r = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1 ||
-	    tmp != (sector_t)tmp ||
-	    (sector_t)tmp >= ti->len) {
+	    tmp != (sector_t)tmp) {
 		ti->error = "Invalid device offset sector";
 		goto bad;
 	}


