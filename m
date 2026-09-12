Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB89932B108;
	Sat, 12 Sep 2026 15:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226478; cv=none; b=cL9fdWitNHOOAkIxjdzujM2JBd634VDQSraGDgSNtxXZsDpvngSTDFcIVpyO8PAgetav1dEJcAHI6sK/6bUJ9t2iWLueU+G3MTFKvo9A5C6JUSpLMnptPDtOoveNQlG5dxpqooz7peNMCDPr1sibo08aHe5UyalGUetwfQRCYNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226478; c=relaxed/simple;
	bh=IbmrfMcTjx1OZB3l0LrXdhjcH+W++JhhCEoqye4JQCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2O32Q1QIBJedpCHERxY7aETmul4Sj9jTItRn/C3FZS8Z7CW2LQlQBCtkH0YZYzHeKu7aYWUmkIRXyuGeLR1aquXsQwktGCTyA+HctgIN0wLcUXAtUw3WgNuK4C8xGTJwrOAWqJtBllhjn5JGZ1Y3GM/JzldAeJqmUcdAHN9qkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTVDS6Bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTVDS6Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF591F000FF;
	Sat, 12 Sep 2026 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226477;
	bh=0vEhhAUtKhyxwLXz9mTdDZZFh03qV62jirOCsGaz7qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTVDS6BkpMHqqB3YMFIWo8WitfQ8oavVVoZSY4iMEIuJ+bfylB/US9pBk0qYbQfbq
	 80Gmd/1rZx/uItyflxrjUgxPM6tFkQeUytcBJ690o5VGYl7iWTrWGtewR5xJHBsHGp
	 tFPj9kNEOtVq66PpJt/fvEyHH3zIeQtNbljcWGS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Kubanski <e.kubanski@partner.samsung.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1408/1424] xsk: Fix offset calculation in unaligned mode
Date: Sat, 12 Sep 2026 09:04:00 +0200
Message-ID: <20260912065638.791162311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: e.kubanski <e.kubanski@partner.samsung.com>

[ Upstream commit bf20af07909925ec0ae6cd4f3b7be0279dfa8768 ]

Bring back previous offset calculation behaviour
in AF_XDP unaligned umem mode.

In unaligned mode, upper 16 bits should contain
data offset, lower 48 bits should contain
only specific chunk location without offset.

Remove pool->headroom duplication into 48bit address.

Signed-off-by: Eryk Kubanski <e.kubanski@partner.samsung.com>
Fixes: bea14124bacb ("xsk: Get rid of xdp_buff_xsk::orig_addr")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://patch.msgid.link/20250416112925.7501-1-e.kubanski@partner.samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xsk_buff_pool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 1bddbf543dc00..d3a109a79a1d6 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -232,8 +232,8 @@ static inline u64 xp_get_handle(struct xdp_buff_xsk *xskb,
 		return orig_addr;
 
 	offset = xskb->xdp.data - xskb->xdp.data_hard_start;
-	orig_addr -= offset;
 	offset += pool->headroom;
+	orig_addr -= offset;
 	return orig_addr + (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
 }
 
-- 
2.53.0



