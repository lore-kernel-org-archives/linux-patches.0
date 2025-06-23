Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161D1F463B;
	Mon, 23 Jun 2025 22:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717654; cv=none; b=pY1kn/Nsh0VPptuXXMKpXu3d1ZVg4Bh1qfH4sPAml5WWg2ijcluBCPH38xcmQcWxuhplKW8Rj0i4TKbVvrV86lSoTKBpY+wlER7ijkk/tOlFz9IkQuBLBnD7MH378oLMZ3sVUu4rApAGYnLaMh3T8500mQgKe5EizMJ8XE7LvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717654; c=relaxed/simple;
	bh=/6L7AUnn6g89jtlyXCZLJBbD0ap9duki49pa6RilMes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3qS/FCiuQKzF0RTM2MAV/sRSuDhRGxMEIgkS/aiTB5Nux28LraxZja0KlqyTNBdv43lv1s7wtpedpzYz+JZ/PJombltmxcX1L3zELmE9+F11MfMmxmvSplfM/CWNFGXiPyij7HbkNvTH1kn32e2riJDurEO/04nEnizoexr9GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYV3JMyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYV3JMyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAB2C4CEEA;
	Mon, 23 Jun 2025 22:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717653;
	bh=/6L7AUnn6g89jtlyXCZLJBbD0ap9duki49pa6RilMes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYV3JMyMdpwHvift99emNmdG8D4tb/OxTvovS+z36FTu867v0newz8fXBauqgLQ2u
	 ndA88cJOYOwBrV4zdGU/9yj6wI0iMztMSzvlV4BqwPfwgm+hXr7hSIO92LqG1r6kvK
	 0tjshmysWOnO7+WCuOO4cgl+6nDSC7SMh/RM/I/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 6.1 491/508] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130657.119287533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4ac1488eca6f..b7fa48a9b7205 100644
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



