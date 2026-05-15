Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC2F3E7BAD;
	Fri, 15 May 2026 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861737; cv=none; b=cbkN0mlOcK9M88A5mxV53i3uZeXcn6/P1lODlGiwphQyk4GsF6UVBjqLafzvxWpCeu2L+Gj3X45nyppPMddGVdnBniBd+A/ymx4tQdnukUEEQb3dsJyGmsJrnIna/+DcK7w/tidKS9JGNVJ27cA2kejQPrsVp2UARGud14lanwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861737; c=relaxed/simple;
	bh=P8DkaNsoA1Fr1lWX85YxApvFctG7RhvktmGYYASIeXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5RjMZqGfRnUwYXrxL9y6CumdiamwZXINM6X/QE8/NzGD0XDivaBoMeOD4XiZ7MN776aWUlHWWb6j6cW9ShJMU0Axm0jJl7TsiD/ElSWEt+c3sw5QhjBwsPwLCw7pAPRUwyGT7gCzZhCRubtUv0ynWMByduy8p0Myv0CDp2g+88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRspakdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRspakdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A8BC2BCB0;
	Fri, 15 May 2026 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861737;
	bh=P8DkaNsoA1Fr1lWX85YxApvFctG7RhvktmGYYASIeXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRspakdOs37S/L2E2lOwCMz5Rqk6sij577fmRKBbOkbkRt+QIxmBGaDHDDpnnMReM
	 rKdgZwOS/lZ+yMzYhe6IVDoAC3YZ16VapSe1BRrF0NQvZ48s3Hu+e99Vn12vFbRnk0
	 X5F3Jl93sX1b3t2dPmR5CNB2QjQRUnRQsrH1lmfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 444/474] rxrpc: Fix conn-level packet handling to unshare RESPONSE packets
Date: Fri, 15 May 2026 17:49:13 +0200
Message-ID: <20260515154724.694719011@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 24481a7f573305706054c59e275371f8d0fe919f ]

The security operations that verify the RESPONSE packets decrypt bits of it
in place - however, the sk_buff may be shared with a packet sniffer, which
would lead to the sniffer seeing an apparently corrupt packet (actually
decrypted).

Fix this by handing a copy of the packet off to the specific security
handler if the packet was cloned.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/conn_event.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -226,6 +226,33 @@ static void rxrpc_call_is_secure(struct
 		rxrpc_notify_socket(call);
 }
 
+static int rxrpc_verify_response(struct rxrpc_connection *conn,
+				 struct sk_buff *skb)
+{
+	int ret;
+
+	if (skb_cloned(skb)) {
+		/* Copy the packet if shared so that we can do in-place
+		 * decryption.
+		 */
+		struct sk_buff *nskb = skb_copy(skb, GFP_NOFS);
+
+		if (nskb) {
+			rxrpc_new_skb(nskb, rxrpc_skb_new_unshared);
+			ret = conn->security->verify_response(conn, nskb);
+			rxrpc_free_skb(nskb, rxrpc_skb_put_response_copy);
+		} else {
+			/* OOM - Drop the packet. */
+			rxrpc_see_skb(skb, rxrpc_skb_see_unshare_nomem);
+			ret = -ENOMEM;
+		}
+	} else {
+		ret = conn->security->verify_response(conn, skb);
+	}
+
+	return ret;
+}
+
 /*
  * connection-level Rx packet processor
  */
@@ -253,7 +280,7 @@ static int rxrpc_process_event(struct rx
 		}
 		spin_unlock(&conn->state_lock);
 
-		ret = conn->security->verify_response(conn, skb);
+		ret = rxrpc_verify_response(conn, skb);
 		if (ret < 0)
 			return ret;
 


