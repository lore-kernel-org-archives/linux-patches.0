Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA5B145357;
	Tue, 27 Feb 2024 13:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041575; cv=none; b=sO78Eq1XKZ7sVOpKNeOfGVWvCYqMO4D2dxXAuhz/55wk+8iu6qvRI/oZPzlLYIB4yqzsv/5zBEGZBh/NuKlm6h5XPiicH02T25BBCi5YuPNxRRhWb2o6bO02Nr12BIZAtL2DYwJBcXJUZjbqTj8BPqNikgFuUQoaksFQRwHVaBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041575; c=relaxed/simple;
	bh=eHDgfJFjpgqMo0o7/up65VHtBlIunYUkiU6AUt8+Lok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h89U959esqV4wwYxRCCbrvLIePPZXMn9wHF6iEXtHi9FI6CQV8GEevklxnf89aYQt6A+MP6FIlWLXE+OnTRmw3VY+UB391vwp3peb071qYPGs5W1lYy2wbruqSb1fquiO9hQ4xjjYZhfN15i8ApMjMDgFjwYl7tXVriIWEmiPlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVqGI8pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVqGI8pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56024C43394;
	Tue, 27 Feb 2024 13:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041574;
	bh=eHDgfJFjpgqMo0o7/up65VHtBlIunYUkiU6AUt8+Lok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVqGI8pQNqwO2RVeXOQ34exise3fVr0ZzewHN9ZysJ/PPI19mJVjTRMxWeP1KiBQ2
	 lhg/LDC+B7+ERmBlKiKKtxxXvLoYiVPsoA/5BUnW7y+9BBsOhie21YA13I59WViXLA
	 Kut2hGMtIynn/5jkubfrCr0NVcoLwcCt+GVUm8r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Tom Parkin <tparkin@katalix.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 31/52] l2tp: pass correct message length to ip6_append_data
Date: Tue, 27 Feb 2024 14:26:18 +0100
Message-ID: <20240227131549.552470778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -648,7 +648,7 @@ static int l2tp_ip6_sendmsg(struct sock
 
 back_from_confirm:
 	lock_sock(sk);
-	ulen = len + skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0;
+	ulen = len + (skb_queue_empty(&sk->sk_write_queue) ? transhdrlen : 0);
 	err = ip6_append_data(sk, ip_generic_getfrag, msg,
 			      ulen, transhdrlen, &ipc6,
 			      &fl6, (struct rt6_info *)dst,


