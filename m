Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F472820A9;
	Mon, 13 Apr 2026 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096380; cv=none; b=PnM89jwvhl9YuHJMKOUOPKMdks0FYVpVvwmNVCMXNPRTN4wwtseEm9hQvSQxTEcI3365B1P8GgbmYfogIKpJAvAu4xWjQgAi1+nj847qo1+HQN4OqjgA8jcTygmBorfmS+zQPPpjSmNz7aV/RsV036+45lUNYAsR2/g0SViX9Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096380; c=relaxed/simple;
	bh=tS66S6ybClZbiBjtVuxfkqmyo/pHpLam95aK/zG/Ftc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbzXOnGt6j2qsntq9rk+7N0MSGoENs8qdka8dIXJqKbBKlhnXm/xwln6PSHCC8de/mcL0Ld1zTOscQWeFoJSkJs0jDu3QqGPUh7ns2c7D84MKRG/A3M3COeGrPWfem0RYDlN4py34zxLEQc1DA8qFxoYNBhvkp7RilbxTH0Qkv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcaHTytl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcaHTytl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3A6C2BCAF;
	Mon, 13 Apr 2026 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096380;
	bh=tS66S6ybClZbiBjtVuxfkqmyo/pHpLam95aK/zG/Ftc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcaHTytlz9SHj8aPf5NpwV2466dchLpBI5PCPrMryQIHaNXlCO4hrpdFPCHZPo2EK
	 a+1CpD3bIfqDA9uNqJ3OYPN9kEVXdEqYhjuhWNHfQzi9AufAOBaNgp7XH+13GySGKd
	 6KyP0ALuFh3ejHc7DFTz9VTU0eq9bVOXvw/nP844=
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
Subject: [PATCH 6.19 76/86] rxrpc: fix RESPONSE authenticator parser OOB read
Date: Mon, 13 Apr 2026 18:00:23 +0200
Message-ID: <20260413155734.379594155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


