Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87641E9B3D;
	Thu,  3 Jul 2025 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555279; cv=none; b=B40DfgspaehrT+MxrWSuoAdHgy3mJ/hht0rjSqhbER5fcIUmzivyUpjx+uqivZgitWrQj86pNhsNRORwTlnP+LsfhuR0MthN0EZugLobYTGfE9XvWAyVcGd3LeHuejWPMBJDaDeo2om6EIGhVsjfA2IS7+E+cFNNMxdWdKRY3P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555279; c=relaxed/simple;
	bh=2LptzDQN6BKVKngLBmvrJoAYc6hkJ6aPrvqvTPIVpkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N52Nl5TdSQF1/Eqp1IWfvEuzp9tx5C89r2Zu8A+PAOwejUsrP3JPfN5rP9yPHjyKsl6RXrhiWFKjY5Ggo/BeBC7KLsAx0mAZgpZOjr2JnhJ+cZ83eTtWnjNwqRScJ/lhgHzo+ycTbbLNJQbEa+u/rJVgVoJEd7eci7pYCRGlbbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6E8TquS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6E8TquS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AA8C4CEE3;
	Thu,  3 Jul 2025 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555279;
	bh=2LptzDQN6BKVKngLBmvrJoAYc6hkJ6aPrvqvTPIVpkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6E8TquS1JbqIP9JPvKGyvA/0XSBgwZzNPWs6aHMGgN+IulW9bo0LwErqZ5Ca/CW9
	 iLecEr4MekN8CaTDWHMM/opYu+QsqM/nYuGeNC23eFHOK/hTAd0ptlv3TJDYQv90l+
	 izg7v7roo7MKUgpvNMQLodCxZXXk8dYdKIUw61Z4=
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
Subject: [PATCH 6.15 188/263] maple_tree: fix MA_STATE_PREALLOC flag in mas_preallocate()
Date: Thu,  3 Jul 2025 16:41:48 +0200
Message-ID: <20250703144011.881857680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5496,8 +5496,9 @@ int mas_preallocate(struct ma_state *mas
 	mas->store_type = mas_wr_store_type(&wr_mas);
 	request = mas_prealloc_calc(mas, entry);
 	if (!request)
-		return ret;
+		goto set_flag;
 
+	mas->mas_flags &= ~MA_STATE_PREALLOC;
 	mas_node_count_gfp(mas, request, gfp);
 	if (mas_is_err(mas)) {
 		mas_set_alloc_req(mas, 0);
@@ -5507,6 +5508,7 @@ int mas_preallocate(struct ma_state *mas
 		return ret;
 	}
 
+set_flag:
 	mas->mas_flags |= MA_STATE_PREALLOC;
 	return ret;
 }


