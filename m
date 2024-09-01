Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D516B391;
	Sun,  1 Sep 2024 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209846; cv=none; b=UCX66IRpxF1E4fQYOzWuIDqASTfTeJaFveU1yOISbfmKXsin2iJKsmF2CdvnQdSYFiPLAPvv5ztuxqQ8SSgcyMOo8IVFRXEzuGN4nqvk70SVyCxG6aKDjf3eMj5SCbFXuA9Z7Ke3oz2xihtgXJYizAomsZqDJVV17G/NZedqfJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209846; c=relaxed/simple;
	bh=Rfo+7zofDUpKTX9lx3FhB6XPe2WGlEzfOM3LcccLrQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS/YrryEfgo0tbXOTVBRY2oeWIV1kGkE+9m1bSUkJZke0+lptw3vIoBaFJovdRr09gSMQ1bLnzItJnqMefDs3HLKE2IXAmOJnF/Gdx4mqS8ao3Lg0cK028IXMshMYdYIDltbF4aZNoUJMy9nsI1Qx+/HPGLSj4Zp8+YURHlIp8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIVU5Yqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIVU5Yqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42D3C4CEC3;
	Sun,  1 Sep 2024 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209846;
	bh=Rfo+7zofDUpKTX9lx3FhB6XPe2WGlEzfOM3LcccLrQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIVU5Yqc+TAINFwcDJmd/URJ6T0fHTzcIpE9GNct4uT3V0u2kNlZ8SVE66lZncq29
	 g0NiERKbIp9j9NjHQ3MxFdex8zd5Jq/1hAZa84qLii/CLpTEmum51VOug9ylv6uv34
	 akLCcLutxkywSW5QoxiT9RYih27grVLhVuXI6xjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 012/215] dm persistent data: fix memory allocation failure
Date: Sun,  1 Sep 2024 18:15:24 +0200
Message-ID: <20240901160823.712889002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -274,7 +274,7 @@ static void sm_metadata_destroy(struct d
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	kfree(smm);
+	kvfree(smm);
 }
 
 static int sm_metadata_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
@@ -768,7 +768,7 @@ struct dm_space_map *dm_sm_metadata_init
 {
 	struct sm_metadata *smm;
 
-	smm = kmalloc(sizeof(*smm), GFP_KERNEL);
+	smm = kvmalloc(sizeof(*smm), GFP_KERNEL);
 	if (!smm)
 		return ERR_PTR(-ENOMEM);
 


