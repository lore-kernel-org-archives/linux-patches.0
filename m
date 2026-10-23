Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774864;
	b=2a/nQl1hYTqGpWJ3REQoCCO2EOD8whBjZU9rGCqocVwIdJi/gs+Nmq952fmTpZmTTAdW
	 JNlVH1KNbQuM6OCvzhJFMWgseTfKlDmnULMu5VJVDnCj+VDJJAXpBoeyP54orVb1in7j0
	 +H3s+bwt9O2CnOiTA6YAyQQ5day1q9vyJFeiUNb8AINtJG3xpn98ATHdF46ttyFx2BOuL
	 tYL/OHhsaRFqRXXyLpz3tc6cEI1Gd+TH/IxXCz4No2SBrNv/VqV59113Rmjc8xaE9l/cb
	 wLU2PvlO8Ow2ClqirTHlnkZixtQkrgRYxBEHVc4tJe8KVjSOvzCQfzauZUPv9MBQAng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keGZmw/65TPZrmCINYKAPsTMHSqfcdwFrvNI+uZZu4o=;
	b=fq7hzNVxaIWDH+J3q9IN0nDmYfnJ1+4TFCGj9mh5MUrFEnxbuet86HDwyWqPYTE/Ip6r
	 d8JmSCPfzIi6d+xv1D/SpsfoVNK9itduTkJrJ+2fJfQ9XApAhhWUEoUBa/MSE3CdeksAj
	 4Dj7oeJUZ+/JLvgxuzYYdtC2yUjUY4cFvWvCzdle7ROejHIsePOazqnOSgnWmObQQlwl5
	 u8PeFwtUdoq+vMjXMwPReQWACH9G/9z4GELb0svIB1pjhLwH5YX+lrMVZQ8Z1GG+oyVRx
	 HBim+zEYVOXeNdC9gqawQBie6dvi4F0XjU/BWgOL/5OCsQ4G5lLSXSNB0gyx5V7KZSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2YyIk0n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612C606A31A;
	Fri, 23 Oct 2026 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N2YyIk0n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A681F01825;
	Fri, 23 Oct 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774864;
	bh=keGZmw/65TPZrmCINYKAPsTMHSqfcdwFrvNI+uZZu4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2YyIk0n8PCqgrUjhji7yRAZ1SVHIoik9LVgNl/pF5R+6GgzNYgiOHhPJtQak1INX
	 t59yD8+8IeompvIg/RIEdpsfm1uYhb6ihjzGsvfIjxby7ylGQ8FQ6knEKU4bysBHKW
	 RzN63jIvHGN2i1r9V8wlu1nxfTn6rDTNhuGj0a8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 185/242] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Fri, 23 Oct 2026 18:40:27 +0200
Message-ID: <20261023163718.162390332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


