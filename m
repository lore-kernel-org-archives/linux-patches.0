Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D518821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF908C433EF;
	Fri, 10 Mar 2023 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460602;
	bh=+IP/fh65Tid+QFwQ/E/Xk79ipBaq6faNhxoE/8VcMMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoserYCZ0l3YEDcSXjFFxpN80to/TIQgId2+jf8OstGQSPMaFqGcISPvLleEDbMY9
	 /jN5ZdIIUjT4XtdBtpPW9FGah14au9udpBlG9bPZFz17AEeiYnMFY7B2znHOjKHtYk
	 gi+Q7mCko+nPHTfaLX5x/S1Esraw+TFnYA0XiA3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 390/529] dm flakey: dont corrupt the zero page
Date: Fri, 10 Mar 2023 14:38:53 +0100
Message-Id: <20230310133823.078393582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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


