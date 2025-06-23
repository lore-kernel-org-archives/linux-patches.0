Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832EE19E7F9;
	Mon, 23 Jun 2025 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716960; cv=none; b=ebY6Hw7D+OJneIju4SwuUFnPDYhCAhVRJgHYII78T9FTOOvjziNWpGk2skzH8iGIiW6Zchz9L+Cq9n4cL/8Xhjpmoof7f+r7N/Vdij6980dSlKoZYBOp1cg4XNME8NOHLldaE8HSTRHcAJCulKexlRziao6Uc0fNGChhcGB2tkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716960; c=relaxed/simple;
	bh=dGEeLG0raJhVZVOGOnGiY1eAmJZj1/fbOQZ+tZhivNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez6ZTJFzGSmSntpoYiH6tHx9LSby6Rh2o160eU48i0jPq6AiG/KzMEp6YGRDa8QR2TzDB7xgJN7msMp8btOp412qlTWkq4fIN62oEuDTf+kCFS2mTHKfDZwvy7+tEG/POoXmOuP8NOtKwXtW51Da/ZbvPI3Rk2ptk8ekRX4drZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAcYSDkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAcYSDkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20EDC4CEEA;
	Mon, 23 Jun 2025 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716960;
	bh=dGEeLG0raJhVZVOGOnGiY1eAmJZj1/fbOQZ+tZhivNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAcYSDkN6CSVvHzWcdHIkstuZ16KtRsv/bXTFU8IF4hGcN1GWuF+Dw7cmry+aQhoV
	 TVWA07JvPSDdZklaprX/UB/ma0IzenqK3O0Aeb/jPJx+D/uYGNHTEKLnrF8YQLvjtZ
	 llVpri3eOPS7ojx1gYm9lsK4J1ULuJjiqaJSUvtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 5.15 382/411] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:46 +0200
Message-ID: <20250623130643.264009250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f67b84c8f1c9..73078306504c0 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -911,7 +911,6 @@ static void *lec_itf_walk(struct lec_state *state, loff_t *l)
 	v = (dev && netdev_priv(dev)) ?
 		lec_priv_walk(state, l, netdev_priv(dev)) : NULL;
 	if (!v && dev) {
-		dev_put(dev);
 		/* Partial state reset for the next time we get called */
 		dev = NULL;
 	}
@@ -935,6 +934,7 @@ static void *lec_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct lec_state *state = seq->private;
 
+	mutex_lock(&lec_mutex);
 	state->itf = 0;
 	state->dev = NULL;
 	state->locked = NULL;
@@ -952,8 +952,9 @@ static void lec_seq_stop(struct seq_file *seq, void *v)
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



