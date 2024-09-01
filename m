Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB011183CAA;
	Sun,  1 Sep 2024 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208732; cv=none; b=UMgIy2OHsU+e3g6Iy0LuTW6pCy8d5CRJFi4XHcsAFwqbRPQabcKkrOxBE4/g2eLzgCEjFBWAVuqCHO2dRp2OzkuQ0LL0C+7oTKEF73ZIUOpSRdjBubD3s+wos8Q9kKRZQGeNuBuJqlv5gCC/z09KuT0LAsD6fuC1VH8OBKv6t9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208732; c=relaxed/simple;
	bh=N57xg8PsbbzGkHkGsa4FPoqC/25VhJ06J7Cmf0JubBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGTGEx193Ka+aa7GZCUKF0P3byn1GukMbdmFDuwf9KtVn5ZevcWlgpzcUXESaMHJsHVBBwHhOf2oM1D/k/EMqj1Ia2ha46r95eVaOo6vaUTp0sQVJD1GyyAxxB+LY8Jl4LRlZQaE3rOZnrsjVo6UgtiGmEIn/RYf0cNq8nV6iSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW4OB/Rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW4OB/Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025D0C4CEC3;
	Sun,  1 Sep 2024 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208732;
	bh=N57xg8PsbbzGkHkGsa4FPoqC/25VhJ06J7Cmf0JubBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pW4OB/RriS6jOdBQHSghy4rEiqC2g8kGEuPijmy0LHcKctxaBc7UG7rOS9bgVG+8A
	 AOql6xIV8rSJRHUw8YOYeEk2arfd9ROoKJ4QYdYb+/9lu1xloW+X8nlb8XvVvkD1vq
	 SLsHkylmJ3bIQJ4r9XQfeBEyO/U0rTGollvf6h1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 007/134] dm persistent data: fix memory allocation failure
Date: Sun,  1 Sep 2024 18:15:53 +0200
Message-ID: <20240901160810.384609661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit faada2174c08662ae98b439c69efe3e79382c538 upstream.

kmalloc is unreliable when allocating more than 8 pages of memory. It may
fail when there is plenty of free memory but the memory is fragmented.
Zdenek Kabelac observed such failure in his tests.

This commit changes kmalloc to kvmalloc - kvmalloc will fall back to
vmalloc if the large allocation fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-space-map-metadata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -275,7 +275,7 @@ static void sm_metadata_destroy(struct d
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	kfree(smm);
+	kvfree(smm);
 }
 
 static int sm_metadata_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
@@ -759,7 +759,7 @@ struct dm_space_map *dm_sm_metadata_init
 {
 	struct sm_metadata *smm;
 
-	smm = kmalloc(sizeof(*smm), GFP_KERNEL);
+	smm = kvmalloc(sizeof(*smm), GFP_KERNEL);
 	if (!smm)
 		return ERR_PTR(-ENOMEM);
 


