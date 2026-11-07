Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060889;
	b=bVZDJaW+yx+E7JbmMDg6oBnU5W0CAYOdXMDT/VPG2AErguv6ejWrcqTzbIapnby30a5n
	 kapCCfijD3C4klk6q9bdqiZIcUTbPAzMQMzKzeibZK7VcvnPeyKwpUsjCYZMjCbd5Dm6c
	 Kdg1CKpxmwIU1fgr4Vi0PXWujAdCXVSigCA75lPvAFEcQIh1Mso2tc0ZNrvAD2WEId8sE
	 rDk6CTDKTEBGczVqRTZq8PlzN22mk5gpseQZCqFEYNJ7I+7vyH9fyBrwe/M94gH8z16Au
	 RiTZngEJk/FmsffjAilgwQrLXiTOjL9H7H1QNh4iuAZIeJ/dWwEg5VuLStzNzLoJ09w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6sWb2bxgSoefGmDl/bAIVd878y17AiUUvnyR526XS54=;
	b=5ctsF8bwFrB+Syysta4ZEm4hEYGx3kfj8oWY5QSXhFcTiwxxn4QO2bGATR1C4RJ9ZdWO
	 sqZHECbojKHtp4i49b/8zQZSYr8D07zphTri9AApZBeO57FxZMgq/Y3Ze8E8gStgfwCpz
	 2E17Q7f6Es89q1f1hrgvAN7IbCt9klQllB16caArfjwSWr8zcZzMnDYzd0P/6GLri4n70
	 E5vHQeI2St75AMOuQDQMxZ6KpDFEgzZ2O7ejNEueHHXzfSDy6oNPGECsXiSz9hQ6qZeCV
	 r5hf9Z+whpQPK6v9MAJMCsp6DuOBe/ptrQmVeNHzWaeMgPkPDgK8WLWlMM2k2XG4wPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Te2u6CJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83C5606A336;
	Sat,  7 Nov 2026 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Te2u6CJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636221F0089F;
	Sat,  7 Nov 2026 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060888;
	bh=6sWb2bxgSoefGmDl/bAIVd878y17AiUUvnyR526XS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te2u6CJDjpJvWtfBLj/qmjJjmevpPdoRE6f4RXA0aeE55VV3TcjcqOftR/pviKPs5
	 UKnP4cry33sUJNGMh8UerNLKtSMOcg/QlgBNBFk6Zusi5X5o/Hr7Cr71mnjZ1RaqQo
	 7+pXt3f5vuSVHpmz1St2HcQN9Xc57wg0ik6f16p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0266/1536] net/rds: unpin MR pages with unpin_user_pages_dirty_lock()
Date: Sat,  7 Nov 2026 08:38:02 -0500
Message-ID: <20261107135005.153905787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



