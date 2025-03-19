Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977971DA112;
	Wed, 19 Mar 2025 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395093; cv=none; b=IDrftsieMhNFV04M0Bzycp2eiAqYZra/UlzCuAkfOd7KPPG82rVJAfrsS2mbZbd7Wa/roVLneVw5juAXYif9oH3RG7r61sNKhCu3RA3w6vU3aWtwY7hhYb5BRndXWjy8Y2/TkgBcsVLQaO+Kp7RZ2mmxQkLj5kU9K0AX+F89NO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395093; c=relaxed/simple;
	bh=4vY0bT+t5XOtOoOVBwlbKstJltn2fEWUakgexcelQlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC1lVSNABi2u2pb9nUDmgd+ylCtH9J5/nRImR+velaPXLVvz4CDEHh9gzsgHwkU/FWlR43oKsCnrp1Zj0CcQhTdM6QAC/EWC527V8/cQCCCRPKOZMS2lgG8Cv1sD3Q5Ls8C7VMBpVLasgc1AtoJnpDiCbCSl7gNj9YllUv4U5+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzRJjOqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzRJjOqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE2BC4CEE4;
	Wed, 19 Mar 2025 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395093;
	bh=4vY0bT+t5XOtOoOVBwlbKstJltn2fEWUakgexcelQlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzRJjOqplk45St0dgkwuHRWTtQismE1kZO8nQq8aqZYXcVx/j8UW3PCRuV6HLV99Y
	 NVyNmDlXBF4pKHzpOD49SWO9cB2v5t7E0f9Xho04UZ1yku9qfCgoRLhSZo2Huqthar
	 i77PO3X2G/XZkbzv120R5dxfdSnLu5tg2Eo9pPtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/231] block: fix kmem_cache of name bio-108 already exists
Date: Wed, 19 Mar 2025 07:30:35 -0700
Message-ID: <20250319143030.344953839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b654f7a51ffb386131de42aa98ed831f8c126546 ]

Device mapper bioset often has big bio_slab size, which can be more than
1000, then 8byte can't hold the slab name any more, cause the kmem_cache
allocation warning of 'kmem_cache of name 'bio-108' already exists'.

Fix the warning by extending bio_slab->name to 12 bytes, but fix output
of /proc/slabinfo

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250228132656.2838008-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index ac4d77c889322..43d4ae26f4758 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -77,7 +77,7 @@ struct bio_slab {
 	struct kmem_cache *slab;
 	unsigned int slab_ref;
 	unsigned int slab_size;
-	char name[8];
+	char name[12];
 };
 static DEFINE_MUTEX(bio_slab_lock);
 static DEFINE_XARRAY(bio_slabs);
-- 
2.39.5



