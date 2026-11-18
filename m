Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034029;
	b=VIdq9XFoDPglW+cwmTGhn3SBWIAtj6rKrqYi6U+UUbzOAeAHsuCNq4GbAZugfpI879eq
	 4iB710gXJjRs/pCZx3pdQjDrqF9ZS/AvIVZqH7qrzFnWu/gXp+hJ6CzXrkBHs4tl/RPjC
	 ku7N0oD9BPiLd2TfOJ29whb1XldzKFHqubzE7y+7noiGawA5mtcR2L3WpRD6sSmOt8v1a
	 HAAk7Y1SI8ymE4LVgpMSyaCCEK6EgCqAD3wDLVn1fMNxf3YK48KQHwYIIXFWiGe5sZive
	 tK9P9l1y292wkyb5Eowml1lonICzVVz65yVQgk/n3uzTYlV1O8ta6pqDZWM1WDTimyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LvdBUxROgUehECxjQNrFv0zt3I4H9M9WaT+ysuzualU=;
	b=cVX7GwMR04YaE+eg5swJ0dF5IdlkLVbVghSsagsFkxdmFnRHTzXHgSVlLO6KPEs3lvgx
	 esaQ4UygL4Hxq5m2Dvrz65SF4m3o3EZOVpm5HjjB0k19jUxTHJSVQ+l2HdWbqhNmb69p2
	 3SzBtTHJnNio8ptquFCDrl92M3P46novJZEfBrxnpXochc279i8q9dzyIl2QOoDWy36J9
	 MvC6haMPhsMvdjGM2DkobH/yOmC5gbPkhMgdz10n8OPfo1vlEPFpH1/W9jCn5HON8a8cB
	 O8mSB/m57lFNFaC4tP18gQ5sEgJxAaJW1h9/zxVY7ZD73ouuqiNnIPTZCRQcS1d0MWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X2AaMGb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871360A2607;
	Wed, 18 Nov 2026 20:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2AaMGb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5191F000C6;
	Wed, 18 Nov 2026 20:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034028;
	bh=LvdBUxROgUehECxjQNrFv0zt3I4H9M9WaT+ysuzualU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2AaMGb/4qVhZ+xX721TTyiO4w2ieIVwWd6TnSZH9a/kA8MmTYGwPimWWu4YxVUkr
	 UBjqa1oQ9pXtLF0Cr8ZPfbVVsLkL3az+1MLPwySPo8OPZ6yhqAVpr2UUHz4D1GUYop
	 DG5R/+jlCaES0qsbpMkADWHmgfKaXXR8Eh8RLmcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0224/3318] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Wed, 18 Nov 2026 15:14:06 +0100
Message-ID: <20261118150321.728691497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



