Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C065199A1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhB0HRot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A57DC433C7;
	Mon,  9 Oct 2023 13:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857310;
	bh=TnnRsfeTLgvnsVduAIKD3nY9sjzoePA7VuLCGbvzAnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhB0HRotgdbH0f954GhQGJ9TFIKsJx01mWrJ297V/PbTIQkNsheoav0LgfVRlAZ2g
	 VGFhp/mjy/ay6wIjkodowTRqrWHMGvrMrEiNyxjA40iXmITezMLRwwcb845ht1dWqZ
	 wbLanw3BTPfgW1O3/0t3xMJ41qOzi9F1xbqCWJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Srouji <edwards@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.5 153/163] RDMA/mlx5: Fix assigning access flags to cache mkeys
Date: Mon,  9 Oct 2023 15:01:57 +0200
Message-ID: <20231009130128.246135893@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

commit 4f14c6c0213e1def48f0f887d35f44095416c67d upstream.

After the change to use dynamic cache structure, new cache entries
can be added and the mkey allocation can no longer assume that all
mkeys created for the cache have access_flags equal to zero.

Example of a flow that exposes the issue:
A user registers MR with RO on a HCA that cannot UMR RO and the mkey is
created outside of the cache. When the user deregisters the MR, a new
cache entry is created to store mkeys with RO.

Later, the user registers 2 MRs with RO. The first MR is reused from the
new cache entry. When we try to get the second mkey from the cache we see
the entry is empty so we go to the MR cache mkey allocation flow which
would have allocated a mkey with no access flags, resulting the user getting
a MR without RO.

Fixes: dd1b913fb0d0 ("RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow")
Reviewed-by: Edward Srouji <edwards@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/8a802700b82def3ace3f77cd7a9ad9d734af87e7.1695203958.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -301,7 +301,8 @@ static int get_mkc_octo_size(unsigned in
 
 static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 {
-	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
+	set_mkc_access_pd_addr_fields(mkc, ent->rb_key.access_flags, 0,
+				      ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, ent->rb_key.access_mode & 0x3);


