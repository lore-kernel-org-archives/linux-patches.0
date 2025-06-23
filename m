Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC642222B2;
	Mon, 23 Jun 2025 22:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717475; cv=none; b=KntSo+T9+IT118JnK5B2A3Sesyxtszv/efPaes1kLX+CpSJggSd4ZwiwXhptOTdKksvSqC1LINPgC0VsPDTS7eIoXrNRVRZWgkRuuIu1VLIl7Sa2CnXz6d+bQ1tBKJRXDXI6Zcw7Z6W0A8/aD34GQ6t/mPkiunkAtb7uAAX6UwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717475; c=relaxed/simple;
	bh=H8zUNyAMyr99bpmRo4dbG+ua3Ar992oNyX4RvnSBzq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi5SPVMTXrCP4UJH/B8UjXNUH31VqNCCag17GxIu3irAf8LK4VtoG1djigtTrQhw4nqK9nDArZCFKuAb4aVEv0FlhPsk/bJm/8CO54AihWJ1JpmeJJ52B5vmmggU1QkuMBgtsMrm04amvc7/pYDHxOc/pWXuyP3Bf0JtcYHq+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2QWqS/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2QWqS/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C49C4CEEA;
	Mon, 23 Jun 2025 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717475;
	bh=H8zUNyAMyr99bpmRo4dbG+ua3Ar992oNyX4RvnSBzq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2QWqS/+2v78s8624mxFxR7sCHwUYxlXWtfaYRrlh1oCLJOcXqMx9VqkjogU86j95
	 OMB7bxvSTfmQI64vlOh9P1mSYeUFSyMT4hpkKZhDTweG1eAx37ck91FrEuh2/BVy/U
	 BakRAfmwiwPF60bza7+y/kTxM0b44LdIrpL7Tqwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 6.12 394/414] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:51 +0200
Message-ID: <20250623130651.788982977@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d03b79f459c7935cff830d98373474f440bd03ae ]

/proc/net/atm/lec must ensure safety against dev_lec[] changes.

It appears it had dev_put() calls without prior dev_hold(),
leading to imbalance and UAF.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com> # Minor atm contributor
Link: https://patch.msgid.link/20250618140844.1686882-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 09c042e1e4696..42e8047c65105 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -909,7 +909,6 @@ static void *lec_itf_walk(struct lec_state *state, loff_t *l)
 	v = (dev && netdev_priv(dev)) ?
 		lec_priv_walk(state, l, netdev_priv(dev)) : NULL;
 	if (!v && dev) {
-		dev_put(dev);
 		/* Partial state reset for the next time we get called */
 		dev = NULL;
 	}
@@ -933,6 +932,7 @@ static void *lec_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct lec_state *state = seq->private;
 
+	mutex_lock(&lec_mutex);
 	state->itf = 0;
 	state->dev = NULL;
 	state->locked = NULL;
@@ -950,8 +950,9 @@ static void lec_seq_stop(struct seq_file *seq, void *v)
 	if (state->dev) {
 		spin_unlock_irqrestore(&state->locked->lec_arp_lock,
 				       state->flags);
-		dev_put(state->dev);
+		state->dev = NULL;
 	}
+	mutex_unlock(&lec_mutex);
 }
 
 static void *lec_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-- 
2.39.5



