Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADA924E4AF;
	Mon, 13 Apr 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096601; cv=none; b=H9Y3Y5RMMyH86lxs1dO5SNDTSiT1cqyOe3PSk952FM7siq73oZgtUZaek5JrslihOi9GhQ9zp0PWrFeJFMEgRMU2p0//yvk81Vo9W72jwUJ97zD9fxhEITo4Gu2xH/N/Vb+VlClThhlVY6RMY7HIeeQqSlfkuwAycJNn+IpxubQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096601; c=relaxed/simple;
	bh=1mdy6Z3rVhTCheufu0LIYwP+FKIFq0mAsHHJOvZqdSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTNyEYc5m/B2Z440eRqCUWTgiB91iWejaL7aG53pAQ0f1a/RSfvjINacLRfOlf5KjL10hfKas0KPaKMhnD72IaaGVF1p8eKEj0Nl1Du5bJreqKCZxu4vyGp6+EZbOqG9jHjgA8OSVP/VFsD/aX66TYmDoagG47E0IlSYohvWuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMaTpbrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMaTpbrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F100C2BCAF;
	Mon, 13 Apr 2026 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096601;
	bh=1mdy6Z3rVhTCheufu0LIYwP+FKIFq0mAsHHJOvZqdSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMaTpbrNTta0z5uG3pSRi8UeQRV0NllDyk8XZa66tR/E4LCfqGv8BXhrBOLBmq241
	 +J2QVazDKH047wG6czqvEAo6rHse4ytattXczvvzdsYCrIdzU6n13LWugInsJ9TQqB
	 w+wr3QGuDRGSiUbT3jJ6mBBbwVzH0ZVlL6K1m3go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	Willy Tarreau <w@1wt.eu>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 73/83] rxrpc: fix RESPONSE authenticator parser OOB read
Date: Mon, 13 Apr 2026 18:00:41 +0200
Message-ID: <20260413155733.725409275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

commit 3e3138007887504ee9206d0bfb5acb062c600025 upstream.

rxgk_verify_authenticator() copies auth_len bytes into a temporary
buffer and then passes p + auth_len as the parser limit to
rxgk_do_verify_authenticator(). Since p is a __be32 *, that inflates the
parser end pointer by a factor of four and lets malformed RESPONSE
authenticators read past the kmalloc() buffer.

Decoded from the original latest-net reproduction logs with
scripts/decode_stacktrace.sh:

BUG: KASAN: slab-out-of-bounds in rxgk_verify_response()
Call Trace:
 dump_stack_lvl() [lib/dump_stack.c:123]
 print_report() [mm/kasan/report.c:379 mm/kasan/report.c:482]
 kasan_report() [mm/kasan/report.c:597]
 rxgk_verify_response()
   [net/rxrpc/rxgk.c:1103 net/rxrpc/rxgk.c:1167
    net/rxrpc/rxgk.c:1274]
 rxrpc_process_connection()
   [net/rxrpc/conn_event.c:266 net/rxrpc/conn_event.c:364
    net/rxrpc/conn_event.c:386]
 process_one_work() [kernel/workqueue.c:3281]
 worker_thread()
   [kernel/workqueue.c:3353 kernel/workqueue.c:3440]
 kthread() [kernel/kthread.c:436]
 ret_from_fork() [arch/x86/kernel/process.c:164]

Allocated by task 54:
 rxgk_verify_response()
   [include/linux/slab.h:954 net/rxrpc/rxgk.c:1155
    net/rxrpc/rxgk.c:1274]
 rxrpc_process_connection()
   [net/rxrpc/conn_event.c:266 net/rxrpc/conn_event.c:364
    net/rxrpc/conn_event.c:386]

Convert the byte count to __be32 units before constructing the parser
limit.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: Willy Tarreau <w@1wt.eu>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-13-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1164,7 +1164,8 @@ static int rxgk_verify_authenticator(str
 	}
 
 	p = auth;
-	ret = rxgk_do_verify_authenticator(conn, krb5, skb, p, p + auth_len);
+	ret = rxgk_do_verify_authenticator(conn, krb5, skb, p,
+					   p + auth_len / sizeof(*p));
 error:
 	kfree(auth);
 	return ret;


