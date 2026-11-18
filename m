Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022400;
	b=EinSFkmHKr0v37FnyqxmG3bnxf86FJm2Og7sdozTTi1GNMRXb6dAOVwd9ZQTwy2TyVMh
	 OOpCowRg5Q3oOrjyJVWQITLKZTdbT+JkitFAO2Y7pTp/qnunDoW6tHLPRvVQ7YWJtQzg2
	 cpq2JRrGBEQMx7HbpncdNgQp7jB+pDoH752/zMtgyYdGrLMKdIDlQr3+P8TrXRQ7V5Fv2
	 u8ceAZirhBm6XEEFIA0QRk98ZlAoiHaWok+v6bmI2zBVY7rOIcltC+i3fmGaGKg2xBGMz
	 uc+ouhxTWigRxWV/5WjRGAhmu+gTXMFLcH2tGnIAbb5BtffOm2z7KLI3tpdnsPz8euA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+50H+0Q49QQMQAdtqgwqK+07MzJEdblR49YJb1rLz5Y=;
	b=ArBMlL9BSvWAdYSwpdHA3FKe//vK7MrDY6DZpQTPsn3ywKcDBhikMjL0vQ6uNrhc4nJ8
	 DV+wGJdS7EBJDOMO3LYsQX3W8SDDYE0C4FE5VY6blVliZB8SijD7Yelksaw1EWRbkQOTb
	 DPHpRv0GXgam7EFlbFODc8DQY37cRd6MV1j23nNAvS+CuN6sb/kq9AwLKvyC88S6di/7x
	 Ix9ZfhMA72Ps+z6+48tjctVxWJAyqh4rQrEN/zTvJG09VltUA6sO0IDVEdH9gHrlAzmnp
	 Vsdss/bgtC6Q7q3B2kYbFBr78a9UGg2C4oM2Z0qcQEb+sZdcqJ3VD1Qpwici7w4crtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vIi01k6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AE606A32F;
	Wed, 18 Nov 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vIi01k6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA71F000C8;
	Wed, 18 Nov 2026 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022400;
	bh=+50H+0Q49QQMQAdtqgwqK+07MzJEdblR49YJb1rLz5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIi01k6/xCtltoaY7CIxSEY6STaIpeP8gkfCIy9rhcSeuppWpnMY6dKb+0bwGGlq5
	 aVyAyjyqDS7VQNPhbVHAv282CtxRGy+JxQ15Cg5l+08edJgG2fuhYawbmMmwV1VFob
	 TeWyeX29ZcnXNnaHcMxV+xFLfMFRyMQBI6/pnrJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 2648/2651] zloop: fix block size query
Date: Wed, 18 Nov 2026 16:04:48 +0100
Message-ID: <20261118150419.396239578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
@@ -1127,7 +1127,7 @@ static int zloop_init_zone(struct zloop_
 		goto out_fput;
 	}
 
-	if (zlo->block_size) {
+	if (!zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
 			goto out_fput;


