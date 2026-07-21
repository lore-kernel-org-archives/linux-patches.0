Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E05846AA7B;
	Tue, 21 Jul 2026 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647969; cv=none; b=r1End32J/O4u1eACwSrHfKYOwAmxXwfhY1UN9+ZwMBxqakTybdoROM1hSO1j1ZImts5cUY/dkE5YFf+7FsEtEVziNgFfmaMLioQenB6R+2VQgzzCSt4UZG/SE5YfqvXBeZIagLRQ2D0xc5QJLP4JZp9FP/0403fR46exRyY06o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647969; c=relaxed/simple;
	bh=bQ0iUkd5DgLo/TyQWVq2nFglx4vhZxyVcOn1fluG6go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjkfRiRg+K2gFeytotDq1AQMEcjrNTXztaeqhZXUqBjRVaXDOcmVHpOoZiiNKXQZ9sfHPj2vA7a3NGESM5eqLDBwGPc50e9upbpOxL1hJrfXg9o+Hlaa8TbZKmG1zU52FJuMTgAbogUV045DZFSGnBEdupUBgM7Bb80nXW2J/kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8+gc1b+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8+gc1b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4071F000E9;
	Tue, 21 Jul 2026 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647968;
	bh=LlQ0l2C92SsAr172nZgOooXERyYPRUg4BbKqygcJuSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8+gc1b+0yFrAKfC20naUsSiDEJy6pDkUW9fAGcY0bWV0+RtDdnpL595EJ0ZuzL8v
	 p3W/37av9mHY/FbUcp/yRzsjlXBX8kqFzSlxME3bRNGXphjItdPhU12gtlgs8ZjV8i
	 AjGgtCxUIAuLKNSCPVfBxA+gtVgyrug5TwAc8qG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0023/2077] rxrpc: Dont move a peeked OOB message onto the pending queue
Date: Tue, 21 Jul 2026 16:54:56 +0200
Message-ID: <20260721152553.217673902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 5801cff7d5d7b4e9d877dfb627b23eb63167f02c upstream.

rxrpc_recvmsg_oob() takes a received oob message off recvmsg_oobq and,
if a response is needed, moves it onto the pending_oobq tree. However,
only the unlink from recvmsg_oobq is guarded by MSG_PEEK; the move onto
pending_oobq always runs.

As a result, reading a challenge with MSG_PEEK leaves the skb on
recvmsg_oobq while also adding it to pending_oobq. Since struct
sk_buff's rbnode shares storage with its next and prev pointers,
rb_insert_color() overwrites the list linkage, and the skb, which holds
a single reference, becomes reachable from both queues at once.

When the socket is closed both queues are drained in turn. While
draining recvmsg_oobq, __skb_unlink() follows the next and prev
pointers that rbnode has overwritten and writes to a bad address. Also,
as the skb holds a single reference but is freed from each queue, both
the skb and the connection reference it holds are released twice. This
leads to memory corruption and to a use-after-free caused by the
connection refcount underflow.

MSG_PEEK does not consume the message from the queue, so only unlink it
from recvmsg_oobq and then move it onto pending_oobq or free it when
the message is actually consumed.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260609140911.838677-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -262,12 +262,13 @@ static int rxrpc_recvmsg_oob(struct sock
 		break;
 	}
 
-	if (!(flags & MSG_PEEK))
+	if (!(flags & MSG_PEEK)) {
 		skb_unlink(skb, &rx->recvmsg_oobq);
-	if (need_response)
-		rxrpc_add_pending_oob(rx, skb);
-	else
-		rxrpc_free_skb(skb, rxrpc_skb_put_oob);
+		if (need_response)
+			rxrpc_add_pending_oob(rx, skb);
+		else
+			rxrpc_free_skb(skb, rxrpc_skb_put_oob);
+	}
 	return ret;
 }
 


