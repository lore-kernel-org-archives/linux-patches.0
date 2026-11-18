Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036691;
	b=NAf/cwd51gEi4v/lISzGbz7aMUvoujCnYMvoZ0JCLwIE3PnTid9HF0Ppf3SupCUHF5q6
	 tsaP1NMf6mMuf6MH4PAp3aw4HN6yQo1mRGins7+vqvSbE6fyzBXP54qSyQIu8mgpDqolF
	 toot15g8QkbqP4IvU6nn0xJ86VpQbE4iY6Q4dilPAJVZMuXFENRP8dhjwx4mg2r9WMzRN
	 YI0dcbjxW5+MQZzOiXKFp0QNWUMK4qLGmDt/PdimUPNkbDGrSjbvHkzIV8eh+d5MIXrxd
	 v92qHm2vLX/j8x8e328mSo2fKLh0QLqO/JFX5VK0vmftE4nzEZlocxa6mA0IpqCA1Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcM1B+V0vc2wrfzJ+Q41DxgEJ+hE6nOkM1q9DNnrTjI=;
	b=cr4ayfyn33yWoWE6iKy8rsgoYvg33mF2xMmOKZOcGS71sdDeRXHqXhHkqIT9ALERVKo0
	 fAtZD8lb8F65nukpEQrvxFzmV7KU/p53/Vj4XjSkOK/gnnYs41qFZroaQo8XhXs9OcxaL
	 Q+UV6tAh8DmCL/05d6Xrf6zpFKzJfCbFe5etQZCKwynAxnpgrhC0SJKzARYanmSj5LtX6
	 Hj4av0cBloVAgaDm4QNMT9ogi4DHNAg3QEl32psOw3kg+kKQbgu1U7vjwF+mAETAXDnFo
	 6GoDjvaAqkoBXkDfr06TBMkUruyo5A7EGKqGe4AklBBuvo5xlcjoK46t/DwGSiH/eHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLvhh1mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E89606A32C;
	Wed, 18 Nov 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLvhh1mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E91F000C5;
	Wed, 18 Nov 2026 21:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036691;
	bh=IcM1B+V0vc2wrfzJ+Q41DxgEJ+hE6nOkM1q9DNnrTjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLvhh1mjDL9Tx9VujoEqDOGnQ8O5R/aTQ7AlOE5dxSdf34suJBJviV2XRVa6GjF1r
	 6z4EU0H86xWYzhXUT+Ue5G3JfhSouyHBuuHdGKJNfMFDTBEv63HT0KJeTkunfjhHw3
	 GJK7L5jXXDREEa55TFXm7dNm1fFvhXfNp4kYIVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1148/3318] alpha: invalidate the local context in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:29:30 +0100
Message-ID: <20261118150354.523199352@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c0db730bf05eb3c10c1fae64b19f6913dce129fc ]

When the target mm is not the calling CPU's active_mm, flush_tlb_page()
does nothing locally, and smp_call_function() reaches only the other CPUs.
This CPU may still hold translations for the mm and can later reuse the
old ASN together with them.

Add the missing else branch. flush_tlb_other() clears mm->context[cpu] so
a fresh ASN is taken at the next switch. Add this before changing the
current->active_mm test to current->mm: that change will also send lazy
callers here, so their local invalidate must already be in place.

The uniprocessor implementations of flush_tlb_mm() and
flush_icache_user_page() in asm/tlbflush.h and asm/cacheflush.h already
contain exactly this branch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-5-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 5349c3127f9f4..9fa165df035dc 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -701,6 +701,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	data.vma = vma;
-- 
2.53.0



