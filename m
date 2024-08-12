Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4147C186E38;
	Mon, 12 Aug 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480268; cv=none; b=LLzwBFE2nzM9r34euI3RHOPvyeEjoxbWQnVEdT1O2iQrgJwtutlZP4vW7GjzEWuQyyvc6W+Hugj9znVPwyX08qAWSWiW5Br1shobMCvSRAy2M4vSx3229xu98I2Uc/yMXrVofvw7QrTCO72lm4ehpNS7LqjyjTDIcN///gvWE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480268; c=relaxed/simple;
	bh=JdrSBIY3qROIfus+I8l2/8NLJ6y/RiLfkVb8bz6/des=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9ljTJUZQR0w37CIlqjuev1cMyKd82fgHr3CtIESfoEWFGQ5OY1F2pKT7bzqIcwTSl2v6QIWE1yXaxWs4AS0Mf0h1zuAPqoOqSnatKRjJwQ4HyKmfnbvgcUGNuL70tkXGp/TKWJfFurI+CLKbqevL/ph7/BvMgGEv8QVABbo100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZmkOrf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZmkOrf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B88FC4AF0C;
	Mon, 12 Aug 2024 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480268;
	bh=JdrSBIY3qROIfus+I8l2/8NLJ6y/RiLfkVb8bz6/des=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZmkOrf5fMWT5rkrZwsB0LPk67K36hjao3rZGfnWoJ0phCt2EFGBJn9bi4B5jor6C
	 kPwcTTY92otBSdU5r8pSmduWpqevNJBovUStN0jmT7fBuNe755RRoB0yGKopNT2mea
	 Kxu49i3LepO+m6qUx7omkMnv9yv/2T3mbioX2cmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	stable@kernel.org,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.10 118/263] mm, slub: do not call do_slab_free for kfence object
Date: Mon, 12 Aug 2024 18:01:59 +0200
Message-ID: <20240812160151.063794142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit a371d558e6f3aed977a8a7346350557de5d25190 upstream.

In 782f8906f805 the freeing of kfence objects was moved from deep
inside do_slab_free to the wrapper functions outside. This is a nice
change, but unfortunately it missed one spot in __kmem_cache_free_bulk.

This results in a crash like this:

BUG skbuff_head_cache (Tainted: G S  B       E     ): Padding overwritten. 0xffff88907fea0f00-0xffff88907fea0fff @offset=3840

slab_err (mm/slub.c:1129)
free_to_partial_list (mm/slub.c:? mm/slub.c:4036)
slab_pad_check (mm/slub.c:864 mm/slub.c:1290)
check_slab (mm/slub.c:?)
free_to_partial_list (mm/slub.c:3171 mm/slub.c:4036)
kmem_cache_alloc_bulk (mm/slub.c:? mm/slub.c:4495 mm/slub.c:4586 mm/slub.c:4635)
napi_build_skb (net/core/skbuff.c:348 net/core/skbuff.c:527 net/core/skbuff.c:549)

All the other callers to do_slab_free appear to be ok.

Add a kfence_free check in __kmem_cache_free_bulk to avoid the crash.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 782f8906f805 ("mm/slub: free KFENCE objects in slab_free_hook()")
Cc: stable@kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4655,6 +4655,9 @@ static void __kmem_cache_free_bulk(struc
 		if (!df.slab)
 			continue;
 
+		if (kfence_free(df.freelist))
+			continue;
+
 		do_slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt,
 			     _RET_IP_);
 	} while (likely(size));


