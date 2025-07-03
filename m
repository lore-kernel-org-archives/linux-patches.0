Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560EC2EF9AB;
	Thu,  3 Jul 2025 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554286; cv=none; b=eBv2RYOEI6diidZ5SoEjbDYeEMG85GNj7HVOPv0KRkeM6QwJTqTgxIPSGC1AF6tRFuviQGXbmBERcRI6yw2xoa367R5ql1d28bekpTDdzHuL6EhrC+92Lbfw+83t6fGivaf2AD/x5WZetimAplGdpab6gZuOp7w7QDCx5R3Be3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554286; c=relaxed/simple;
	bh=cavueHo695vvV5Lbw9p+prlZUEa2xlI/BiQ2VGLDFnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhzkJWA+0tleKgAADxHO6fVFmsknSX0H9aPtP/I6YXezFSHfswIcFgTbG+obmz23WMz+6NL9FkzRbxlMUTtYDPdgmEQ1O2Dqf7kFxfnJwmE5x70vSNRJuJ0bCO3btPudVPtYa0/CdYV1AMiB/9qtlh5NSZAAK72YbjvXykXC64g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reiFu03U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reiFu03U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D60C4CEE3;
	Thu,  3 Jul 2025 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554286;
	bh=cavueHo695vvV5Lbw9p+prlZUEa2xlI/BiQ2VGLDFnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reiFu03UY/L2JRRNClr3JHqCsBZPp7Quv9pV5kCU7teW3JxQYbcFKn1bfrN02ep0A
	 chaJmBMuz9szWSCVNa5beyOtoIvVFrezcsovZy5MWG+O8L53MDVjJl0QY3sStpQf/I
	 htM+JvMAIZ6rMeQZqHBpihXyP2gvHzUm57Nq94LE=
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
Subject: [PATCH 6.12 139/218] maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()
Date: Thu,  3 Jul 2025 16:41:27 +0200
Message-ID: <20250703144001.687154991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5542,8 +5542,9 @@ int mas_preallocate(struct ma_state *mas
 	mas_wr_store_type(&wr_mas);
 	request = mas_prealloc_calc(mas, entry);
 	if (!request)
-		return ret;
+		goto set_flag;
 
+	mas->mas_flags &= ~MA_STATE_PREALLOC;
 	mas_node_count_gfp(mas, request, gfp);
 	if (mas_is_err(mas)) {
 		mas_set_alloc_req(mas, 0);
@@ -5553,6 +5554,7 @@ int mas_preallocate(struct ma_state *mas
 		return ret;
 	}
 
+set_flag:
 	mas->mas_flags |= MA_STATE_PREALLOC;
 	return ret;
 }


