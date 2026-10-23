Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774113;
	b=0FTA7AXGFfPyixcm1ZY+MWOgVyQxyTqFDXj2rGXorBxZBQbrw1YTaonWEgdaIOo5GQh/
	 qCDm9urT/M0Jz+/uksrVH7hnXHRxyj6s2BMaDxp+VI1WCwNNwH3RwXhHsiTqhrECalGTH
	 Dc+QH26dpS17ZbvjgJNaGpljsM9nD0Bt8ZjDCOGUnTwd/6fI7dU+JYuznienPyRw813Qc
	 PZeuQ2/AMmP0K/X+/5o9aQmt1ylmtOpEq+eswt0WD5/M7vtY4tC3BKPkNcDPr8TdDlQZr
	 /kS5DfKxNsrY+IpdBvZADP7DOvhMrmrWW0YqYQDFkAp6rGoe7GE62Pe1/8BDab0GVAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DUIRMJU6P5FKVMs+dFXCq0y6n09kr8YaDsYu5BxXUeE=;
	b=F/5FanutYZC0Cyjyxyhakydk5r9IUwcIdGPtAbwOcS0QzAlFSs4vgbt5knKeifggJZTy
	 VvJiKT8zyaSxd4VVbYey43ETUdJDA+eLUOIDyp3Pju03iOaJpx5DTM+gggWKCnjmwyMpD
	 U65e9/XcSwNsduEeBFMnrL/tPwg+zmgjbsOjjtNze5JFQxpsZD6A/L0gQAhD4UyEF+sQn
	 r3a9wSFRU4mjtDwDOGDzS90S78kCW2CeJP4ua4Y0l5726+4COhWoqueFVHKBHAr048ETg
	 gPrLyU+h6e/uPUOYb5dyOXWIkJv+N0POjT7GJguudomIN+IUKzWoyEecXe3eshGPC4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkxYnxVU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1CA606A31A;
	Fri, 23 Oct 2026 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MkxYnxVU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161A71F01825;
	Fri, 23 Oct 2026 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774112;
	bh=DUIRMJU6P5FKVMs+dFXCq0y6n09kr8YaDsYu5BxXUeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkxYnxVU/u05/Wqui125VweAtp4pK6nZj+Y6rGMhIPuFnk/6+Sf3r1ccAddR2Oes7
	 8B3LTbu0JIfYM0V/1/sX8ghqOPLQezTP4D8T9EToVKBP9ZM0uLP9fGf/qt3Wo/0SM3
	 txsETSHMtsOIY+pd+bbBdXERvUooSy6ZIeE2Dx5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 124/193] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Fri, 23 Oct 2026 18:36:41 +0200
Message-ID: <20261023163717.138789337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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


