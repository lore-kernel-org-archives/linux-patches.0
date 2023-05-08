Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27E168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74014C433D2;
	Mon,  8 May 2023 10:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540971;
	bh=KdLpnyrNEhTpxlhU8poV7vDK/M83oJ8Fs3tNqhKeymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlSyBToWlG/Uf4nANQmrlRi+mrbGzwAqXbruLD9+qUAXgZdXxjG3yH2WMLNwkwYT5
	 +GWYd+Hwh9P7rcXQ6eUvp3AMiGKAhTfuIdWH4vpo2u/8T4QQGVC/APRxpEX2Z6Hvw6
	 nvPUK0BJLC35lwHX+J+oXW9saRMmqCax8La6ACKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	John Hubbard <jhubbard@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 568/611] mm: do not reclaim private data from pinned page
Date: Mon,  8 May 2023 11:46:50 +0200
Message-Id: <20230508094440.415069547@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit d824ec2a154677f63c56cc71ffe4578274f6e32e upstream.

If the page is pinned, there's no point in trying to reclaim it.
Furthermore if the page is from the page cache we don't want to reclaim
fs-private data from the page because the pinning process may be writing
to the page at any time and reclaiming fs private info on a dirty page can
upset the filesystem (see link below).

Link: https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
Link: https://lkml.kernel.org/r/20230428124140.30166-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1887,6 +1887,16 @@ retry:
 			}
 		}
 
+		/*
+		 * Folio is unmapped now so it cannot be newly pinned anymore.
+		 * No point in trying to reclaim folio if it is pinned.
+		 * Furthermore we don't want to reclaim underlying fs metadata
+		 * if the folio is pinned and thus potentially modified by the
+		 * pinning process as that may upset the filesystem.
+		 */
+		if (folio_maybe_dma_pinned(folio))
+			goto activate_locked;
+
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			/*


