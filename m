Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6CB2DC783;
	Mon, 17 Aug 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977811; cv=none; b=uLcTuZHZkeEdOaB5iTx2VXZc6Qv+Sm5G8FWXFwwPpi/cUxspDCxygIyL0G/sX69w+cI4CEK96Tq4oCeu4j5pbvidPPJpC3D6VLFtthcagC48893R6mHprQKgZDABVvkYhj79/F+YDy68ovmGjFli1nJWPIMK9QAEwbdgPfDymWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977811; c=relaxed/simple;
	bh=/WxyKaPleIIZra5BGW1oZ5XxFvBlpgt7F5FWJZm/GUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+v8Gv2ag989JzFy4VcZ9W3Jp2UQAOKEL+/Zo20Jwp6qTG30AAObiDu9IoXTTPVrM/VDjylsc2sHcmfpuseLplW3K5f0Bijbqmy60dhLihDZ3OZKALIYMnrrFQK7p9848zJ6v11h7S/toM0vakAJ9H/MqXD5dqaDTFeVkvdYrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knwW4x+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knwW4x+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A161F00A3A;
	Mon, 17 Aug 2026 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977810;
	bh=GAYoRw9yGNyH7vUnD2ee3PPmpv1qFbyaDPOVF/1hsYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knwW4x+KyxWveUKIDRlQkURIQa0EGgG4TiqFQ8S+77xgMJz7bH/vB+Nrx5gt7x/PV
	 Stf+cmBYqo0fscJ2kow2zglWdN6DkdExm+RgMpcC1GaajnyiJWtgmDR+IYEMdXr9FF
	 rU1mMBByJoOZWPZUrzZ/eqN77O83RmvBhOztNqZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 441/456] xdp: reject clones that overrun skb_shared_info tailroom
Date: Mon, 17 Aug 2026 15:33:51 +0200
Message-ID: <20260817132556.342482171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -625,7 +625,7 @@ struct xdp_frame *xdpf_clone(struct xdp_
 	headroom = xdpf->headroom + sizeof(*xdpf);
 	totalsize = headroom + xdpf->len;
 
-	if (unlikely(totalsize > PAGE_SIZE))
+	if (unlikely(totalsize > SKB_WITH_OVERHEAD(PAGE_SIZE)))
 		return NULL;
 	page = dev_alloc_page();
 	if (!page)


