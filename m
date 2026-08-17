Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FCF39733E;
	Mon, 17 Aug 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975248; cv=none; b=EjNUFDtifv+WdOf9EhWCZ5jsq81Yf5FHK1b36U5lsfoCcMxHsdOAhYIXQvudoLra0l9umGf/df542OttQj6nQ2OhIRN0oxE7oHMGozZiIT0DFQA6LBpNNsMl3BCsKaNs7v4JPGb56oFwnvDHH0EkkrRDExy165OofIBqQRXcvss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975248; c=relaxed/simple;
	bh=BvRpJlo1mPox0riv2XixXn91q5HOtVgFqisPgW1mN8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nzsd8WfmrfDd69VltdyfwE82QMYxCo6wfkKd2CNZbFocYhZB4Mrarv8mGeGrk5Kv8l9owp7iQ+OCp6+N4AaZ4TtpEm/EPJEzJm3nmCldwwdZD/+1psl6YwweAeQW6Lj09GQadPKSbL+WHzVnRMOI/ZnJBZVhbFYtMUEbqSJZuQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOFeRfUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOFeRfUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF69C1F000E9;
	Mon, 17 Aug 2026 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975247;
	bh=VRYFoKf9P3Z+k3j7hSZHT9ZSYBx9qr7z897h2q+ra4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOFeRfUDF7+DTRa9QMveu+kgZaheIkn6sxaOPBtva+AQQHbIfsBcmDjGiuYFYhsCg
	 Ejcq/cb01tzem0mUqK893f9xqKKQCcs/2YVplqxM8rW+E4leXCagm+EzucPP2Y0eU6
	 RCiUIRZhL89Z7J1S1GKvlaNEM0roVBf8fGJaeKyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 214/250] xdp: reject clones that overrun skb_shared_info tailroom
Date: Mon, 17 Aug 2026 15:32:55 +0200
Message-ID: <20260817132545.284604663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,7 +871,7 @@ struct xdp_frame *xdpf_clone(struct xdp_
 	headroom = xdpf->headroom + sizeof(*xdpf);
 	totalsize = headroom + xdpf->len;
 
-	if (unlikely(totalsize > PAGE_SIZE))
+	if (unlikely(totalsize > SKB_WITH_OVERHEAD(PAGE_SIZE)))
 		return NULL;
 	page = dev_alloc_page();
 	if (!page)


