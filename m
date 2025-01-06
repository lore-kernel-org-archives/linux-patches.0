Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CD41DE2DE;
	Mon,  6 Jan 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178337; cv=none; b=VuWYfLT6I/SgaLo4nZ7L2srz7R9iFlfAu1l1CxRrRI2BOX4etL6f5xGtf4QfOYDo/lLnI+f7OOsstUcd7LYWBZcb1Wpab+bO7lpY8V6ZP6SvQIHRCW7B3G3obrbPYCKwC7RzpRrCNFdd3e6DYaajeqX2BgYV42GDI5c9aIJsMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178337; c=relaxed/simple;
	bh=TlFZQJrYhFm4AH/K1wBNPQV+ZMHtH07PWU57Pm/oVL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThlzrCrq4jJSXi6E17IsZ0U9/YSjbHP3Vhv924xK/+QYAqAEeFrriLnUWt9awyruLfjtjbtxvm1ctfLbaPq55J/J9r7pfh1GJb2nIOB5p62kT2x00XaAJwmj33A5L05BU7bX52s87R/IuFldr5rioNlZA2PFbnrEo5MIUuXVJ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOMnr3hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOMnr3hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6464AC4CED2;
	Mon,  6 Jan 2025 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178337;
	bh=TlFZQJrYhFm4AH/K1wBNPQV+ZMHtH07PWU57Pm/oVL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOMnr3hzlvB0PMizcNuSXcuNIA2ia70shO5maZwQCi1yROosZH3jDJuGXSgmn9Oqd
	 WwRRzIjumPWfzvYg5Iroc+0s1F+70lMLSLgJsVPNslAfG84/mBp9SpBGSZblfpv6VW
	 XSZ5Rbfz9fKFP1oKfdh4oTY+ZPhnZzPvaGapgPbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 083/138] ipv6: prevent possible UAF in ip6_xmit()
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151136.377891705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 2d5ff7e339d04622d8282661df36151906d0e1c7 upstream.

If skb_expand_head() returns NULL, skb has been freed
and the associated dst/idev could also have been freed.

We must use rcu_read_lock() to prevent a possible UAF.

Fixes: 0c9f227bee11 ("ipv6: use skb_expand_head in ip6_xmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -272,11 +272,15 @@ int ip6_xmit(const struct sock *sk, stru
 		head_room += opt->opt_nflen + opt->opt_flen;
 
 	if (unlikely(head_room > skb_headroom(skb))) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, head_room);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOBUFS;
 		}
+		rcu_read_unlock();
 	}
 
 	if (opt) {


