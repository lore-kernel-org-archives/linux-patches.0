Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBBF13F006;
	Tue, 27 Feb 2024 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042094; cv=none; b=aYlXneLFxxINFsMpj4QiyQJKjX4K7R38dHWpPH+sprnAbUMdCD/9X52Yuz11VEXLR/KPw5eAF6KpJDZHWsRcUIc9TGJ7NPsSWI7LliXjGvwXKYHdDenGpRGWVy02DSC0ewnau6ifzfztw0be5wjkMz4nmH7OPcs/jZTZzNk+KYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042094; c=relaxed/simple;
	bh=YXMuWM+dYJgKH/x2iSx5mdmWMx3jqrXVHnqpw8alejk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldjgRVr+MUHvYNPgW+IzihVXZQmRvZY/zORWKhN3PsiA5NzmWBRifZzOKkAz/NAjEUJJIBrAcWEEhpKhjwh1baonN4mktQPICFVf7GXRsLqURGvtfsrxi4UFJEk/Je4d2n2PvafOhi1+AwtG3kWErdQeeeJ6hkjtc9rIZSuX2Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk7vTPv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk7vTPv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5FEC433F1;
	Tue, 27 Feb 2024 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042093;
	bh=YXMuWM+dYJgKH/x2iSx5mdmWMx3jqrXVHnqpw8alejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nk7vTPv9eqT4vTs3Xdr0rTFczGE2KvKbnFkL/emxReBsoq9FeJtwXo4zrMcAh1RSC
	 gVvfEnTskJvxxobleVPMC0ktyumQbwrRSz9LDuaVHCutUKYvJFxeh+vWBRBF/pB9It
	 y3JdK/hoGa9GaoLNeVximZZVQgmknhIcaZ2W9pvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Tom Parkin <tparkin@katalix.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 176/299] l2tp: pass correct message length to ip6_append_data
Date: Tue, 27 Feb 2024 14:24:47 +0100
Message-ID: <20240227131631.508246819@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -627,7 +627,7 @@ static int l2tp_ip6_sendmsg(struct sock
 
 back_from_confirm:
 	lock_sock(sk);
-	ulen = len + skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0;
+	ulen = len + (skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0);
 	err = ip6_append_data(sk, ip_generic_getfrag, msg,
 			      ulen, transhdrlen, &ipc6,
 			      &fl6, (struct rt6_info *)dst,


