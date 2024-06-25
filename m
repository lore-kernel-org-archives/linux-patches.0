Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599A412EBEA;
	Tue, 25 Jun 2024 09:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308680; cv=none; b=M1PWfnVcmPzy6H9TmVqXQw4ZYWM6ou0YILcMqa1HnSXVJpQcns47YAbFIHyQREYHHwspzjUg8H9PqWic7cA2YWVgtKpn3tMabO8xjC7pdItcogcsnXXSQp0dKzKywdnMflLV7FBUlEnsFZjZK3qyNz4IBU3ZhVFJAZk2ShYUndA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308680; c=relaxed/simple;
	bh=1RvfNkaUcjG4kMn+T77xx96XG2wEpXopz2RNORjaTPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqnIrNmsyRB6wJtEGByIa7z7SuOKAt94uk/DvdQC9d4DpLJb7zOmknkDMbawS6Y2D3xuROEj2VFnieJhmFmta+itw5oc83Pq510BfYE7Wl4yV5vvQBL7kKk4gRrakaH5XK5YaPYOoan5pt5xyUznCQWS5zECoGwOK1raODKzdu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPjmhaEs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPjmhaEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4CDC32781;
	Tue, 25 Jun 2024 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308680;
	bh=1RvfNkaUcjG4kMn+T77xx96XG2wEpXopz2RNORjaTPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPjmhaEssEf6SYULNfr3OBmtg5IaIBzhzSPyruyUfSoVZvPFf+vNgbeZHLoylk5l8
	 XmaTEF33hTadLvV0pTKzrxBJCZzOx3vP/VfzEDU55Y8v0gwmV8Lwq2TnlbYlp61lfs
	 I/K433klJ0R6qZ0YynjWrdxV1ZHiGtVG1YPVRCas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.9 196/250] RDMA/mlx5: Follow rb_key.ats when creating new mkeys
Date: Tue, 25 Jun 2024 11:32:34 +0200
Message-ID: <20240625085555.573466680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit f637040c3339a2ed8c12d65ad03f9552386e2fe7 upstream.

When a cache ent already exists but doesn't have any mkeys in it the cache
will automatically create a new one based on the specification in the
ent->rb_key.

ent->ats was missed when creating the new key and so ma_translation_mode
was not being set even though the ent requires it.

Cc: stable@vger.kernel.org
Fixes: 73d09b2fe833 ("RDMA/mlx5: Introduce mlx5r_cache_rb_key")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/7c5613458ecb89fbe5606b7aa4c8d990bdea5b9a.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -246,6 +246,7 @@ static void set_cache_mkc(struct mlx5_ca
 	MLX5_SET(mkc, mkc, access_mode_1_0, ent->rb_key.access_mode & 0x3);
 	MLX5_SET(mkc, mkc, access_mode_4_2,
 		(ent->rb_key.access_mode >> 2) & 0x7);
+	MLX5_SET(mkc, mkc, ma_translation_mode, !!ent->rb_key.ats);
 
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->rb_key.access_mode,


