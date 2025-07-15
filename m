Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23852E424E;
	Tue, 15 Jul 2025 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587219; cv=none; b=OJvs4laL4SHoKJF7NJOrTvNdG6F1gUSznLPtLyLCFjGcDvwCTVjQZMDyGR0HmErKrJFheoruxqXC+Kp6nAyP2J33yA9waOaixk68ESZsQVcyBtCOUtdUinm+8F05MI1/FjnXkueCol1l+i8FqTlrSmrXITNUxtWRXglUTOvVpak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587219; c=relaxed/simple;
	bh=BJc2oKrBiFyExis0PhbWzGfELvL9FaE4Dwc+SbOUSVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9TOsF8AJh3FEGRCZP/Ecp3mLL67QvVZQUFMj5xiXateWSIzTO0WgYg8hXS0P6c0uDGWhEGbjTNd7zgVE5joSxfAulF/MXV6QqKw1JRh9FugcyVeCBHhFnVGx5jCPwy225nNjNiNNxLssy6puonOn2NtuwE9WER0UlvTBNNLDWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLl6aM+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLl6aM+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA06C4CEE3;
	Tue, 15 Jul 2025 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587218;
	bh=BJc2oKrBiFyExis0PhbWzGfELvL9FaE4Dwc+SbOUSVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLl6aM+NStAhRmZMCMSdbvHSDk/wCMhmsvv8LjLshQSmQo7F1z8Irc80M6jSXsy3/
	 9K/GYKnAVeFlc73zfs38RGpkmI2ugjohjYzs9R7q2HmhBokVmcAiMiWPHwsTd/46mj
	 J0EGJaqPhnCmiYZjAWhk09Qv5xDIoqkwdCFcet+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Hailong Liu <hailong.liu@oppo.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"zhangpeng.00@bytedance.com" <zhangpeng.00@bytedance.com>,
	Steve Kang <Steve.Kang@unisoc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 19/88] maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()
Date: Tue, 15 Jul 2025 15:13:55 +0200
Message-ID: <20250715130755.283873893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit fba46a5d83ca8decb338722fb4899026d8d9ead2 upstream.

Temporarily clear the preallocation flag when explicitly requesting
allocations.  Pre-existing allocations are already counted against the
request through mas_node_count_gfp(), but the allocations will not happen
if the MA_STATE_PREALLOC flag is set.  This flag is meant to avoid
re-allocating in bulk allocation mode, and to detect issues with
preallocation calculations.

The MA_STATE_PREALLOC flag should also always be set on zero allocations
so that detection of underflow allocations will print a WARN_ON() during
consumption.

User visible effect of this flaw is a WARN_ON() followed by a null pointer
dereference when subsequent requests for larger number of nodes is
ignored, such as the vma merge retry in mmap_region() caused by drivers
altering the vma flags (which happens in v6.6, at least)

Link: https://lkml.kernel.org/r/20250616184521.3382795-3-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reported-by: Hailong Liu <hailong.liu@oppo.com>
Link: https://lore.kernel.org/all/1652f7eb-a51b-4fee-8058-c73af63bacd1@oppo.com/
Link: https://lore.kernel.org/all/20250428184058.1416274-1-Liam.Howlett@oracle.com/
Link: https://lore.kernel.org/all/20250429014754.1479118-1-Liam.Howlett@oracle.com/
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: zhangpeng.00@bytedance.com <zhangpeng.00@bytedance.com>
Cc: Steve Kang <Steve.Kang@unisoc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5802,10 +5802,12 @@ int mas_preallocate(struct ma_state *mas
 {
 	int ret;
 
+	mas->mas_flags &= ~MA_STATE_PREALLOC;
 	mas_node_count_gfp(mas, 1 + mas_mt_height(mas) * 3, gfp);
-	mas->mas_flags |= MA_STATE_PREALLOC;
-	if (likely(!mas_is_err(mas)))
+	if (likely(!mas_is_err(mas))) {
+		mas->mas_flags |= MA_STATE_PREALLOC;
 		return 0;
+	}
 
 	mas_set_alloc_req(mas, 0);
 	ret = xa_err(mas->node);


