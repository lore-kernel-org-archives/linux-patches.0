Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1B528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7A0C4339B;
	Mon, 30 Jan 2023 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087685;
	bh=RiMduKbuLamA74C98UqKheL4ulsBqT74/8dKmISunWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1dU3YaPIWjKNAgJfhqTufUQco1kfVBeKXP0fga1iPxZWkLKETGNO63eDYZ3pjJAC
	 xyLb2PBCJTaWSmJ2bLdsGyEffLlrmPaZldl7Lk4ipnh1wPlJR5tKg6iDWUArOvcUCj
	 HLO39cs/EBlf9nmb/jYPdLuAN3Kn/mvId37Mn064=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/313] net: mctp: move expiry timer delete to unhash
Date: Mon, 30 Jan 2023 14:52:05 +0100
Message-Id: <20230130134350.243104077@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 5f41ae6fca9d40ab3cb9b0507931ef7a9b3ea50b ]

Currently, we delete the key expiry timer (in sk->close) before
unhashing the sk. This means that another thread may find the sk through
its presence on the key list, and re-queue the timer.

This change moves the timer deletion to the unhash, after we have made
the key no longer observable, so the timer cannot be re-queued.

Fixes: 7b14e15ae6f4 ("mctp: Implement a timeout for tags")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index fc9e728b6333..fb6ae3110528 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -544,9 +544,6 @@ static int mctp_sk_init(struct sock *sk)
 
 static void mctp_sk_close(struct sock *sk, long timeout)
 {
-	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
-
-	del_timer_sync(&msk->key_expiry);
 	sk_common_release(sk);
 }
 
@@ -581,6 +578,12 @@ static void mctp_sk_unhash(struct sock *sk)
 		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_CLOSED);
 	}
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
+
+	/* Since there are no more tag allocations (we have removed all of the
+	 * keys), stop any pending expiry events. the timer cannot be re-queued
+	 * as the sk is no longer observable
+	 */
+	del_timer_sync(&msk->key_expiry);
 }
 
 static struct proto mctp_proto = {
-- 
2.39.0



