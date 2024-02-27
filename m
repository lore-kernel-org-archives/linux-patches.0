Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE013B2BA;
	Tue, 27 Feb 2024 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042693; cv=none; b=YTdpWce/oTtHdwMEhua4e+TcIllYkGiCYIKw10sEWlt8X4Jk8GyajURvyxDIJl36TQUukRi9voWVeO+qPhtLgpzoDcpHElePSR/t8vJmWZj9TgH/t9RlA6XkglQxJJFzgBZ6BM+OHG2SOS5Jnx7ljj0zAi4vPoODDI9+zqYkrzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042693; c=relaxed/simple;
	bh=ihAxS7gB2Po+yYUESXfeQPTh/QcWGjQFwETjB3TnpC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsOznPPl+m4EqZIXGnhVTxCiUteWEdzr1FGijIgR7311emPZqp5HaHT9h20BAIQcKvTK6EPfbukz6eDCO/RKU0zij5Qp8toRUUWttw+KYLfbgSvO9cCTZOS3V57BJeiUjYZYWoEgue1u7cMynd2piuZbjTNGozIT5E01l8+WNkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnYjUIdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnYjUIdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082D3C433F1;
	Tue, 27 Feb 2024 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042693;
	bh=ihAxS7gB2Po+yYUESXfeQPTh/QcWGjQFwETjB3TnpC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnYjUIdAxw0Ai1tDQTtb3uxt0SBUsAZAb4jvcCtIUSo78eV0IzecXJQMUB+U2lLog
	 JtJsKvmqqYgWLKdJcHPOMDnB1RtDtk8+IbTEw2ruIixJXtHrC1H3Kkt78W7fOCHJKQ
	 iQeYyx/DJHCZO3/o2t5gQEQjaE1zaXWByQnSBk8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Tom Parkin <tparkin@katalix.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 086/245] l2tp: pass correct message length to ip6_append_data
Date: Tue, 27 Feb 2024 14:24:34 +0100
Message-ID: <20240227131618.023052691@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tom Parkin <tparkin@katalix.com>

commit 359e54a93ab43d32ee1bff3c2f9f10cb9f6b6e79 upstream.

l2tp_ip6_sendmsg needs to avoid accounting for the transport header
twice when splicing more data into an already partially-occupied skbuff.

To manage this, we check whether the skbuff contains data using
skb_queue_empty when deciding how much data to append using
ip6_append_data.

However, the code which performed the calculation was incorrect:

     ulen = len + skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0;

...due to C operator precedence, this ends up setting ulen to
transhdrlen for messages with a non-zero length, which results in
corrupted packets on the wire.

Add parentheses to correct the calculation in line with the original
intent.

Fixes: 9d4c75800f61 ("ipv4, ipv6: Fix handling of transhdrlen in __ip{,6}_append_data()")
Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tom Parkin <tparkin@katalix.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240220122156.43131-1-tparkin@katalix.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -628,7 +628,7 @@ static int l2tp_ip6_sendmsg(struct sock
 
 back_from_confirm:
 	lock_sock(sk);
-	ulen = len + skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0;
+	ulen = len + (skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0);
 	err = ip6_append_data(sk, ip_generic_getfrag, msg,
 			      ulen, transhdrlen, &ipc6,
 			      &fl6, (struct rt6_info *)dst,


