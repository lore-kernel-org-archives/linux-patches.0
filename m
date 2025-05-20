Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170E92459F2;
	Tue, 20 May 2025 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749616; cv=none; b=gil+EKd1ulZ6eQ3wZbISRtEPRWnWgzF+g+4nzUXkrUz50E/lpQfnHq5GXT5XFFquBZlB3rwudl616qYSLQxO0p8E38mFOR9LKSDkfzrgHqriQIrd9QGh2BA+5VDnBEXbtYTNedp5oXFhnEhcZtXT3V93rU/MQfBNZbgv2EiVFac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749616; c=relaxed/simple;
	bh=jIm5XC/2Fqg40XAg845ms0omhHa7cOOyR30EaTH+Ys8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkgl96081gLPPl3db7EXiFJ6lOlk77Bgon+LoVmVP/R5chQPPdJHTBpdyMCHu3JQWSDJBBwqCO6prve+7PEdcfIqCp7j7wR8DPJbYLbOztGY7RUP6R/nzhLCziB7cRTPd692ckuesI4lGtQ7bXC7XS6UnITp4eKZaCBi/uynL2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWbf6sv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWbf6sv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC38C4CEE9;
	Tue, 20 May 2025 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749616;
	bh=jIm5XC/2Fqg40XAg845ms0omhHa7cOOyR30EaTH+Ys8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWbf6sv8xWQCT5Qc4Qnz89lTL9WzViOtKDL56Nxf48aApLXL5O6ckRTuX8JDfs8Jc
	 t3PqC/7NZLf5hU5/4gsvCI4cpXEmbM6FSCrFhaWj+30JRc0EdHKTB0ogr7nxdBD/h1
	 lhQkGIV1N8TAn1LekbMtKSnY9X/6JVawLGvSnRCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Zhaoyang Li <lizy04@hust.edu.cn>
Subject: [PATCH 6.1 94/97] ipv6: Fix potential uninit-value access in __ip6_make_skb()
Date: Tue, 20 May 2025 15:50:59 +0200
Message-ID: <20250520125804.342479581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Zhaoyang Li <lizy04@hust.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1985,7 +1985,8 @@ struct sk_buff *__ip6_make_skb(struct so
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 		u8 icmp6_type;
 
-		if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
+		if (sk->sk_socket->type == SOCK_RAW &&
+		    !(fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH))
 			icmp6_type = fl6->fl6_icmp_type;
 		else
 			icmp6_type = icmp6_hdr(skb)->icmp6_type;


