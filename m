Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D701F3D56;
	Tue, 21 Jul 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654268; cv=none; b=IsR2QERQ4Z2/VWCGF+40UIXpFl99FbMN17UNyCiWi4yYShBlnO0QVw2SsfBsgQWQI/cK9lX2Kpep903RqC2a/HWodVM08eBlf/rCIrgXJit2/sa+EqJCJyllHFmpfYidFHo+zZMwXDFVNLP4iuK7UfwHAeipBnyglgNj8KinVK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654268; c=relaxed/simple;
	bh=dLjiwz28OgJFp3fykgbEkrOUw6mPpfwZL5FnUCFede8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPbYMpqOKhtKv+j3e44NIWjavbyqLCUo71slwBLdbyVpW2Ls4djF+aQ+gbrPsmeA27ykMW27ktPydyw4igTVLJCypa+x/fkZGTCUWk0rU48nikbWIK4IEd6+aZlkxMI1q4Cy6ajeV8xhHzfQ0RJOph4YEZZfuRSL1V5pvV2EeFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkzJEqS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkzJEqS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A476F1F000E9;
	Tue, 21 Jul 2026 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654267;
	bh=mrKVA57WJsy4Z0n2bkV3j+PzrSEtq7jb8ayUu3R/hKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkzJEqS6B3nqhGab+lZqGUyFdexOjt1DC45BTSryFmNiQUGaKgUTnGlw02yTtZ/Ya
	 IpaATybopePU0oFi+QuhccNROUTLgz6oqMt1+S0uUvYVUpQn1J1Avyj5e3P/FN31ha
	 VM+ANdKGjRZggEmawq+WYqFjOVmbDdL6bGZrFGRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1640/2077] batman-adv: access unicast_ttvn skb->data only after skb realloc
Date: Tue, 21 Jul 2026 17:21:53 +0200
Message-ID: <20260721152631.433347738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


