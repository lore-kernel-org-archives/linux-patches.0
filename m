Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0F6881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED99C4339C;
	Fri, 10 Mar 2023 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459217;
	bh=+IP/fh65Tid+QFwQ/E/Xk79ipBaq6faNhxoE/8VcMMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wn+Pud2875cb/la+pZ+1ONP5hXzLv3Wh/LLjTYWarFq+2ohptXgNSKEyduxMNKOlw
	 QVjIm5HU7WO22+KJn335EHR5LeZKHA/vFl8hpgJeJws6lLyGjE3cmj7Z5ZIooiG30Z
	 P7BDvFo74sMWoSY3wW8DX4oU3hI5JSxqUX/nY65E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 256/357] dm flakey: dont corrupt the zero page
Date: Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133746.055739732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

commit f50714b57aecb6b3dc81d578e295f86d9c73f078 upstream.

When we need to zero some range on a block device, the function
__blkdev_issue_zero_pages submits a write bio with the bio vector pointing
to the zero page. If we use dm-flakey with corrupt bio writes option, it
will corrupt the content of the zero page which results in crashes of
various userspace programs. Glibc assumes that memory returned by mmap is
zeroed and it uses it for calloc implementation; if the newly mapped
memory is not zeroed, calloc will return non-zeroed memory.

Fix this bug by testing if the page is equal to ZERO_PAGE(0) and
avoiding the corruption in this case.

Cc: stable@vger.kernel.org
Fixes: a00f5276e266 ("dm flakey: Properly corrupt multi-page bios.")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -301,8 +301,11 @@ static void corrupt_bio_data(struct bio
 	 */
 	bio_for_each_segment(bvec, bio, iter) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
-			char *segment = (page_address(bio_iter_page(bio, iter))
-					 + bio_iter_offset(bio, iter));
+			char *segment;
+			struct page *page = bio_iter_page(bio, iter);
+			if (unlikely(page == ZERO_PAGE(0)))
+				break;
+			segment = (page_address(page) + bio_iter_offset(bio, iter));
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",


