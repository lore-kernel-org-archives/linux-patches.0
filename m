Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEAFFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B878CC433D2;
	Mon, 15 May 2023 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169670;
	bh=39OMPwKxukUM8+toE+Dh0KWqVlSwRIn8ZbI8hqTZrJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFmhGhUq4TD4gJWcdrptE6WUXSpbAY/09ZoFjtpmY3aZVMbCdvSzaP5huNdoArqRX
	 LfNecORn9McffJqnIOJCuktSK2FPHxliDC66chPNczspDB8XWvdPcxKqJ7Gcg/azTN
	 u+vyI7NvcJHueCk71SabXUPKqriBtrJe8TKnG/Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 133/246] btrfs: zero the buffer before marking it dirty in btrfs_redirty_list_add
Date: Mon, 15 May 2023 18:25:45 +0200
Message-Id: <20230515161726.556906681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit c83b56d1dd87cf67492bb770c26d6f87aee70ed6 upstream.

btrfs_redirty_list_add zeroes the buffer data and sets the
EXTENT_BUFFER_NO_CHECK to make sure writeback is fine with a bogus
header.  But it does that after already marking the buffer dirty, which
means that writeback could already be looking at the buffer.

Switch the order of operations around so that the buffer is only marked
dirty when we're ready to write it.

Fixes: d3575156f662 ("btrfs: zoned: redirty released extent buffers")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1610,11 +1610,11 @@ void btrfs_redirty_list_add(struct btrfs
 	    !list_empty(&eb->release_list))
 		return;
 
+	memzero_extent_buffer(eb, 0, eb->len);
+	set_bit(EXTENT_BUFFER_NO_CHECK, &eb->bflags);
 	set_extent_buffer_dirty(eb);
 	set_extent_bits_nowait(&trans->dirty_pages, eb->start,
 			       eb->start + eb->len - 1, EXTENT_DIRTY);
-	memzero_extent_buffer(eb, 0, eb->len);
-	set_bit(EXTENT_BUFFER_NO_CHECK, &eb->bflags);
 
 	spin_lock(&trans->releasing_ebs_lock);
 	list_add_tail(&eb->release_list, &trans->releasing_ebs);


