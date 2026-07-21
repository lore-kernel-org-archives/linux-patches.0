Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5E0403E9B;
	Tue, 21 Jul 2026 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658580; cv=none; b=e5atlRTS/1Kji+UtSestE4X8XZ6YMAjiPFH1lJiigp8LCy5y6BSwJo8sb1KMHYpyiDj4WcV8WOJmsr3uPfg0yy3wgEZMXTaa3ArwJxzPEFFyrBsoAgVRAnnUKA3YyLne8SX+AWRqRDDkUFWfjBgQdzLC4RupT588U5g3SLjHwRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658580; c=relaxed/simple;
	bh=sxTRJrwgbORwI4UzSDB5GbGCqfiYwWzC0ZbuU4CkZ6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA1W1Xb2QyGIrmt772nBWPL4JKwY056Q5QggfdbK488b5w6b01GVp4XC93swzqP5hivVtc9+R+U5/8hcLFN4QL0WxaKYrvRT/JyOBPfk2yr5AdaoSk9bb+Nc7oNDajFXCUrSuUk2OwVOPBOVLvIta+/yNgldqRaLqtYgpJg0kXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4hHFWH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4hHFWH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0471F000E9;
	Tue, 21 Jul 2026 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658579;
	bh=QuVEmjR07pUpWuhZ8rjwVHSZvPkLil0yZyScTl3dkuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4hHFWH4wk8YyO7xRZ6CmchV4QJRNUbmq47cxzA94udwS/FlNvY2W5lqo/1HE4RPT
	 kTW8A8IsI9mhwVauF3QuQv5pJZco4IH9QEwthSPuNtSUL8kjaEvXNDn/HCl+YC99A6
	 uF7vYyAXIGrSk8Q/ssb6bIDgYVTbZZc8sLg847v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1196/1611] batman-adv: access unicast_ttvn skb->data only after skb realloc
Date: Tue, 21 Jul 2026 17:21:52 +0200
Message-ID: <20260721152542.333350245@linuxfoundation.org>
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

commit 7141990add3f75436f2933cb310654cad3b1e3e9 upstream.

The pskb_may_pull() called by batadv_get_vid() could reallocate the buffer
behind the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the ethernet header but missed for the
unicast_packet pointer.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -855,8 +855,8 @@ static bool batadv_check_unicast_ttvn(st
 	if (skb_cow(skb, sizeof(*unicast_packet)) < 0)
 		return false;
 
-	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	vid = batadv_get_vid(skb, hdr_len);
+	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	ethhdr = (struct ethhdr *)(skb->data + hdr_len);
 
 	/* do not reroute multicast frames in a unicast header */


