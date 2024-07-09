Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CFB158211;
	Tue,  9 Jul 2024 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523681; cv=none; b=aRs/LlXRWKSk3cgTP8D4nMdNANb2SISRGhwTK+AVutGLQaETAuuyWSlerv7uDf6vH76UrZS+z4R0agaBXUX5tq+slxdeHbUlTas4KmycU0xyvosd0bQ+3ha0gGTgLJLGN3WdWbjExSmPBB5+BUNdRDli5iDfJivN9QnZoadRCao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523681; c=relaxed/simple;
	bh=sZD69hqf1v5MJyJ/SH6XClvkv+Z4AeLVrNKw6NS5A+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKo3naOQwkpaSg/hSYmqh4IRv6NPljMnuyB20M1LGJpC2RQwfjGBWCVr0Ui8H6YV4oYYKbToLPhTrmeb5Swf/oaPyzZpeyjnz0UoE1vODMjQMnrU+7K3FF8ojp5hklNDYSkD//9RZnz5nqkoEY4yfKsciBdPpzg+A/0ci9X3JcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ods5VWy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ods5VWy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15160C3277B;
	Tue,  9 Jul 2024 11:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523681;
	bh=sZD69hqf1v5MJyJ/SH6XClvkv+Z4AeLVrNKw6NS5A+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ods5VWy0bX7h8eFh1hI8P3X4J0ms7N9AAqi3Q0sE4oLstJk3em/GfKTmjMIa6z+qW
	 ea9ajli+IHoFMnk/HEeylkWFeoE/LajIJDR4Ev3k94lh82wqLdwmXQyEG0tBYDZPpQ
	 07P4Pkemgijy/jGdH3KKl+HIL3D3qgap0qVefLgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/139] net: allow skb_datagram_iter to be called from any context
Date: Tue,  9 Jul 2024 13:09:34 +0200
Message-ID: <20240709110701.036309731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit d2d30a376d9cc94c6fb730c58b3e5b7426ecb6de ]

We only use the mapping in a single context, so kmap_local is sufficient
and cheaper. Make sure to use skb_frag_foreach_page as skb frags may
contain compound pages and we need to map page by page.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202406161539.b5ff7b20-oliver.sang@intel.com
Fixes: 950fcaecd5cc ("datagram: consolidate datagram copy to iter helpers")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://patch.msgid.link/20240626100008.831849-1-sagi@grimberg.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/datagram.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 176eb58347461..e49aaf2d48b80 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -434,15 +434,22 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 		end = start + skb_frag_size(frag);
 		if ((copy = end - offset) > 0) {
-			struct page *page = skb_frag_page(frag);
-			u8 *vaddr = kmap(page);
+			u32 p_off, p_len, copied;
+			struct page *p;
+			u8 *vaddr;
 
 			if (copy > len)
 				copy = len;
-			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
-					vaddr + skb_frag_off(frag) + offset - start,
-					copy, data, to);
-			kunmap(page);
+
+			skb_frag_foreach_page(frag,
+					      skb_frag_off(frag) + offset - start,
+					      copy, p, p_off, p_len, copied) {
+				vaddr = kmap_local_page(p);
+				n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+					vaddr + p_off, p_len, data, to);
+				kunmap_local(vaddr);
+			}
+
 			offset += n;
 			if (n != copy)
 				goto short_copy;
-- 
2.43.0



