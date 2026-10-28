Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211872;
	b=Fb+59fC/9dhbjblvRIWvaEWY8UNbedh7Ggqm09tufaFfXmN/RophoVi7OjLeqaB6EPpG
	 pe8u0z/cVGdIVX0Fak1DeDC348CRgheMP6twHfAgxw8jlu9xBXM1v80qM2wrBMFIJRD/g
	 +cLePYOUVHb3OO05kTti3iMLmsYeWUhmQ545RiXT0lW0hFoSwTU7rbb0DBiIIrlGBDdi9
	 x/KO0WzyWnAambEQA8nnQdcUYxzBPiPaq/ewCPJgkVx+ni7aiWm8lI2C4jFpSyJX4vgJ4
	 hfEFGzUt/Deiwa4qyNmG4XFaFpUt3T4YKo9um5E3JQn02PxjsPTLv8V6cPNHsGKroEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Io7nbV8ymd75KN/a46Ht0gbrD2jcGeB5dUVOkQq0EQ8=;
	b=Fw7MQrwIvFpxRK/7IT758zmaY9Dxs7Dats7esm3+zd0+NwLXxRkZ1q+zxbLip6kB2r2e
	 nr77if54OuffGK+rAAlygwI+aWfra3o3I+MxRz9zAKhnz0ZYvy4sdBwiT9CTPPCddK2ro
	 HLT/G2QeMAx73lTYqAj9pmcFLx0U+vxZ37gWBwxOFZs1Cb5mzISu2dcBj7OfjN2xNDakM
	 4nnHo8LRBdkbH23gYTgEMGqeZZNFqflknHsB4RFkYH7ZvRM+6YqQ1/T5aGHAM5bVZCOcc
	 HmOfN37cjXdt8JzmK4mGP6U92GGliWsx+xpas69oUhxwRJzswFMDuzjJI/OnQjkeshA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfRtqQZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FBD606A31F;
	Wed, 28 Oct 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfRtqQZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D971F01825;
	Wed, 28 Oct 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211872;
	bh=Io7nbV8ymd75KN/a46Ht0gbrD2jcGeB5dUVOkQq0EQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAfRtqQZ6n32rTfLjvtmH6VEymT7RQfae4RlrmNpjsjt+GBBAOrCl/14swjfjhMHP
	 rtX/n0k6jBNvlOufkxuygX96rg5rbqxeHKqr8MrH/QbQe0+dKpvW31CVXkP+dhA3pK
	 N6BY8As2FlzeqdNL9FalROnftkyb7Zjl/fGIIBu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 513/571] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Wed, 28 Oct 2026 18:01:00 +0100
Message-ID: <20261028170020.201574891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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


