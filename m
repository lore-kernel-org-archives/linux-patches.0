Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210085;
	b=Indmgv3eR59PP9q7mP4eA+ycQQKAxYpMmuHMWOJT+P6a/OgYT5AMaGUW4314tXWkFdNP
	 vBwKk04vlNyUSuIRGfjUHhdgzRn1GmPAUzKcEvO6rYVYF6UOl0ygQX5x6O6U9LrYJdWsE
	 LlPsCH1gJ0FlgNUB9epA/zQYDmCFi5rh3v+bLuHeOb4IzoWE8kxFRgkwN0qOwqOo4oPRI
	 U2oUQUPZCVNXWHuzNRgqNRR2mVip7ghvI06dO3GWp5RgYlshu34j+I4p5y/5qLib7176e
	 x0P3+4MCEW7ahFMFAzflB1NqSN6YZwD1D16UIFe26V9K8KGJQya1BysfRCduuPIl3kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r2SVYRQBSXTzQxxmwRSzS/ORlIs4QWDD4h8HEU/x5/M=;
	b=KR+b6iLkpjS68QPDecYDjAZGrBStnEXn/r2i/Mn1IbWy56mqaSkMG9ozJRRNE+BXabgk
	 yHuJm/s6RvDtQc1FPX/pdYfe+R8ZmNOtY7+wQM1VxgDPhBjCwfFJfzN3yvoG0iDsK7fb9
	 UOQUxjOKofopsALnYntloV/y7/jjcM4UOGhH0JFcDiRFO6TqyrPDr2aIGccWJS9vNw35l
	 KHAvTPoj1xzIGBVskMm81oGoooh0CRlj+alJgeli0a8mMWL7BkaKNxogUz8vSlE0bqE4q
	 mKgYSD9on1YSYSYHZXvZjmKid42NN1RV93sWTsajVMggM6RrtLLQ9BcR78lWwOOdICA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXVJfU9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE5606A337;
	Wed, 28 Oct 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXVJfU9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F52F1F01828;
	Wed, 28 Oct 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210084;
	bh=r2SVYRQBSXTzQxxmwRSzS/ORlIs4QWDD4h8HEU/x5/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXVJfU9Ix3oQPLlOeoBahF/pZmAO4TPYI1QJN4IfRRUm7G8M0hV/llIZo0752/7EJ
	 FLw5J1gL+6nGVkEh7gcjrtYrtn+RV2vgghF/Eg8vLt+26y8sm18oOdgpga7MVjTijn
	 OgkO2Kpykpy7Z1aI+mO9hOJve/xkphx6r+wmS3Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 071/168] dm-ebs: fix incorrect device offset check in ebs_ctr()
Date: Wed, 28 Oct 2026 18:00:07 +0100
Message-ID: <20261028165944.767326189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


