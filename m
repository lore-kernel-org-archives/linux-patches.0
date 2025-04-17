Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D2C1DEFEC;
	Thu, 17 Apr 2025 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916066; cv=none; b=U1cGEJNMT/qO6kQ5WlwEpimYOV3Vdhduuy5WuNIzOkEJkyra6rwxlpT9WPtabB/QJy7dPZ1HmuJ0gJ9t9FWy15FLfiouG1dm4vT84BMr/OLmdWAkP2+fGLL+8f1ADnZ/ycrin1EalnXV0hH0oAik96hZpZkIsWxKgV/jxlj88ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916066; c=relaxed/simple;
	bh=ewdJnLLN9/b4J2L03vMlJh4camPBFa/LDuo45oiUe0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMaj/eS5LNmNfoExpx3GGtDctrqgcwjjuGQT4eMuq4rkBz2YDThvWfLvalzokzhvH9KvdJSVOwivolg58cNuP/Gf+4KLeoAbMdkOmEx/UxicgtYPon0M1AGiya5qRjnawhR2VWC/fIfXxdJ9vfHJURckmy3qqqXbP0Zu1zLHk1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjBwFImn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjBwFImn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFF9C4CEE4;
	Thu, 17 Apr 2025 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916066;
	bh=ewdJnLLN9/b4J2L03vMlJh4camPBFa/LDuo45oiUe0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjBwFImnHjhnSkbBcLtdhojDH25ugKfZlti/zH/ZeU/mwG3kF8KG7q6YPSwsIzdB5
	 vpkoalbcc2RMtm4Htc43w9FWQc5cCpUitS5UYrqlI6qtecL3w2o939i4XpZPo7QrQg
	 qzvDopKKRPHBuTiVy6oUZJb5R/zL75U/M2QvAKCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 332/393] dm-integrity: set ti->error on memory allocation failure
Date: Thu, 17 Apr 2025 19:52:21 +0200
Message-ID: <20250417175120.959437239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 00204ae3d6712ee053353920e3ce2b00c35ef75b upstream.

The dm-integrity target didn't set the error string when memory
allocation failed. This patch fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -5081,16 +5081,19 @@ try_smaller_buffer:
 
 		ic->recalc_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->recalc_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->may_write_bitmap = dm_integrity_alloc_page_list(n_bitmap_pages);
 		if (!ic->may_write_bitmap) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}
 		ic->bbs = kvmalloc_array(ic->n_bitmap_blocks, sizeof(struct bitmap_block_status), GFP_KERNEL);
 		if (!ic->bbs) {
+			ti->error = "Could not allocate memory for bitmap";
 			r = -ENOMEM;
 			goto bad;
 		}


