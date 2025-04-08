Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814D626773A;
	Tue,  8 Apr 2025 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109875; cv=none; b=rC7J81+kk+OVr1IsQzknTizRlN9G2TsHge/0y22lA+UhqklbI/ZfnMSCIueNQmP+zCzOmlpIhU8Q7sqCwb1PEUeDrcWEDnAzD+O22p8YzPpZ6TUnRdEKqXTNf3UHebFVAEplGhvGeM+y10qnD4zfOJkTPlw5YJbmwoNhetkQ+qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109875; c=relaxed/simple;
	bh=5sFWeDxAsa5vI1stIb5T501yDYGhf6eviZz9tGO04XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjOe2UQpG1E0pDJgf/FJ9up5gbuvnfSH6ms/Wg3Xp5Ze8IPdpKoT3gSEXZWixpziAN9OcO2wfI/d7qgmn6NjNEEQ01i2kTD39NhSoIv3A7yT5ogd22TzmsZ+Zpf5U2K0KltSu0yFJy8fLimsfzkd0/Fkkh4UAGAGGWZq6PABMUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv/boYTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv/boYTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12384C4CEE5;
	Tue,  8 Apr 2025 10:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109875;
	bh=5sFWeDxAsa5vI1stIb5T501yDYGhf6eviZz9tGO04XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iv/boYTSF2EUkVom9y22bKe3kqRI+9HMbl6iswpGn9aY7dhgyuUbmqOOe8mSxg1B1
	 8WaoQKSQAV9cXypM2UmPl230BQ6uHeQY3tN9q+H+kKTFEa9up2jj9OEJBgvai4/x4+
	 4tiI2/nxnGq5ruOmfzFyVIV5d8FyGzQ2ckAEKDns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/227] block: fix kmem_cache of name bio-108 already exists
Date: Tue,  8 Apr 2025 12:47:04 +0200
Message-ID: <20250408104821.783288860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f7a1aa9ea225..88a09c31095fb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -55,7 +55,7 @@ struct bio_slab {
 	struct kmem_cache *slab;
 	unsigned int slab_ref;
 	unsigned int slab_size;
-	char name[8];
+	char name[12];
 };
 static DEFINE_MUTEX(bio_slab_lock);
 static struct bio_slab *bio_slabs;
-- 
2.39.5



