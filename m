Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7082DA759;
	Mon, 17 Aug 2026 15:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980474; cv=none; b=PH1ap6pWpKdxwDOPpz8i0gOao6tJZc6ZTAQJzQessCbx52X/dNnExKT0jaldDq9e/854iE0iK3feeKYjWi28269w70jjhyPCbgOJVx+eqz2KvrQSuu8o94qqqewIUl3A0xjt5umi3nBWZdiYIOULlcoKapotvLRZmnnH1XeY9kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980474; c=relaxed/simple;
	bh=VfU2TKhpLzp32wykbrT2md//kJrPtnTfSMNjFMJMsHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsCpQ3w0CqZkBv2QqMTV4QfgEBu4fwAG66kq4H9kGeJdVh+bvvq3OGyyDUwonhoWMGSrnx6ky95o5G9nD+E0X0/hTmmh4PHup0cpVB8gQE8qZ2JfawOCl0EGhtp58H7rxf5BFexT6gcxWBnofFvnQMfC/VGi7IhMasj+YgYfYCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEFyGKqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEFyGKqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990A01F000E9;
	Mon, 17 Aug 2026 15:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980473;
	bh=k0S5noNCEuUdTkUE/fl9ccRcPx40fdANo5e7lt+dtiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEFyGKqZ2HAIAn3nM/3wcSSYGqSjMvaavDiybQRShthtCPjNg0FcjUUGNawpgAZ6p
	 YfzD/Z/pNB93NQPZXf1eHjH57LiOeI4GtH70RGjMbDjn/cTBJk/jNZ8sCx0gswxT7I
	 0cdSuK+FT8F1pH1oluVlye5+McbWo6hpUbaPYHtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 586/609] xdp: reject clones that overrun skb_shared_info tailroom
Date: Mon, 17 Aug 2026 15:34:42 +0200
Message-ID: <20260817132603.292887112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit e48e8edbef2eb824201495daa5234560f632b23c upstream.

xdpf_clone() clones broadcast copies into a single page and sets
frame_sz to PAGE_SIZE. __xdp_build_skb_from_frame() later treats that
page like a normal XDP frame and expects the usual skb_shared_info
tailroom at the end of the buffer.

The current check only rejects frames whose linear xdp_frame header,
headroom, and packet data exceed PAGE_SIZE. A source frame backed by a
larger allocation can still satisfy that check while extending into the
clone's required shared-info area. When such a clone is converted back
into an skb, build_skb_around() places skb_shared_info over live packet
bytes and later writes can corrupt XDP return metadata.

Reject clones unless their linear area fits inside
SKB_WITH_OVERHEAD(PAGE_SIZE), matching the tailroom requirement already
enforced by the XDP-to-skb conversion path.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/6b2afef5d1738763c6965e8e466eb16e43e4f956.1785757386.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/xdp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -688,7 +688,7 @@ struct xdp_frame *xdpf_clone(struct xdp_
 	headroom = xdpf->headroom + sizeof(*xdpf);
 	totalsize = headroom + xdpf->len;
 
-	if (unlikely(totalsize > PAGE_SIZE))
+	if (unlikely(totalsize > SKB_WITH_OVERHEAD(PAGE_SIZE)))
 		return NULL;
 	page = dev_alloc_page();
 	if (!page)


