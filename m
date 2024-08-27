Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E341CC889;
	Tue, 27 Aug 2024 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771032; cv=none; b=T/KWEu0Wv8em+OPnU/KPTXFU/Bm9UHtYq4iFzP9MBOaEpCW4lOfsmhusQGfBtTZcgk6HXcWgLYimwEUBHPpGlBtMMsAp/2E2hK5bWCqy5WQOHtd9Ml962Hs4ob9yd10dmXc+nuXtTYFAnwU+FAvyywGWtiSgdV4VrQ7WXbWis6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771032; c=relaxed/simple;
	bh=buQOto4HuRrTvmXxNu6xR8GD0yECdJyikGL4adkQr8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+Jj7j27koXMpw/zYokZV6rdBJXOVV5am1IPXS+0AMAU2Xzhbdv9Fk+Jy/1dL5fgpbfybcxhiOyxCjUv/ffja/eYq2bVAZt2eBPQByanpwVbwGBs790LbzBFmgVeEufaQfh1KG+xAvn7bw+ZTQ64gXFIUkzIU0qTfXg4TYD5eWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK7f2zKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK7f2zKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25F9C6104C;
	Tue, 27 Aug 2024 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771032;
	bh=buQOto4HuRrTvmXxNu6xR8GD0yECdJyikGL4adkQr8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK7f2zKa+WntB9TlytU2uH8ykW7zr9Lyo+k1yKgF4PNUsrjeVxPH99wruJ1/wjWfY
	 ALlIHuNwOjuXpG5ScXOdy1iHtdxiHUcyOFqXThaEIMBs74YH4EyjkZcAkERELG0Y7Y
	 Wp9OvAGtoOcOxL1fO7D6P7FMixyDcWyYqrR5TRds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.10 035/273] dm persistent data: fix memory allocation failure
Date: Tue, 27 Aug 2024 16:35:59 +0200
Message-ID: <20240827143834.731952145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
 


