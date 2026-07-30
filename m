Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD2421EF8;
	Thu, 30 Jul 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423493; cv=none; b=M6rvAW3hg6J3MefiioihmU2Z8UeQsqMmiIOItN8+1cYfFw4+rTqA4sIxHsfMrURIlboxBKWvGVMgrNzMQivuNmB9gt9RiVTy6jyUi0xzdX0cA61UvoqwIiHzy6+vy+Ejwz/9QKDkX9ktzFnkbJWFQzcZOnprrCqgPWTZANW/T+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423493; c=relaxed/simple;
	bh=YtXzBDGW+QXL1K9SMeZKOBVZv/muUQoLauSKzTbwTzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9jmLtde7xf7NxWJz20HoEsIe5hiEQO/QEwr6NOTh6hpjmeHgZXzk7YiyORwQ9ihxlM4DGhgG+zhnq7UPeRizaDcjUasN19udqJlLRjj+NikQmFzdxbMll/xV62lxpmEPt+p2JMpSiAsUVsAH85yt5aFHO1FrQST82AF+20Y3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip4q1LIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip4q1LIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB8E1F000E9;
	Thu, 30 Jul 2026 14:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423492;
	bh=UAiUK1gDE/4xl2L70pq5yo5simJ4CWlzHj3qGUuiH+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip4q1LIJXm4Q3mXWY2En+Yfuz5psltFpqJ4mFjNgw0Icj6dBCNYQE9oSBaeDBshIc
	 EjS36X0zpj1Cwz5S054eV2wySOcJh28a18OkizTi5+mjotsRofXBnqFUAH6PWiVfdw
	 QIjPqsa43F8kT2ZasqH4FsvKGC7e0aVcmQiJIu0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen YanJun <moomichen@tencent.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/675] xfrm: iptfs: propagate SKBFL_SHARED_FRAG in iptfs_skb_add_frags()
Date: Thu, 30 Jul 2026 16:06:32 +0200
Message-ID: <20260730141446.438872022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen YanJun <moomichen@tencent.com>

[ Upstream commit 430ea57d6daf765e88f90046afbfd1e071cb7200 ]

When iptfs_skb_add_frags() copies frag references from the source
frag walk into a new SKB, it increments the page reference count via
__skb_frag_ref() but does not propagate SKBFL_SHARED_FRAG to the
destination SKB's skb_shinfo->flags.

If the source SKB carries shared frags (e.g. from a page-pool backed
receive path), the new inner SKB will appear to ESP as having privately
owned frags.  A subsequent esp_input() call for a nested transport-mode
SA then takes the no-COW fast path and decrypts in place, writing over
pages that are still referenced by the outer IPTFS SKB.  This causes
kernel-visible memory corruption and can trigger a panic.

All other frag-transfer helpers in the kernel (skb_try_coalesce,
skb_gro_receive, __pskb_copy_fclone, skb_shift, skb_segment) correctly
propagate SKBFL_SHARED_FRAG; align iptfs_skb_add_frags() with this
convention by setting the flag inside the loop immediately after
__skb_frag_ref() and nr_frags++, so every exit path that attaches a frag
unconditionally propagates SKBFL_SHARED_FRAG.

Fixes: 5f2b6a909574 ("xfrm: iptfs: add skb-fragment sharing code")
Signed-off-by: Chen YanJun <moomichen@tencent.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index fe8e4f21b32819..d39253b06c4efd 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -480,6 +480,7 @@ static int iptfs_skb_add_frags(struct sk_buff *skb,
 		}
 		__skb_frag_ref(tofrag);
 		shinfo->nr_frags++;
+		shinfo->flags |= SKBFL_SHARED_FRAG;
 
 		/* see if we are done */
 		fraglen = tofrag->len;
-- 
2.53.0



