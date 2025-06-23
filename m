Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C934C74;
	Mon, 23 Jun 2025 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716186; cv=none; b=cHXcGkd+mQ8PFTs1m5zZjz/KY0aHWkL184djDy7h4XpS/L5ExOFUsk3/pPQ/59SWaXMNTpOVjer+8X36xwV3R8EfAEKAS4DuNmr6AVE8u336by+cur0CP7KZWtBFd6G/eg1oOywQozv/wjamMsSyVHXgd2UVOJ53Xz5+EihSv9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716186; c=relaxed/simple;
	bh=ji2VDsUfqvCOMlc6gEWClhCJG5oMrCrYXNTUFbg5tB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1RnAiQpHdPiM5zIt1dssS1oxdgvREfNf1vq2RNdo18o+taSWhLp0z+grxkxD+ILPFR+TYnQ7bWhmDggSPD3uZT0yPftNvHI1Iy+eD6hLcyZ9rqZG6nx92UVk7zWIYDxPeaPDmaahYAmYTfi9oJY90qISY1DGFBk+x8JbKdNhmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lw/39mA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lw/39mA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3FEC4CEEA;
	Mon, 23 Jun 2025 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716186;
	bh=ji2VDsUfqvCOMlc6gEWClhCJG5oMrCrYXNTUFbg5tB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lw/39mA5JKH3YjLYXgK58xOsrHJDkxmNNNWY5AtqgvxT4wfvNqVAFqsNnfn/A7sww
	 LE6haurpGA4bx0lFsl6j0SvogwcV2Gn6xGJpAKAGD5RsqEITa0nY8z8nErnXhVdudL
	 9bUdQ4TBBjht4Mc/Y5RqEN0Ydh3T2Ih9KWjq7Lt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 6.6 268/290] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:49 +0200
Message-ID: <20250623130634.979983378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



