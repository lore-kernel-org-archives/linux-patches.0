Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590335;
	b=SJh1zd6+EF0QzaGm8g8F5P7YD3gCSrfz1iTJwuri+0dLndIudmR4UYiJcn/OwjTDxCb2
	 n9PJl7daFAHr+SZVEgFxuWmXk+GzYE1YibKlvBT4b0fcwLdHkQ8eN4CJZbWb0KgaaEVSW
	 +fuzqAM5pUysupLa+R9LQw4VNziuXt06Kc+Xwhrj+KTaBidurfrQjRRFDHQKhhhkNMFVe
	 JUzvpCigXqPmIOyjXyTqCAnfatblYW0Bvmdrhl+b8SrFc7K2L6Pj/kQFEVAz+hY4iONDP
	 mno5MLvYCV3YGYm1Xbz7ia4uko2uP5SF8rD2tMilEL1CFxolXQZ8OSsgu5gMWkDZ6JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8X4sgyaBnfhhY6C4h75wh1Mmqgv/+jUMH4J4JUvozTA=;
	b=T9AUYxhflTsgGj3RnHpgaMliO5/b21vOyEO4LTDpawPKbcYZEYvoe8uEmKnP46oy1ttC
	 vRuXYSmEBRjYPv1gzXdqOZk4TO8MB1nDEYWHpjq4igW0T9zzn8s0NqidGDg4qWS/U8MEv
	 hpbrxp/GBwrKqtshunVKJQ5BgIyESgUCEjgeSik0lgjgJSmiMClUZ8kV0cXwNPyuFHce/
	 i92A86ocdTLXhYvXXL9yTTTb3SU4w4t/Z9SfQm3cikBLjUgqq+42RebtRGqcSzpIq7kYs
	 S0KySmilqNtUap15HjhA5B5Z/U79Z2/aQFPR8KMuqfwkA4HPKBbOrKKJZvGyejTjWoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWZb4yxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD84A606D872;
	Fri, 13 Nov 2026 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWZb4yxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409A91F000C4;
	Fri, 13 Nov 2026 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590335;
	bh=8X4sgyaBnfhhY6C4h75wh1Mmqgv/+jUMH4J4JUvozTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWZb4yxLzF97DOTWcAEj1LIGRXI9pB1ZdY2RXYgj5cR72DUg9MusWYNBt6gF+Hckb
	 54lxubHLW2FzmGDroUohlprjplRDmKjb3nB9dRIMHqziPRdnrSxmjFtWTT1F965K0e
	 ZlRS+y7+7GQbccBXFXGXg3TDo9S8KMsEkEwvC2tg=
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
Subject: [PATCH 6.18 313/686] mm/ksm: keep soft-dirty when merging a page
Date: Fri, 13 Nov 2026 10:47:26 -0500
Message-ID: <20261113153831.548594289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 80274ace8155e..1eee363fd727e 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1414,6 +1414,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



