Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4836C79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A19C433EF;
	Thu, 12 Jan 2023 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533442;
	bh=PQkAW1FznKaIgtAJtDkVLEq6tnqvBy19QUU6ARi4sKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTLi2b16CBhIrnNZ+ITqqfY6oRTsnosOlY97Ar5o1W4ZltkmgcuiCacnCQBwsjewW
	 6IS6xzZwKUETszKQ7Up0oMfgwXHzC2oZ2knFFlWr0PsheTK3HfcFJlOCdVhZ94Y3wo
	 y15j3tpqGgDc/W4XKO4G5Zi1k4PAZQh6pTTqrxAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/783] rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
Date: Thu, 12 Jan 2023 14:53:16 +0100
Message-Id: <20230112135546.448450297@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index eef3c14fd1c1..a670553159ab 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -733,7 +733,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
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



