Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F1946B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBACAC433D2;
	Mon, 16 Jan 2023 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886393;
	bh=YIjQ+y1Z6MYV2iJ/z0x/uIibKMGpSls8UzgeIzIFkBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFFOp1Omz7s+ytaro6iYfFaIhDKGzMTSfl3sX1INVwsvtr9hBC2XU33p043fLp7PA
	 v1K3lPd+i9+/eZ3NXSglNnc+jhSPDasUrqCJitbBh6gwzcQYTbAXS81U8NXCMeH0Zc
	 C3NI9903zQDQQ9aPEHi8nae2vmt+OOsTibaRgtdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 383/658] rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
Date: Mon, 16 Jan 2023 16:47:51 +0100
Message-Id: <20230116154927.066996017@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4feb2c44629e6f9b459b41a5a60491069d346a95 ]

One of the error paths in rxrpc_do_sendmsg() doesn't unlock the call mutex
before returning.  Fix it to do this.

Note that this still doesn't get rid of the checker warning:

   ../net/rxrpc/sendmsg.c:617:5: warning: context imbalance in 'rxrpc_do_sendmsg' - wrong count at exit

I think the interplay between the socket lock and the call's user_mutex may
be too complicated for checker to analyse, especially as
rxrpc_new_client_call_for_sendmsg(), which it calls, returns with the
call's user_mutex if successful but unconditionally drops the socket lock.

Fixes: e754eba685aa ("rxrpc: Provide a cmsg to specify the amount of Tx data for a call")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 22f020099214..1cb90d32d553 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -718,7 +718,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 			if (call->tx_total_len != -1 ||
 			    call->tx_pending ||
 			    call->tx_top != 0)
-				goto error_put;
+				goto out_put_unlock;
 			call->tx_total_len = p.call.tx_total_len;
 		}
 	}
-- 
2.35.1



