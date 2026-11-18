Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051385;
	b=RTUkJFTjtTDk7SO9RWgsiZaMYOg0qiIyzgWh8pMgoH3r/pHduu5u+Lfo12VMmNDLD37f
	 HY7fdFhaAGEhzQXUE9EjfYVdUYiFKhHU7nOLvEskDC+1w5lku+sWcfuihoc9YwqBXudnO
	 Gf17nMq5S+FjA4E0znmUjETUNeDLj+Wch8zco/rvpO4rSYV4+wN/EYCAKJDMR0ayrySZE
	 5QQQlSsT80Nd9zNGzQPROGAk1hnpeeqcW/69uqwO1Qt61BhWHCtnGKDMNNpZc90fYgZu6
	 btcJBf88FnYioiC8cBxOwGB+AQJeL7he2HQLNszBlI1V5oGa7jFU4/7YjWgIsw6KxLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UNxutNeF13t7MvJFMbMyZ5cr4INmme5qRdJa171nw3U=;
	b=38DzaI4EMDh4/KYg2H2sUyhAf/6XCkBpYUxNwMSVkWzSW00oEKQWp7Qo2sO84hne59L0
	 1JoQeAP7gT19Blay/TC2joknVFx4vbATLlWfLYjJO8wfbdHx8Ftczs9Ho+jHTpWfw7zhG
	 vClhNsHPhzty4IgIki4hEKd91NQRhWHW3s8x5a3MuOU+RbwgvrsQHAlBqwg4d4ZXqAuDh
	 DOCAPrHj10Jd9CKZLjWzpSL2PyjDnlDuZGFVdm434E0BY7S9cNjQXr+1SCS/KQC6TqnTf
	 5Vh0NZytEz4J19YPWilDKziQx2/Ui8LrTgAf1hprNVy4bmz1ddkfUeAUQF5TN+EJdCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjOcEC8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FCA60A260E;
	Thu, 19 Nov 2026 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjOcEC8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646201F000C4;
	Thu, 19 Nov 2026 01:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051384;
	bh=UNxutNeF13t7MvJFMbMyZ5cr4INmme5qRdJa171nw3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjOcEC8RUduSIvZl7drJFpdnKenDUqZhGoGdd1twx5YGONUN3+zcBs32vzBvDjERL
	 kTtkYF4dQ+Vyw5zP8tsiDdFYhN9elqAdDOe5o75hXxGddIXR81i4pxEIPIVK484IfQ
	 H5gtQxwxJh+6JXJ3Go5rhO9roT60QsVrukyqkUYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0172/2214] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Wed, 18 Nov 2026 15:30:48 +0100
Message-ID: <20261118150016.957288653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit a507023e6ff1d0b4e7aac49b2f547fed0c21ea4e ]

The pages backing an RDS memory region are pinned in __rds_rdma_map()
with rds_pin_pages(), which uses pin_user_pages_fast(): each page's
refcount is biased by GUP_PIN_COUNTING_BIAS to account the pin.  The
scatterlist is then handed to the IB transport, and the transport
releases the pages in __rds_ib_teardown_mr() with

	set_page_dirty(page);
	put_page(page);

put_page() drops a single reference instead of removing the pin bias,
so every MR teardown permanently strands the remaining references and
the pages are never freed - a userspace-triggerable memory leak of up
to RDS_MAX_MSG_SIZE per RDS_GET_MR/RDS_GET_MR_FOR_DEST call.

The conversion to the pin API updated the unpin sites in rdma.c but
missed this one on the transport side.  Release the pages with
unpin_user_pages_dirty_lock(), which removes the pin bias and also
dirties the page under the folio lock, closing the truncation race
that a bare set_page_dirty() leaves open.

Dirtying under the folio lock can sleep, which is safe in every path
that reaches __rds_ib_teardown_mr(): the registration-reuse path
(rds_ib_map_frmr()) runs in syscall context, and the pool flush
(rds_ib_unreg_frmr()) runs under pool->flush_lock, a mutex, and
already sleeps in rds_ib_post_inv().  The WARN_ON that guarded the
old irq-context set_page_dirty() case is dropped along with it.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260730041629.3512480-5-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_rdma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 468fd60d818ff..feff3e9190c46 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -255,9 +255,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 
 			/* FIXME we need a way to tell a r/w MR
 			 * from a r/o MR */
-			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
-			put_page(page);
+			unpin_user_pages_dirty_lock(&page, 1, true);
 		}
 		kfree(ibmr->sg);
 
-- 
2.53.0



