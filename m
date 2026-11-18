Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054152;
	b=hHi2knqum/fnKZ5SZZf0nA3R8bCIun3PJU/aShH950ZZxL/f2QCjx5gvTDox8of6gzle
	 NUPEka87sN2F29bxWyh81EfKT+MF4HL/7DoYCTwT/khrwh3/9J5XbGD+jOhOup5mAehH+
	 C0lvw8Mu3Heg/dOBIbNAj5cJjgd70tUJ5jkzVASY2QQ6ZY36iL7f4lg66wyR6fSMZGR5e
	 k8rJYVttLrRvL6rCnUS6ufbxrpMlGEqJj/wRCMXtAMb5SNWD8i0RfQKVwR54NxIcsQJMs
	 c0ISy78f6StjY70ACBvBkpFJK+D7hQSfXN45WnixXJ/Bk9dM/S1W5KRUOdHWXnulIyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oApHkBg7IN1TrN1jxYlBUXczJYQjySBrILZlXTBFEjw=;
	b=yV0+gZSfQehqIhj5Mh36G0l3L0DPTo8D/cVuzcgJINKIzUGD1WOhplFwka7jvWMd9OUq
	 AnBq8C25hvRct80CfhlB5Gf1s1tjfTRbikVeprq41MTqOu4MS/JA48Ih5qwgSWhzcvLac
	 LNnYcUZzVCQoDNwqYnh6YXgs9kzPun3uFJQ9yQXKulfKEioRNh/9Egj2cbQhjqH4GCWV9
	 9ucI0cI279DUrxWEaqa1UsdEGFhryebbulN2jm2AQGKYmj23Qf8aE0pJpLtauoNntQwFO
	 h281eKy5S7e5CvmkKiLv7nvn6jDfs4T6WKZh8L5nk6tfW8NnbRWiL8mOwTXMRPZPERA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKDSyNoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8332606A325;
	Thu, 19 Nov 2026 02:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKDSyNoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DD31F000C6;
	Thu, 19 Nov 2026 02:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054152;
	bh=oApHkBg7IN1TrN1jxYlBUXczJYQjySBrILZlXTBFEjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKDSyNoWWzvA5f6TBSIoIgOh3deIpa5vc7G5MyWCsCq5Um/vjl+JCWyaagxdsayVU
	 qr53NYZ7AbUamcFVGs3iTD4r/yzjbiIqqNav/WlTrBVKOe5k08yjiLokG3L9q+k9WJ
	 4K2wS8id7oyCHt36OADOaNyCJ8j6Pm6xi7j7RF98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1174/2214] mm/ksm: keep soft-dirty when merging a page
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150058.940700070@linuxfoundation.org>
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

From: Samarth Narang <samarth.colleges@gmail.com>

[ Upstream commit 2efc6332f18bfd848f74f3d5ba45b31450601faa ]

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost.  A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and a
soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Link: https://lore.kernel.org/20261021182157.1873726-1-samarth.colleges@gmail.com
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context because flush_cache_page() uses *ptep instead of ptep_get(ptep) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3ed1bd6085f91..26d9beca82095 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1163,6 +1163,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



