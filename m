Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509864582DE;
	Tue, 21 Jul 2026 22:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672440; cv=none; b=LA6pzSevomkfQDnFjePX1aNU/NVpJ5oDH3i7a/+faKMwlZPpSGbT9o/95gXwPO+ucLSgSWgGVA09pLhaeAGy1RTrDPGr9LRNdCoQuFDzd1ptu50z/mbvygHD2uk36Lrvn/HWhkwYWbwIzzAw/7NHWteIUU70RTEZV+6rE5Y4hf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672440; c=relaxed/simple;
	bh=tYeU8bzWMnOkJ6NnQ1QfSy/rhAS783sdnDr3Md3cVG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByiMU9040NY1ci/n+hnFrocLiynKroLNzPJYdlYrwPGehywQIcDE0FYdS64D7zopGGwn7GrWqZc0agAxsJMdOnI+0UvB38H9CPAwcPrsaLO5i54ilR71D4YFcxwiBq+kCyzvz3xZcGTyk2m1Emejhg0PSn6w7PEnf39blTqY25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3YlpdkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3YlpdkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D8E1F000E9;
	Tue, 21 Jul 2026 22:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672439;
	bh=KBlAfI9uNmqN08m2yYQC3NfurAkrLMS/lQNqcVCnREw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3YlpdkPycQ9+H5gRb1CwBi+kdavQO5uCOqKPA8GhsNGCxzpPEygnvBaOsCWeurNO
	 Y7/DJ5hrjm7dfNtfNi5X4EgwM3xdkI6it2ccb00EVmvF+hGE+p3M8+7hjJYy6dJLTO
	 8eDhRDDC5Vi5trHgs2WryyRoeAaNJBmEvDmZzpTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 588/843] batman-adv: access unicast_ttvn skb->data only after skb realloc
Date: Tue, 21 Jul 2026 17:23:43 +0200
Message-ID: <20260721152419.278905677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -854,8 +854,8 @@ static bool batadv_check_unicast_ttvn(st
 	if (skb_cow(skb, sizeof(*unicast_packet)) < 0)
 		return false;
 
-	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	vid = batadv_get_vid(skb, hdr_len);
+	unicast_packet = (struct batadv_unicast_packet *)skb->data;
 	ethhdr = (struct ethhdr *)(skb->data + hdr_len);
 
 	/* do not reroute multicast frames in a unicast header */


