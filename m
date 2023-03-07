Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E634DBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C4AC433EF;
	Tue,  7 Mar 2023 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211594;
	bh=LUkVtC5AYQvxaTmeuTp8hV33VpT8kS1fvNgHTpvjK90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyfkcNlOaVLJLnHfJY/I4Xg6keajAoItIxN3TuuIhKHN7N59e3Ig8PYtE5tL0XTMZ
	 afseN7uHleuyWlj9Ht3mi+JkbqKWbJi2/2oWOfhRuikNN0QM/jZxXS7oSSUrRk0+Zg
	 Z5fqgtTN/N2lBzLbGNWKW9kB18OOP6NzNTNL8TZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0913/1001] dm flakey: dont corrupt the zero page
Date: Tue,  7 Mar 2023 18:01:25 +0100
Message-Id: <20230307170101.661950037@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -303,8 +303,11 @@ static void corrupt_bio_data(struct bio
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


