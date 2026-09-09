Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1255409E;
	Wed,  9 Sep 2026 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962185; cv=none; b=abLYvKmpGd94SDDmfHk04bvdX7WnxfoO6ZJOThrHrHz1EO7O3yZPhXh/gGlD0JHkiP+8pJO8u1LZXJ2CaY3/d6KmooWa8ZhSGJCZoBjI6TqSkwgT4i2EihCq+4VTBrgdPgnPFtTKfaHxl+NA6iBiTkG+1AmYmDV5y/XalXYiG2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962185; c=relaxed/simple;
	bh=EW3LcFt5u3Z1wthazhI308fbnxZfxi6io//Q5YIXeTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhtJC+OJPnILSIlG4IpV2AJYcUHzWZqdODRCzDWxsesivvPDggV4IUdWlzeZKAvlmpOORCy9W1KKyy/ny9nY1uqGo2pU27I6XdgpLi4LS6wY3q7r53y52QHA4ExXu60eWE3tF1nRXN1kRfYsRSjifdX/OnMdI07ClMa1krFfZkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfo25lbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfo25lbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E5C1F00A3A;
	Wed,  9 Sep 2026 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962184;
	bh=r+IosMEfIKM2/yxCOnl2wDFExjL1FTMB0AXsPkuo0JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfo25lbrqrY9mX4kbfstKID9rRTKzVe6rPZcE40OXh9FLpkJt5juWuM3hnlW69yo3
	 88k+aA6yU4GJThnDwV2WtPs36/ZIlTeZIE7ytmQhg60HWnV9b1KoVpYOXg7dlhsEoL
	 cabUZCqxjqtBDKX4gbcdq1B1C47wEtcuYQttjmP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.2 202/556] batman-adv: mcast: ensure unshared skb for multicast packets
Date: Wed,  9 Sep 2026 15:38:02 +0200
Message-ID: <20260909134237.499095324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 82bf207f48ebb7a38157f1d91dac884fc9b8cfd8 upstream.

When a packet is transmitted via a batman-adv interface and has already
enough room for the header then nothing will make sure that the skbuff is
unshared. But it is not allowed to modify a currently shared skbuff.

Always make sure that the pskb_expand_head() is not only called for a too
small header but also for shared skbuffs.

Cc: stable@vger.kernel.org
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -1100,8 +1100,7 @@ static int batadv_mcast_forw_expand_head
 		return -EINVAL;
 	}
 
-	if (skb_headroom(skb) < hdr_size &&
-	    pskb_expand_head(skb, hdr_size, 0, GFP_ATOMIC) < 0)
+	if (skb_cow(skb, hdr_size) < 0)
 		return -ENOMEM;
 
 	return 0;


