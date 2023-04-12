Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034352F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D38AC433EF;
	Wed, 12 Apr 2023 08:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289498;
	bh=KniCw7X4s6beES+ACV7I6uEf+SnCJlfKPEwGe5iWZ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KYHcLEM/9I95e1L2HBqvrE6RkDR66xNflVJ50tqnGDCF6Ete8laqSeOtKAnSQ5Yn
	 DyG2ySyHblJnof7U0Ul/FI12mF4GB9KFp1kqn2BaWAjpmUt4GlCjZqgxx6I5O6rcED
	 lfbz4HsjBsvmtJxFEIRr1pdch1f5OfeXnTMXx0is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 093/173] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
Date: Wed, 12 Apr 2023 10:33:39 +0200
Message-Id: <20230412082841.820299099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marios Makassikis <mmakassikis@freebox.fr>

commit e416ea62a9166e6075a07a970cc5bf79255d2700 upstream.

Commit 83dcedd5540d ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()"),
changes GFP modifiers passed to kvmalloc(). This cause xfstests generic/551
test to fail. We limit pdu length size according to connection status and
maximum number of connections. In the rest, memory allocation of request
is limited by credit management. so these flags are no longer needed.

Fixes: 83dcedd5540d ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()")
Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -326,10 +326,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size,
-					     GFP_KERNEL |
-					     __GFP_NOWARN |
-					     __GFP_NORETRY);
+		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
 


