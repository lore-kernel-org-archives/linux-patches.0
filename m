Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80929223DD0;
	Mon, 23 Jun 2025 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716764; cv=none; b=SpMkzjnDQ9cF/bFZdMbdLzDhnBwvzSwPbv4/bhK8Vho0Ae+/+dsdHfCv3zrsOO5n4LJ+3ZqjJwiLuOYWXK5oeoBYLalzhZypmD4diW0K21HVpwDciFUA7gcMxu32tbAJkneY95O1qRd0lgfblGmLFrgF3Z/eFaI2m+PlEWHxiV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716764; c=relaxed/simple;
	bh=6ug1tmGr+f4vqAO4eZNzLAT1GastJzZTaU+gL6YCD2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+mrWWE7OiXG7irLuU/YWGY+fBjJ6Y2tJBE6VgI5EHGBdcitATHhmSk2ZhgbPhj568uJl7NGPIg4f3Z2L9lb2oLlq3JAv9/C3jNzS98dD4qWZMGLtC5C7VBR+fB4s1hxQBSHiU+DhiQjERS8j3wHdG1l+L61SQN071neiQD9KKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKTIL6PI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKTIL6PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F975C4CEED;
	Mon, 23 Jun 2025 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716764;
	bh=6ug1tmGr+f4vqAO4eZNzLAT1GastJzZTaU+gL6YCD2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKTIL6PI6t2bBY5e3lPEl62nvshRkqHsm4DO/jUeiXJlEJbIis9C7xQ7xN1j/rfcG
	 Jih4sjyrtI4d0uqWYTdaQjSgA/tsyZva3Q3NEN7aPU6Ljy3Zx9fkfWsIMW8m+2w8Rl
	 EhmICaFQZcM+F0Abjns5ijfACxaMHxYZnwdN+hQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 6.15 553/592] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:31 +0200
Message-ID: <20250623130713.598818678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3010a2034d6af..07c01b6f2b2be 100644
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



