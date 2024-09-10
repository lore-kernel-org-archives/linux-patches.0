Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84B2185B72;
	Tue, 10 Sep 2024 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962213; cv=none; b=GiOnfJ3maNBivYqMq5DmdGNQHTbc0K492KTp+geH2PCQgff8o1V7Q6bxxz7yr61dfiKW8xBJMs2iwGB31veUtmmZUQBYif5ND1rKcIrK44eqULCsPy5PBKIxl2ImizPATZraHjPc7u/ho8xtn4NhjOH7twtSeLCvpH5bp5GNSKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962213; c=relaxed/simple;
	bh=hsdlsLZAOewxtD4UjxyfSU+tGarNMhNmsznnFuDsIKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0jW9wPpy9SDfaumymyr87LRaNn3JVlb0eBd+gVQdHWNKH7dj4fFB+DSD65oi/reT+zbET0+glukrTThoRRG8whJ7PESijiqLurQivY8KC2olTRmC/bjY15wtjN6qIimQOxRuPL4O8RZT9qvPpZikwq72aSFHx/ltXeadPAWHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=recwoAmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="recwoAmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDC4C4CEC3;
	Tue, 10 Sep 2024 09:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962213;
	bh=hsdlsLZAOewxtD4UjxyfSU+tGarNMhNmsznnFuDsIKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=recwoAmHfcvyfo4OXs6CMqwnqGgM7O7kgdW6dbUzQfZdwB3Gajti1ejP5Qq7ygh4W
	 pf+ellgAYxglZkgk9oXIoaSNbZsiA7UKibO1o9+Beq2Ob05Auma8E8sejdQHhPMd6m
	 0gXbi/rEEaumW0QXgr4qMonTFoYCaZk50sOGMSyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 333/375] net/mlx5e: SHAMPO, Fix page leak
Date: Tue, 10 Sep 2024 11:32:10 +0200
Message-ID: <20240910092633.771465384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit f232de7cdb4b99adb2c7f2bc5e0b7e4e1292873b ]

When SHAMPO is used, a receive queue currently almost always leaks one
page on shutdown.

A page has MLX5E_SHAMPO_WQ_HEADER_PER_PAGE (8) headers. These headers
are tracked in the SHAMPO bitmap. Each page is released when the last
header index in the group is processed. During header allocation, there
can be leftovers from a page that will be used in a subsequent
allocation. This is normally fine, except for the following  scenario
(simplified a bit):

1) Allocate N new page fragments, showing only the relevant last 4
   fragments:

    0: new page
    1: new page
    2: new page
    3: new page
    4: page from previous allocation
    5: page from previous allocation
    6: page from previous allocation
    7: page from previous allocation

2) NAPI processes header indices 4-7 because they are the oldest
   allocated. Bit 7 will be set to 0.

3) Receive queue shutdown occurs. All the remaining bits are being
   iterated on to release the pages. But the page assigned to header
   indices 0-3 will not be freed due to what happened in step 2.

This patch fixes the issue by making sure that on allocation, header
fragments are always allocated in groups of
MLX5E_SHAMPO_WQ_HEADER_PER_PAGE so that there is never a partial page
left over between allocations.

A more appropriate fix would be a refactoring of
mlx5e_alloc_rx_hd_mpwqe() and mlx5e_build_shampo_hd_umr(). But this
refactoring is too big for net. It will be targeted for net-next.

Fixes: e839ac9a89cb ("net/mlx5e: SHAMPO, Simplify header page release in teardown")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20240815071611.2211873-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 2df96648e3f4..cbc45dc34a60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -727,6 +727,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	ksm_entries = bitmap_find_window(shampo->bitmap,
 					 shampo->hd_per_wqe,
 					 shampo->hd_per_wq, shampo->pi);
+	ksm_entries = ALIGN_DOWN(ksm_entries, MLX5E_SHAMPO_WQ_HEADER_PER_PAGE);
 	if (!ksm_entries)
 		return 0;
 
-- 
2.43.0



