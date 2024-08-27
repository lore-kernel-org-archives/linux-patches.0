Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCF1A072D;
	Tue, 27 Aug 2024 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771764; cv=none; b=ix9asvV8c1ac4TTuwfSVqyjyuz+zJtepVJv+m0LGTbN0NYugHKCesHtybqpkad9CDH4aGbsgEPPwrMf3gW5Mhzd1R3AwVMAZODLnthR6n9EWjGWzGfqKvE6FyaxMhg+idTn2LXIqdMJIZOBR1EHwuTZmHgkYUnDVv9uFgQKvOb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771764; c=relaxed/simple;
	bh=Pjn8o+Ur0ApsaxwYv65gcxXpC8V77oJnWc3m9wiEEC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLQpKX84Qv9TrPfJ/Wd8rtrIy8wD9X0Li2EuHCgqiYeO1P0ls34rnbp0BeXRNk6E8L46x1GQomiosj2sna3P1LvqTNKZb4Ma4Lzj3C5UowuOQfFgGjo99hQMnfC97olb7woVkjehUooMerrLscpnNG16/FUes1dLFjsbuXHyXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrNdR/Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrNdR/Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29938C4DE0F;
	Tue, 27 Aug 2024 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771764;
	bh=Pjn8o+Ur0ApsaxwYv65gcxXpC8V77oJnWc3m9wiEEC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrNdR/GnjKzVhV5Bo9mxqXnigr+IlUh8eyO4jbs6YTDnbb1QWGX2WiK5dyvQEYcb6
	 TD9t3hlY/Xnuz+LcDH6kqkTZ4d5honGxeveXRkk8NitLQW6g7wIk0b35EybpNfmQKP
	 2daZ0J65jwq2voPqWEIBLPrVp6vAkBPIdz1zWDRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 014/321] dm persistent data: fix memory allocation failure
Date: Tue, 27 Aug 2024 16:35:22 +0200
Message-ID: <20240827143838.749040282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


