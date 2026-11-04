Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829752;
	b=cyIEewi7gqAyWNYLb9unOeJ4zLGLl5sjbYShj/kDUtd8UH8ypytZQFW1A5zxSn90sIut
	 jzbgZqa0LeTWuCvzCX6wUNl83sZ5WJI2B21ZdTMXhYRch9qETqngoazA7Q3w4ure3rLBX
	 8gwV37NaNifadwDPieuL29AHDvtsrPyyXUyeC/uSzx2/m2wB1CLc13qZ5wnVfaXxQa272
	 Fb9JtI4cF1qLPYkXaXE3Nut7lkxhLuNuJMMsuncgpIOX20xUtH9XpH5xKkT463NijkP5g
	 B2KEGvsd7OxWibw5gVmiGvsOP90BLWjRpGQiZnF2wxtLXeerMRsyoo7lqJ+B0zLmnkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SgUTcBh1rplxe11xj9x+fBpEUugKkajGmCYPAe3y15A=;
	b=T/2fhmjweRwpMwyJYrwtG6XmV+xhFUBS/cbsxjnMSRaPLYLDe71B06taXvEKvkaIBSyE
	 aTLgY93zuNaashGMMVeQ46A7pjbLhqpOG1L0rkZAY+G0d+8pFDIJPb500pwbL4a6Ja50j
	 jRq9It3uGYgkiTcAOKO+ab7KnSoaikpMun4Me7SCdOQ8ABwxVTRteS5c8O8gGoqw8v1Ce
	 +ts0FrUe7NFlKVQMccL2g6mMKPnjuh+hgMtC3dEEeRrLnxhPbL68pgRoRNiuFe6S6gRby
	 SqmWaS2BOtxjD4iIMW91pXIvbG1nVvDfD90GzXMl1zuJMQOJCt2gOqQB1WhNi0JXmyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRczBNEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCF9606C922;
	Wed,  4 Nov 2026 22:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oRczBNEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2878F1F0093A;
	Wed,  4 Nov 2026 22:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829752;
	bh=SgUTcBh1rplxe11xj9x+fBpEUugKkajGmCYPAe3y15A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRczBNEFxZwE3KiUARH6lx/a0FFAZm3jOIGGaFVNKqxUXHnPTz2dD/ghmyErNAqTv
	 DpNOBiFon/3bDGcFR0eHCjiPzMPxkjlSFJGGlKeNdHDFqRYPZOznSeoZNM7wvWQNUl
	 OtxMRV0jGN4VtcLES5EgkUvu/BvLukvvDQyWprLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0321/1005] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Wed,  4 Nov 2026 16:00:54 -0500
Message-ID: <20261104211052.934003421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 751755cd069e0..36fd8dedbce56 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -251,9 +251,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 
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



