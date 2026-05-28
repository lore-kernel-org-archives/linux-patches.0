Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A68B339866;
	Thu, 28 May 2026 20:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999146; cv=none; b=WiHzyS07qiYHkdZ5Bail43jQy+G5v50eWduBrvKRgnciA/ElfscjqCa96m5NKZkswfoByR2NNlRevSrNdNUhUg3LgwUZfgv7dORMcLgS11zluNg1a4D5OAIF4nT0JwBje7v6L07JHeaXz8NpfDjOh86Dkb/cqlRciIK8SzM8WLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999146; c=relaxed/simple;
	bh=ESUBg+qtbxupFynEyQs+ESklPPfRINUQ/8A2h/MHFvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9ENoZSWeQW39UEJjtSqWZGO98eM7RbxX88s20c1hL+UzkauYcbkGk1iUCaLCgZb/n6dvcbx7C0anTEw5qqT8Dmt2/FBNZ4y3HZQ7xLJKp1kRk3kPtaYNeeMofmJf62Hwf8dIBWnuCcBNze5nQ+Z0CI9crdBkMSGVMkb9mqLVNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibpYWWYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibpYWWYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BDC1F000E9;
	Thu, 28 May 2026 20:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999143;
	bh=8ZubNwYxAYlvEZpgPMfFUE5Qt6xW9yZwoM/f00VnNYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibpYWWYonkZ/dLLSp73+kwbUxxeaOV7zGarCagK6qiugfR0VAaqsFeRjOWqrMMwTl
	 DPO0QDzUO6nDFOD6HlWkTYqmUOg60kgp733/ftBzmi2buhRKMLyIVJcNdbenTuRW4T
	 zSJoHxF3oECUEOZXZkziSXPQg9QHdE7XBs0rEH+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 423/461] udp: Fix UDP length on last GSO_PARTIAL segment
Date: Thu, 28 May 2026 21:49:12 +0200
Message-ID: <20260528194659.749229024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 78effd896eee11ac9db9bcbb53e7bbcad96073d7 ]

Following the cited commit, __udp_gso_segment() writes single MSS length
in the UDP header.
The cited patch doesn't account for the fact that the last segment could
be a GSO skb by itself. This could happen when the size of the packet is
a multiple of MSS, hence the first segment is also the last one (there
is no need for a remainder skb).

When the post-loop segment is a GSO skb, assign the single MSS length in
the UDP header.

Fixes: b10b446ce7ad ("udp: gso: Use single MSS length in UDP header for GSO_PARTIAL")
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Closes: https://lore.kernel.org/all/6c3fb15e-711d-4b8d-b152-e03d9b05293f@linux.dev/
Tested-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260518062250.3019914-3-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e831234326c41..9714d40c5b6e9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -591,9 +591,12 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		uh = udp_hdr(seg);
 	}
 
-	/* last packet can be partial gso_size, account for that in checksum */
-	newlen = htons(skb_tail_pointer(seg) - skb_transport_header(seg) +
-		       seg->data_len);
+	/* Unless skb fits perfectly as GSO_PARTIAL, the trailing
+	 * segment may not be full MSS, account for that in the checksum
+	 */
+	if (!skb_is_gso(seg))
+		newlen = htons(skb_tail_pointer(seg) -
+			       skb_transport_header(seg) + seg->data_len);
 	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
 
 	uh->len = newlen;
-- 
2.53.0



