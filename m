Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8AB20297C;
	Wed, 19 Mar 2025 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395225; cv=none; b=cbTB7WKADpsCFhIwSq5FYydpQlHtLg5itr+ysJevZIihUbLqB338CWoZYpXj8PXGEZMNJ+Wkmi4rTJX7mKuYTgQwyXlUQIar0mb+RDx2VHcfE/dpppjy562tj6u5vNSu+RQ4oNcAzsUJBapbvms0yK8rBOFP3kLTBs2oq6FcYPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395225; c=relaxed/simple;
	bh=S2KJQiqp3CAQAovQK9GojJOLo+7BJLVqpfWIPMY+5+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6ileEMGKj8hbOAAzgM8ucG+SLS+z7Wa/oxRSqOMCqxKf/YyKqTxHuTyR5RXFxQlSPZeySNKTqaVCWjAlo/IX/AN3fzjEXveBl8scimqZKKfj3w7Md0xxqbFNbxzNlzsq/mqhclVm0+H7hRe2yNbuBrx1VSDdKK0qdLDKBDyHeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcB6/ZZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcB6/ZZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B49C4CEE4;
	Wed, 19 Mar 2025 14:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395224;
	bh=S2KJQiqp3CAQAovQK9GojJOLo+7BJLVqpfWIPMY+5+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcB6/ZZkcDkVogeN5dUTLWnRiIFmFrulf08415uGC7usWG1Vt5BSPmqPCxvaGb08J
	 4i5gGdnUl/i3OKNTygvw4LYTzZXO0B2tiVYS3YDo+OBUenj5dmPqO+Fm2JeGJ1DVO/
	 Tv+6ga7r7n/QDEyvxyND0xvy+e68snDem72GkTh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/166] block: fix kmem_cache of name bio-108 already exists
Date: Wed, 19 Mar 2025 07:31:04 -0700
Message-ID: <20250319143022.542266253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 62419aa09d731..4a8e761699571 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -78,7 +78,7 @@ struct bio_slab {
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



