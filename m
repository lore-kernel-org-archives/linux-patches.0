Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB269403E9B;
	Tue, 21 Jul 2026 18:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658588; cv=none; b=Oi54bKGa05MrHWgBuEIrAD9JgjrCDgtSmZJykp0BSHzRXyiZ/d6BlRk3V/JPwDUNRKQrB/bxclO2qLUFiRKFZO9V9e+amP9QwU4RjzCb5NlXYrc9hIrW9n5WQAae9SfvkYJLVTl03+4YFFvvz44rAKBcdQVovu6Rwn+5KooLPfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658588; c=relaxed/simple;
	bh=1eYGI/sskIGsUWZp42zs+TL2gztFp+vcnrfO3ppCFus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUGWtBFCimFal0QmSYjVMYTkg9ocFQNavE7mnBh7iP8nV1jYvq79PdVt9pWYINAH9fxsHbWDvKT8dop0P07/c1fhAhX41ytMTaBGxlaSttnRxNxByhGuVoyr1Z5jgnKfhyJLQKbXQmRRmcoU69uyAzlBWRdFnEkOxN1yzegQqvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAJWaUy9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAJWaUy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C191F000E9;
	Tue, 21 Jul 2026 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658587;
	bh=IXxJ3nUeZwSvbalU2+qO9WnFudReEBah15JmqQp6Srg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAJWaUy9sS7R/PEZx5DYPI3TzLPCipnM4DnR2aQ2HcYeFfSIoFv0gTwvMotXatS2A
	 UpIzw3dplqP5aXOTqJZT1VA3PvALAt39aAFR1+Sa2MdpRywoNv/YoGQL4bXROFuT/f
	 yInEZ1QYNHz6KO1tgmTHpzrjgQJdufF31AsvJCuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1198/1611] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:21:54 +0200
Message-ID: <20260721152542.376724765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit cdf3b5af2bc4431e58629e8ad2086b1e9185c761 upstream.

The pskb_may_pull() called by batadv_bla_is_backbone_gw() could reallocate
the buffer behind the skb. Variables which were pointing to the old buffer
need to be reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 9e794b6bf4a2 ("batman-adv: drop unicast packets from other backbone gw")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1029,6 +1029,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


