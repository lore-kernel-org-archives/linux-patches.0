Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897B6AA0;
	Tue,  5 Dec 2023 03:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtuFlOmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D9C433C7;
	Tue,  5 Dec 2023 03:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746556;
	bh=wceJK5lDJsavwpUzH5ow/HxbNbwbckFhO3oRTrjByqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtuFlOmZQTjFTgwt9qNMkOx4A0dqJXLXlanDcOBcT46JiAMqm8+0CxCfu0zqwGlGo
	 VROgNp+Thtxpmjebbc0ipVVIfM/NiLBJ0WwEw4R6vwKK/8mQ25R58gff+3MjIFd9vY
	 N11h6Ucne21tSTny+M3HZm9hgRnSmmKUerkJ3MmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 069/134] btrfs: free the allocated memory if btrfs_alloc_page_array() fails
Date: Tue,  5 Dec 2023 12:15:41 +0900
Message-ID: <20231205031539.903813767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 94dbf7c0871f7ae6349ba4b0341ce8f5f98a071d upstream.

[BUG]
If btrfs_alloc_page_array() fail to allocate all pages but part of the
slots, then the partially allocated pages would be leaked in function
btrfs_submit_compressed_read().

[CAUSE]
As explicitly stated, if btrfs_alloc_page_array() returned -ENOMEM,
caller is responsible to free the partially allocated pages.

For the existing call sites, most of them are fine:

- btrfs_raid_bio::stripe_pages
  Handled by free_raid_bio().

- extent_buffer::pages[]
  Handled btrfs_release_extent_buffer_pages().

- scrub_stripe::pages[]
  Handled by release_scrub_stripe().

But there is one exception in btrfs_submit_compressed_read(), if
btrfs_alloc_page_array() failed, we didn't cleanup the array and freed
the array pointer directly.

Initially there is still the error handling in commit dd137dd1f2d7
("btrfs: factor out allocating an array of pages"), but later in commit
544fe4a903ce ("btrfs: embed a btrfs_bio into struct compressed_bio"),
the error handling is removed, leading to the possible memory leak.

[FIX]
This patch would add back the error handling first, then to prevent such
situation from happening again, also
Make btrfs_alloc_page_array() to free the allocated pages as a extra
safety net, then we don't need to add the error handling to
btrfs_submit_compressed_read().

Fixes: 544fe4a903ce ("btrfs: embed a btrfs_bio into struct compressed_bio")
CC: stable@vger.kernel.org # 6.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -675,8 +675,8 @@ static void end_bio_extent_readpage(stru
  * 		the array will be skipped
  *
  * Return: 0        if all pages were able to be allocated;
- *         -ENOMEM  otherwise, and the caller is responsible for freeing all
- *                  non-null page pointers in the array.
+ *         -ENOMEM  otherwise, the partially allocated pages would be freed and
+ *                  the array slots zeroed
  */
 int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array)
 {
@@ -695,8 +695,13 @@ int btrfs_alloc_page_array(unsigned int
 		 * though alloc_pages_bulk_array() falls back to alloc_page()
 		 * if  it could not bulk-allocate. So we must be out of memory.
 		 */
-		if (allocated == last)
+		if (allocated == last) {
+			for (int i = 0; i < allocated; i++) {
+				__free_page(page_array[i]);
+				page_array[i] = NULL;
+			}
 			return -ENOMEM;
+		}
 
 		memalloc_retry_wait(GFP_NOFS);
 	}


