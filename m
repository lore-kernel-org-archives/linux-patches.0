Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3949443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CBAC433C7;
	Sun, 13 Aug 2023 21:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962300;
	bh=ZRFQgl5AGUt5ob7cXqP9NJEfx27b9+Euvd1vHoKuvBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtEtuTSg1fhPyg1NbvzPFCoEFtbFyFoBxk+Nu7B5RW8W33EYDpElw7auTEB1Wc6CW
	 g9/DxOzkui7wUPTiTKEA9FQ1PFUtY4P62DbrXrkx78t3tOa7SUKkkUw8DWVYNvt2bh
	 1cCSYG9zh27C025EuVsj8cfSYEYIRKUiJxYaT6eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 184/206] btrfs: dont wait for writeback on clean pages in extent_write_cache_pages
Date: Sun, 13 Aug 2023 23:19:14 +0200
Message-ID: <20230813211730.290217641@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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

commit 5c25699871112853f231e52d51c576d5c759a020 upstream.

__extent_writepage could have started on more pages than the one it was
called for.  This happens regularly for zoned file systems, and in theory
could happen for compressed I/O if the worker thread was executed very
quickly. For such pages extent_write_cache_pages waits for writeback
to complete before moving on to the next page, which is highly inefficient
as it blocks the flusher thread.

Port over the PageDirty check that was added to write_cache_pages in
commit 515f4a037fb ("mm: write_cache_pages optimise page cleaning") to
fix this.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2345,6 +2345,12 @@ retry:
 				continue;
 			}
 
+			if (!folio_test_dirty(folio)) {
+				/* Someone wrote it for us. */
+				folio_unlock(folio);
+				continue;
+			}
+
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (folio_test_writeback(folio))
 					submit_write_bio(bio_ctrl, 0);


