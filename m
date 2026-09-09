Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C384565112;
	Wed,  9 Sep 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963619; cv=none; b=ZLa7pQro5bmu6UW+RmAJSJWPdct6u3E9607oBWzLuBevrw7acqEtfCCbTGwo0QhyW7ce5Up6SJEOwQhzXBWBdhf9zEnh3SHtPMOoXPCBPYrPn7gx1OKTP6ehegmosmy4zUSH3xF+qpeQaykAvX5lsnTbU3QbDrDr84WhuUZM0l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963619; c=relaxed/simple;
	bh=qEFupc4ahYOaGU6G2L5ktf0aRc2DAQkWr46L7jwspIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEZyrw1SSnIzPYzQVglu9rPPnNZL9ZHvTBKeqhJpdZXcoj7I8DJhNcP5/ofWv3eY9lZvsOYry4kWDoEJ5RPXueQUxwR3HnyHX5VEPk8yY6YNQ6nCxWD24UMVDcNnlfjyp4J6I7p3E1cWfD/Ez5iACabjXVhByzy6u0VznW29k78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGpERHVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGpERHVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0831F00A3A;
	Wed,  9 Sep 2026 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963618;
	bh=cH9RCG+YqXvhcIZ94yYlrmPiABwouMb3TgBdP8YNMEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGpERHVwfuque/fALIS0wKcXpoXJ+ToUbMNCPo60Es/5eWnqpdKrsWSqQ8JXGTTD3
	 hZvtXGkXPbmbbSd0/NbAuuLjJjaalCWeUIfs14ZQqnTSdUlPfa/KRUD2TNVaCnKeDP
	 MHdLo/HvrmaNJHMc2PdLQYo9R17HereHRaGaHaWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 141/583] batman-adv: mcast: ensure unshared skb for multicast packets
Date: Wed,  9 Sep 2026 15:37:06 +0200
Message-ID: <20260909134243.037581844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


