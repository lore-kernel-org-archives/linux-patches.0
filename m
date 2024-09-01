Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E416EB4B;
	Sun,  1 Sep 2024 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207613; cv=none; b=c4Y8fto53p6RAhL1X/kJOwvl7wJrvK4uu35u/DHzgWV4WSokbsDjN/yDPBElFClgK96Kg+AnlHaLTnE8VRc36/TW+9Oordw/6zybCdtd8LXxErFctsdY3uhDvI2a8dYf9kTkJt2iHIw3OSfoytvFMcij6976GhLm+bh++flKkNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207613; c=relaxed/simple;
	bh=1jC4XXVdnI/WRes3P1RJv+dZ9UTw4MAw3+dPmA9wOHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLGgQ8QzX2Ula2YXAaKtuDz/cOWWC5sHVyuafCcSYeInEm51lVnLmAXEOljEXmYrd/kjQSHoDzlcDh1Nkguq2jIwfBaB/3QtnNnUsTZpecEzMf7n3IYnbccpeDMf261hvYsu+KP6owCz+05Xb0ZgvdXIlQiSth485sPjkkwM3Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwC/fw6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwC/fw6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75855C4CEC3;
	Sun,  1 Sep 2024 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207612;
	bh=1jC4XXVdnI/WRes3P1RJv+dZ9UTw4MAw3+dPmA9wOHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwC/fw6HK24XtFJuuR+ipPrMHVqX/T5lBAlbIHbfY8fuHxI5QCXtYUo9BSVVjO7l2
	 PbMHBj6/KS03KtKEndsRtOCKY5IRCGqxb4WRKyjta6pfH9FPkmsBjS/D8CACkwgDcw
	 gyKchJvGZ9ErusLuuMrL69D1vZijACqF0n5CGM6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.19 06/98] dm persistent data: fix memory allocation failure
Date: Sun,  1 Sep 2024 18:15:36 +0200
Message-ID: <20240901160803.923635371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 


