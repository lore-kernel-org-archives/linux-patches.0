Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85354C81;
	Thu, 15 Jan 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498606; cv=none; b=LrPqd7UDrKl1yE/xgV3NtWCuufhNMEk7X7cIY4V1b1M9D/EBIEZyKZo0v/Jf/feyVKnw4mdFNGZlu/t6lE23/lZXxFuK9iPxl50gldLDHhhsFgYJm4RfAnfP7snaVkNwP5cy1LTMn5XkpvdtnVfSIn17DqCUyV0Gsl/4d2C45zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498606; c=relaxed/simple;
	bh=pJDAoSh6eXW+XtBHpPS4c25L+oI0rw/bw7IkkBSwU1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxaYbnk7FIUAsN9lfDMhpch9dEep0avRDWpMt/zowsXD3gmjhceo2bwoDgA6e7qMly9QaRXFm3beMsUHJjKd+unhhcJLWg8JelD33mv5nvFzlfImUjZTdZzQHZKrkxgwco+fkNudd3gqZAE0SdYfvdAas3WI3S79JA7mypyiB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoyW/l5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoyW/l5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7695CC116D0;
	Thu, 15 Jan 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498605;
	bh=pJDAoSh6eXW+XtBHpPS4c25L+oI0rw/bw7IkkBSwU1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoyW/l5SJa2G26Kke4vwU3YP30lQXnpEMJm8Yrr/JZP0qG7TDocV8OK2E+4FQ6Ldg
	 BupSUzh/mm0sNR8FMoyCG/h+u392WoQDjEOMDDcjq4G1n1nOeSNfM66HLOe8U/ujfa
	 PkJND4juNVT+eAoKOXqAUhnEwf4uNFZnrC8fffC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.15 489/554] ipv6: Fix potential uninit-value access in __ip6_make_skb()
Date: Thu, 15 Jan 2026 17:49:15 +0100
Message-ID: <20260115164304.016474492@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

commit 4e13d3a9c25b7080f8a619f961e943fe08c2672c upstream.

As it was done in commit fc1092f51567 ("ipv4: Fix uninit-value access in
__ip_make_skb()") for IPv4, check FLOWI_FLAG_KNOWN_NH on fl6->flowi6_flags
instead of testing HDRINCL on the socket to avoid a race condition which
causes uninit-value access.

Fixes: ea30388baebc ("ipv6: Fix an uninit variable access bug in __ip6_make_skb()")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Referred stable v6.1.y version of the patch to generate this one
 v6.1 link: https://github.com/gregkh/linux/commit/a05c1ede50e9656f0752e523c7b54f3a3489e9a8 ]
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1928,7 +1928,8 @@ struct sk_buff *__ip6_make_skb(struct so
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 		u8 icmp6_type;
 
-		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+		if (sk->sk_socket->type == SOCK_RAW &&
+		    !(fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH))
 			icmp6_type = fl6->fl6_icmp_type;
 		else
 			icmp6_type = icmp6_hdr(skb)->icmp6_type;


