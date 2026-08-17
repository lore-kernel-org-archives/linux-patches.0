Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B543F09A;
	Mon, 17 Aug 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978804; cv=none; b=iLxT/Um9HvSIsHHetPylVb6NgK7ObxVSTn6oNqx63woc3qFiusOTnWZnu7KWkomPGGFjhdSxNCjxHSV+Ia2VFNufwsTdR4KasMFoEBuFEDliSPXcYOtXqtkc/JHGZ7f2gnhTddZWjyX3hppm1fHbz0TPm7+BY8Su0ggDDrV01zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978804; c=relaxed/simple;
	bh=fiHfghn+0BzlzfRjyupMxe6EN8GljyoCV5eXUZGmJf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPDEGNclt+P3nPu6jSw0b+IT+YlCpM/If8rFKE+O99lpHdlsY86n2t75zh4uX1ZWXnn/jYe/6WUc5TJl2geDpN6O1dCgXpWGtivVLXVQdpGIZzQT9Mu8GqsPGIpYJwjdt/KR1wkN5+ckDPM9k/FUcineqeW0cf4aDkgq1SGCsoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWXma/NS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWXma/NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF461F000E9;
	Mon, 17 Aug 2026 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978803;
	bh=3OOz/MSTxkOAyJkZDydLOl7RKeUI9IWNcR9yJFo5VUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWXma/NSPUmP7fJSFqp7+QiyGC1M4Iaxs0ZHxQx1kNMClYQxe/JQzKd0LhhXarUpT
	 J8UmA3KKwnhFJ/7ksRIRtC2CHbM/Lwu0M8IAEF5mBt8qVK6l2389Ut/PwQ2j/txIHU
	 pWVLOkq3A9xvXw8mkomEPDW3ui2LDNWZarDEWTZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 128/156] xdp: reject clones that overrun skb_shared_info tailroom
Date: Mon, 17 Aug 2026 15:34:22 +0200
Message-ID: <20260817132539.686741554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
@@ -674,7 +674,7 @@ struct xdp_frame *xdpf_clone(struct xdp_
 	headroom = xdpf->headroom + sizeof(*xdpf);
 	totalsize = headroom + xdpf->len;
 
-	if (unlikely(totalsize > PAGE_SIZE))
+	if (unlikely(totalsize > SKB_WITH_OVERHEAD(PAGE_SIZE)))
 		return NULL;
 	page = dev_alloc_page();
 	if (!page)


