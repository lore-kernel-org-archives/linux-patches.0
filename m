Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726AE79E3;
	Tue,  5 Dec 2023 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwlkFPg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FCCC433C8;
	Tue,  5 Dec 2023 03:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747968;
	bh=1tjJWqJ6o6y878x/aMxT5D48Ppx/eXn/bcK0rHziyRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwlkFPg7I6hjBNfJPOq4JW5uCmjDPcOSSQqcJQ5v5Fxsk6tWeFJwLPqDKv9r+P9Md
	 9t/0HgrruEzMTZM6hIxGZCBAu7Xs1z3EvvCUEsScACwLErL4it4YRNen2J/j3jClxl
	 Z5+1WtjlYo5KhV9W+yxPdSM1MrPzQBdUhna8Ew1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 64/94] btrfs: fix off-by-one when checking chunk map includes logical address
Date: Tue,  5 Dec 2023 12:17:32 +0900
Message-ID: <20231205031526.419847464@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 5fba5a571858ce2d787fdaf55814e42725bfa895 upstream.

At btrfs_get_chunk_map() we get the extent map for the chunk that contains
the given logical address stored in the 'logical' argument. Then we do
sanity checks to verify the extent map contains the logical address. One
of these checks verifies if the extent map covers a range with an end
offset behind the target logical address - however this check has an
off-by-one error since it will consider an extent map whose start offset
plus its length matches the target logical address as inclusive, while
the fact is that the last byte it covers is behind the target logical
address (by 1).

So fix this condition by using '<=' rather than '<' when comparing the
extent map's "start + length" against the target logical address.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3095,7 +3095,7 @@ struct extent_map *btrfs_get_chunk_map(s
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (em->start > logical || em->start + em->len < logical) {
+	if (em->start > logical || em->start + em->len <= logical) {
 		btrfs_crit(fs_info,
 			   "found a bad mapping, wanted %llu-%llu, found %llu-%llu",
 			   logical, length, em->start, em->start + em->len);


