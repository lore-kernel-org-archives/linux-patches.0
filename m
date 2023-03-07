Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EDBBA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BA8C433EF;
	Tue,  7 Mar 2023 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211597;
	bh=7oRs06MOKabU/AB0P/fGhK/4WWAyhir/j7o4cOqjFSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ApfRunfJH/7mazk5vjnCzYViygiHsPTY68ANvHtROyeXov3jPcVmUMMoPefOCcKX
	 mnXT3ch173KHmj6Tb2jitL6CM9W8SLLpWsAJSyvCjfT+7TosSqQ6w9JxLBThDT9kjL
	 xrc1rawOROLRuCeEd9duaDolYxZTRHR+kw82THEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0914/1001] dm flakey: fix a bug with 32-bit highmem systems
Date: Tue,  7 Mar 2023 18:01:26 +0100
Message-Id: <20230307170101.710620548@linuxfoundation.org>
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

commit 8eb29c4fbf9661e6bd4dd86197a37ffe0ecc9d50 upstream.

The function page_address does not work with 32-bit systems with high
memory. Use bvec_kmap_local/kunmap_local instead.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -307,8 +307,9 @@ static void corrupt_bio_data(struct bio
 			struct page *page = bio_iter_page(bio, iter);
 			if (unlikely(page == ZERO_PAGE(0)))
 				break;
-			segment = (page_address(page) + bio_iter_offset(bio, iter));
+			segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,


