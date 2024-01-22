Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2111E374F5;
	Tue, 23 Jan 2024 00:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971129; cv=none; b=dQOeCsaep04RTIKmp6Ad6LOWhoIrV4kmG8IqGGIIOcwm4XkChKM7ft5kjZay9pEdZXaTHOkRAt+FGsCyeWGQPehS7iLrzMZmIvfvRlzE+cd9iz/iGJ+3C4MEYMjVTqRcQbtbCFLzjNQrFPR/8CrEkX6Ib4JP7W2k7K3B2lsEqqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971129; c=relaxed/simple;
	bh=VCggQD51muS2qoURjRY8Z/H2u4m0W3yepUV2DiaOqS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asuglQhvX9/ozMKz+Cw4C51QAKSJrhuiq54pstETAaeO2LhtfjdL0yS1eUS8BiYXlwZEitYpjuNeBwfWdOaRVxZrgrOdZT6qoxj//0bnnccgXphehKp5Yc5earRIvO51h3ctIzdlFu7rDjbZkIYy1Z/GWzj4W5MVXc5T+30EwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08aLFlmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08aLFlmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A8C43399;
	Tue, 23 Jan 2024 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971128;
	bh=VCggQD51muS2qoURjRY8Z/H2u4m0W3yepUV2DiaOqS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08aLFlmP2qtGh+2LBu+I7LDhgf71GyqV+KERRC1WiNZ4AXfxVFRmfNIm6v6Nm+dcP
	 sFXQbwHXPjSmqlcZnYfM/KpqMswYplqmqdvvZHD/lwLTcWR0gE7GTr+xPrsAijPOrq
	 +tfkJoGiXkTFCLiVfTKcorXy6LBE58sdNDbt5CaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/286] Revert "gfs2: Dont reject a supposedly full bitmap if we have blocks reserved"
Date: Mon, 22 Jan 2024 15:56:40 -0800
Message-ID: <20240122235735.680772695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2fdc2fa21bc72ec06c0c9f0e30b88fe1f2486b75 ]

This reverts commit e79e0e1428188b24c3b57309ffa54a33c4ae40c4.

It turns out that we're only setting the GBF_FULL flag of a bitmap if we've
been scanning from the beginning of the bitmap until the end and we haven't
found a single free block, and we're not skipping reservations in that process,
either.  This means that in gfs2_rbm_find, we can always skip bitmaps with the
GBF_FULL flag set.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 8877243beafa ("gfs2: Fix kernel NULL pointer dereference in gfs2_rgrp_dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c5bde789a16d..e05c01d5b9e6 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1717,8 +1717,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
 
 	while(1) {
 		bi = rbm_bi(rbm);
-		if ((ip == NULL || !gfs2_rs_active(&ip->i_res)) &&
-		    test_bit(GBF_FULL, &bi->bi_flags) &&
+		if (test_bit(GBF_FULL, &bi->bi_flags) &&
 		    (state == GFS2_BLKST_FREE))
 			goto next_bitmap;
 
-- 
2.43.0



