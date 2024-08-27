Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CE1C57A3;
	Tue, 27 Aug 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769746; cv=none; b=SGfu2BADM1pMp7fKHMTJETkIEl2sWQ5BkJSeZ6KFMWf0brd9luddwpigTVfbmHgWif1o+EU0rCiqCKN0dpNorN7xPp7XfNe0E4IhsbiOXXCUH+Bc3JCNvFPF1LsmZUy3I/2jKsI1dycu+cth7jVe9btwR+20RHazwfKcvskAZus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769746; c=relaxed/simple;
	bh=q+TLToX5p7k5y+eT3RxhaSqZZdwFjzhp9lVvAsucDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFLYyhk1i+O/mGVm00WCdqy4050mBQ2lT7y4FIhccC4ulXxm9Xr2rqGsg01dB8/XZfpaUq95Z7Lp1PAJfqcz60N9o1ON9cohf4AaDULCQrGhOPwy4wyjnVIiFz9ijO+Ip8Q4cbJANjsFBITU45jqamRb3hoSr8P6gRtmPooHTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVqVumwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVqVumwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E292CC61048;
	Tue, 27 Aug 2024 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769746;
	bh=q+TLToX5p7k5y+eT3RxhaSqZZdwFjzhp9lVvAsucDY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVqVumwthDhSWGc13rcBWjBHMZrV21jzY612UynmwOyRcCkykn+qNu8kIrzVn5KfL
	 9VqMWl25/tErPV9Fw5vbi4dtcuOHkj2l5zcSH0fRY0qDpN1RUW7HZGyxn755jhcW26
	 wthbxCCtJ4wTkLUzE5qVDfWkI19HtpDc4pGkZmzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.6 024/341] dm persistent data: fix memory allocation failure
Date: Tue, 27 Aug 2024 16:34:15 +0200
Message-ID: <20240827143844.327956791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -277,7 +277,7 @@ static void sm_metadata_destroy(struct d
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	kfree(smm);
+	kvfree(smm);
 }
 
 static int sm_metadata_get_nr_blocks(struct dm_space_map *sm, dm_block_t *count)
@@ -772,7 +772,7 @@ struct dm_space_map *dm_sm_metadata_init
 {
 	struct sm_metadata *smm;
 
-	smm = kmalloc(sizeof(*smm), GFP_KERNEL);
+	smm = kvmalloc(sizeof(*smm), GFP_KERNEL);
 	if (!smm)
 		return ERR_PTR(-ENOMEM);
 


