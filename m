Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106F81EFFA6;
	Mon, 23 Jun 2025 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713497; cv=none; b=AEDQ0mqV+oZe+EVNkgshLUz5BG3KntoQN4GBUuYVKuq1YbENoB+Vr5GCCSdp/3+PGf9ZoAKsnsmikyML0RwcWriISPCnk+PfLl/ZVkFp8OqEP3gfFf+b0t8shdOgecWaWwy35mxy/Y2y+b2HThgEkCAX5KRqg0hS16xr8tNBXUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713497; c=relaxed/simple;
	bh=S9dgMIQdfz1dQ4QkuSBaFR+jx28P8Tsc/jP0DEHhT2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7dBkCeDZqlSqeS1Mtwx/i0g5u4/GHEgAIX3txBCm4EJa9vUg2wGn7tDQF8aMcw0R1DeX1XIOwR3x4ybFCFFLE7tqhrTSNhU58QgraVOBNcPAp0xgzjLgNrbP6kpNOrmScOoqEwVHuEQbiq+HDKsTf4bzxpBMp2W4UlfbM6jAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkAHu2Jq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkAHu2Jq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF3BC4CEEA;
	Mon, 23 Jun 2025 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713496;
	bh=S9dgMIQdfz1dQ4QkuSBaFR+jx28P8Tsc/jP0DEHhT2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkAHu2Jqo01LDoTrzefYEbW7UD4U5SS8bHZ4OhaGpMzlc5n3vkkXqXzV9knF45OM5
	 Fl0yXIbQKH17Camb63d+oy58Vxovjdcn9wby3GlqmQJJJ6zmCt4H9lqGa0BdBawrPH
	 bcOYhGL2jkmFhErFiQ6wzpCWCg+0mFok4NPfyF3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 5.4 209/222] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:09:04 +0200
Message-ID: <20250623130618.585562973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5b9220c42dfcc..49fe366c3b1d7 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -916,7 +916,6 @@ static void *lec_itf_walk(struct lec_state *state, loff_t *l)
 	v = (dev && netdev_priv(dev)) ?
 		lec_priv_walk(state, l, netdev_priv(dev)) : NULL;
 	if (!v && dev) {
-		dev_put(dev);
 		/* Partial state reset for the next time we get called */
 		dev = NULL;
 	}
@@ -940,6 +939,7 @@ static void *lec_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct lec_state *state = seq->private;
 
+	mutex_lock(&lec_mutex);
 	state->itf = 0;
 	state->dev = NULL;
 	state->locked = NULL;
@@ -957,8 +957,9 @@ static void lec_seq_stop(struct seq_file *seq, void *v)
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



