Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E91863BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BF0C433D2;
	Mon, 20 Feb 2023 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900320;
	bh=XpOmjL4rZAZF3gpGNKAk3Yqsv8PYa6+k6gWhY78I28g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daXGOzx2M8b0TvW+Ef/e5bkr934uKn1gscalnTLGPu1PQldv8a4/m7ygv30s42kmY
	 PEVUfwMWsL9fFKZRjl38gvqIWevr33zYlDWOezb7MAHVzOjyQ7i8Dj5Fo3k+HgPk1m
	 cq6MZy8IIId/Rkonq07CrL6eHGD1ZWYGiv9uAUu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/53] sctp: do not check hb_timer.expires when resetting hb_timer
Date: Mon, 20 Feb 2023 14:35:32 +0100
Message-Id: <20230220133548.393857156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 8f35ae17ef565a605de5f409e04bcd49a55d7646 ]

It tries to avoid the frequently hb_timer refresh in commit ba6f5e33bdbb
("sctp: avoid refreshing heartbeat timer too often"), and it only allows
mod_timer when the new expires is after hb_timer.expires. It means even
a much shorter interval for hb timer gets applied, it will have to wait
until the current hb timer to time out.

In sctp_do_8_2_transport_strike(), when a transport enters PF state, it
expects to update the hb timer to resend a heartbeat every rto after
calling sctp_transport_reset_hb_timer(), which will not work as the
change mentioned above.

The frequently hb_timer refresh was caused by sctp_transport_reset_timers()
called in sctp_outq_flush() and it was already removed in the commit above.
So we don't have to check hb_timer.expires when resetting hb_timer as it is
now not called very often.

Fixes: ba6f5e33bdbb ("sctp: avoid refreshing heartbeat timer too often")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/d958c06985713ec84049a2d5664879802710179a.1675095933.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index af56651169b2..79d2aa44c6e5 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -210,9 +210,7 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if ((time_before(transport->hb_timer.expires, expires) ||
-	     !timer_pending(&transport->hb_timer)) &&
-	    !mod_timer(&transport->hb_timer,
+	if (!mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
 }
-- 
2.39.0



