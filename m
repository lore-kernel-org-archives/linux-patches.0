Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CF81A76A5;
	Tue, 30 Jul 2024 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360669; cv=none; b=cR+AIYa458Pgw2glwErQfMqvfm6+8t9UBey3gObZz9tFcVcJIcLIWd0TgwUUIL4zouNrOnmGgHxM/TN/czouts6758fAq+LHn0GxSt8b9OQeaHA8+uNdCKwDP4jOqEWJtaaNeLXCPyK+ruK1u1FUDQAvXd29X/4cgfkgs0EKgYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360669; c=relaxed/simple;
	bh=J7MiNfM1XSk96nPWYJiJ9otbX7Mx/AQg8Kjd/c29etk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZzcEHVCqd6qS+KCmTbRI50HGhrD5hwJku81AYlPcVemC+K2jYUWenTpsjI6Nc70leMZcjHcnQ1RQo+syjrlvgZ0nri8ZSplLks3sfGwPymsOBMAHA7B9EvWlmCdm6phSg0J9ILIRmgi0o4cNsk8xkazjQ+Dmeu3b5AclFLGUmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz1Qku14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz1Qku14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68210C4AF0A;
	Tue, 30 Jul 2024 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360668;
	bh=J7MiNfM1XSk96nPWYJiJ9otbX7Mx/AQg8Kjd/c29etk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qz1Qku148UbQc++z7riYDZojyNRdD0zK7fjcqQKeoGCygafrqebb4VimKueN+ZDyh
	 cFHj3qTY8Vb/mncLo38lG548F+YYjcUvjKrdlqWDXRn6S16BRXrT7+P2+Mo19m1YC4
	 GgtKiUfWCWfXRAJpVRCHDBrJUKhLoOWxKoSCX+m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Li <dracodingfly@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 771/809] bpf: Fix a segment issue when downgrading gso_size
Date: Tue, 30 Jul 2024 17:50:47 +0200
Message-ID: <20240730151755.420447258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Fred Li <dracodingfly@gmail.com>

[ Upstream commit fa5ef655615a01533035c6139248c5b33aa27028 ]

Linearize the skb when downgrading gso_size because it may trigger a
BUG_ON() later when the skb is segmented as described in [1,2].

Fixes: 2be7e212d5419 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Fred Li <dracodingfly@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/all/20240626065555.35460-2-dracodingfly@gmail.com [1]
Link: https://lore.kernel.org/all/668d5cf1ec330_1c18c32947@willemb.c.googlers.com.notmuch [2]
Link: https://lore.kernel.org/bpf/20240719024653.77006-1-dracodingfly@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9933851c685e7..110692c1dd95a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3544,13 +3544,20 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* Due to header grow, MSS needs to be downgraded. */
-		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			skb_decrease_gso_size(shinfo, len_diff);
-
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= gso_type;
 		shinfo->gso_segs = 0;
+
+		/* Due to header growth, MSS needs to be downgraded.
+		 * There is a BUG_ON() when segmenting the frag_list with
+		 * head_frag true, so linearize the skb after downgrading
+		 * the MSS.
+		 */
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO)) {
+			skb_decrease_gso_size(shinfo, len_diff);
+			if (shinfo->frag_list)
+				return skb_linearize(skb);
+		}
 	}
 
 	return 0;
-- 
2.43.0



