Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E562B3D75C3;
	Fri, 24 Apr 2026 13:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038236; cv=none; b=juOHlTp3m3nWlOzoQT3VI4PeI5Wr+StJk8OGHnPFObp7U1//KSW/sUHL09imMZkCTXSng6/azukOmBku8WjBol4w8STsV8/Bzq5g/qx3DeRNO35Rlqpgb6hMGWt7Yv/j6oB8qzyH+HZKHde8kQoUc71kJljiznHHs5ytyno3tBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038236; c=relaxed/simple;
	bh=95hERbtQx2TUw1WsmNf/wk5c1Qec9vQr86w67MxOIgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/ktvEzChLKUrXlyJloSy7XCbGzwXzwUc0J+I1shVAOSjUtTk+RoU51VnT/jnXnsDmXUec7l6x5+y1x7jZCQFwua4Tatfw3iXyPMr94+29C/fijyNUf/ex/QCNmGXiMhz74zngr32oP+pfc4joHG+03pWPr4xFJDc1qWddGMGsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZWgFXQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZWgFXQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B342C19425;
	Fri, 24 Apr 2026 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038235;
	bh=95hERbtQx2TUw1WsmNf/wk5c1Qec9vQr86w67MxOIgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZWgFXQn7ZnPLpmLTMZN07WYnSTI6D2BqN0P2/pRXiiSI5Ck8M+OzYWTy521nOagZ
	 +umnhdkbBv74VtYKss5tBezS/9hZg5ND2bHhRk1Ob/NSD83iI2PO8DWYggXtzDxck0
	 yLyyMHSVtD39vPXc4LLeD71t5zLm3jo1UfbB7VFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 21/35] smb: server: fix max_connections off-by-one in tcp accept path
Date: Fri, 24 Apr 2026 15:31:28 +0200
Message-ID: <20260424132416.133584441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit ce23158bfe584bd90d1918f279fdf9de57802012 upstream.

The global max_connections check in ksmbd's TCP accept path counts
the newly accepted connection with atomic_inc_return(), but then
rejects the connection when the result is greater than or equal to
server_conf.max_connections.

That makes the effective limit one smaller than configured. For
example:

- max_connections=1 rejects the first connection
- max_connections=2 allows only one connection

The per-IP limit in the same function uses <= correctly because it
counts only pre-existing connections. The global limit instead checks
the post-increment total, so it should reject only when that total
exceeds the configured maximum.

Fix this by changing the comparison from >= to >, so exactly
max_connections simultaneous connections are allowed and the next one
is rejected. This matches the documented meaning of max_connections
in fs/smb/server/ksmbd_netlink.h as the "Number of maximum simultaneous
connections".

Fixes: 0d0d4680db22 ("ksmbd: add max connections parameter")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -297,7 +297,7 @@ static int ksmbd_kthread_fn(void *p)
 
 skip_max_ip_conns_limit:
 		if (server_conf.max_connections &&
-		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+		    atomic_inc_return(&active_num_conn) > server_conf.max_connections) {
 			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
 					    atomic_read(&active_num_conn));
 			atomic_dec(&active_num_conn);


