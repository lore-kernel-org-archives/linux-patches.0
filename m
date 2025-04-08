Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222E25FA13;
	Tue,  8 Apr 2025 11:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112391; cv=none; b=eJ+sIE31TKejIZugRLwdvYZAGeJ+4Le0Bn/Og5eo1PpCWiELVdNdWLgC+EBgXGWrK9fU5sOsEjYrNFmiKyqhvxbVmG3NLyj4Trgctg2Thu4OPcIGy+MS2l05CbPtDh07j4weM6gHlUz9S8KAuW2x6jxIzZ4NsX07miF7bEywoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112391; c=relaxed/simple;
	bh=TSsk73M2t67QPCzE5b79J/Se10U7nBdUJplbEK2vjH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2Wu2/TN5leAnqwMvM55SnXCFqSZG+fHCJUdqlG2b0J2o4jxrIOiXCggAU6u8fRL4OIAPE6+y40pWbU8gF5ld2DWgv4mWCfp9A6RBc3NmkwDSbc176uBV8ZGDbMbWItsW/iVmtjPW9duHtckVAsDcp8xH5xo1OyFuyZXnypr38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq9/B/1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq9/B/1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF875C4CEE5;
	Tue,  8 Apr 2025 11:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112391;
	bh=TSsk73M2t67QPCzE5b79J/Se10U7nBdUJplbEK2vjH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xq9/B/1Thw3IwO/ipnTDvrVzs3m9TTyFXpImSRrTsSIttyhSsl9qyoMTxqapJ8apQ
	 uTrEDmfREixCyPq3DmaNL9pSXWDK+mFOzYWPyVIHXKKuA3y/9/EethwXNYWclaPCm1
	 5PCqZO5pNBWZS9mmkngAozsmHz5BBQbM07cIptYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/279] block: fix kmem_cache of name bio-108 already exists
Date: Tue,  8 Apr 2025 12:47:15 +0200
Message-ID: <20250408104827.767593358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 92399883bc5e1..029dba492ac2d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -73,7 +73,7 @@ struct bio_slab {
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



