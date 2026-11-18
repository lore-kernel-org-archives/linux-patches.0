Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028463;
	b=lZyMlG9f9QlMunbt4qfVZSe4XEcrF0khetYcbsWGAiWbDKgp6VmztOpC0B7X7d/i5aoC
	 Q0pcyC19YSwN9JcsnknRvKyVVfLEHv+EVncZrzQ5pyReUhOkvaiSMqfCtnuijAorkO0g2
	 Q7e9GI6DUSCiYkOUqsPRq5V02eTfEsi/m5ku56Ju0XfvfYDzXOBVGqkS+PG4sf11VxP30
	 GhA2iEWL9rQy2IinqDmaIi3gVcES9VZeb+GrJmz1XS0XW22+iC4B28bgYE2RbEifLWeFH
	 jvjmLGWl19Wrfr3TCqQorGjiM+l0pKTsyFSraJ8G7CRIueqYlqJTz0tI0Mww8K9buFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uPgRoL9ig+CqQPJhwzubiQAwrjxTbfazZcm+9t5YFjQ=;
	b=31sLhvnPNlrDemc8qI4lCL4wNXt3YxN/MUeBfc+DMx8ajL+dH4CkY+2M3mdcCIm244j/
	 s3QiYP2f0Z3r88JFi3WUKL9ey926A+wYjSpxg8E6mDOszn8sFSrqTfPZZLZURQKSlegcR
	 WGyYtF9c91AqTb9A06eIWL7MFr+f/trDasSa9qE8bPNGnjZ9tmFCRQgMJ6KFJ7SPEWZy9
	 YpCl/WheHp7wrr0S/Wgtm3L8fh0btCcdRNm5C/AfffNOjtLCiUgLQCuG2VF91EklKSnsM
	 23e7f4uRz/nzYCUc/CQPNnI4UtxqNyiHsYKNLDUxLsLwYC1MxgL1pygxNdGHh7e2GRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXf3sxAV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE27606A31C;
	Wed, 18 Nov 2026 19:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXf3sxAV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D25D1F000C4;
	Wed, 18 Nov 2026 19:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028462;
	bh=uPgRoL9ig+CqQPJhwzubiQAwrjxTbfazZcm+9t5YFjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXf3sxAVekXkTDraFrwpwCQiUwFuKt1M17/h2YEYr75Wr7KQ1jkXAdUH6k0IB9uGI
	 nhHeYNE1iapV8mFTspAnvBsLQ7lCfuTW4Wdkaojm34YM3t3RkKqIMgqcmVNeupxqJj
	 1yi2gbuw1s5yiSafplR2A6UjVAHg0DYnvveht8Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 2135/2151] zloop: fix block size query
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150239.448710060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 8fbee85a90789d367c347b1cfd5a5ef37f3a934a upstream.

The block size obviously needs to be queried when it is not set, not when
it already is set.

Reported: Damien Le Moal <dlemoal@kernel.org>
Fixes: 5e9929e2f03c ("zloop: share more code for opening a zone backing file")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20261102055558.3212814-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zloop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -841,7 +841,7 @@ static int zloop_init_zone(struct zloop_
 		goto out_fput;
 	}
 
-	if (zlo->block_size) {
+	if (!zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
 			goto out_fput;


