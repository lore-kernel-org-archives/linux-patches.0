Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE434409;
	Mon, 23 Jun 2025 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716044; cv=none; b=fPsyjYWaIdvHkAJ5huUV+PzwYlZXpqSme6ev8q/7qh8EzQnpE4PztfIJH6YCGa7e8EA11A2qWchyiKIExvgQ/ggq3Vg6GJIhKoN3nfb2WgwVvBi2jEFyBAtxwCgHHk1G4EUAx/q8wJTYJthxOy8zKJ/7gEMJDlBGNvmqDd2nZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716044; c=relaxed/simple;
	bh=1U6hbO2fiLpFm+s0VX19Lh3o9XrwDLXqu6t+uUMTkzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOCcopJ4eenEIFGwCYLBT+8XEnvboYgefhXpCc0um8Tz+hLTR/q4+sJ2vzdEYWdddqrp0q3GUFwav9UZl/A/e8ALOKQXVTOC8Yk2rrtF4StBKM/9/VebGXq6B5ipj+H86b/mPvQw0Sbz7hRT4cufiXrE8he2aLn7RX4SiwygleI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XP4ynpJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XP4ynpJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D22C4CEEA;
	Mon, 23 Jun 2025 22:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716044;
	bh=1U6hbO2fiLpFm+s0VX19Lh3o9XrwDLXqu6t+uUMTkzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XP4ynpJFLg3EwLc2Zu05e6OsDwZJFFS6QrdVFwcgPQc8svO7riHwc9j1Oq/i1IlLj
	 sV81g4kIpuMVucJEz5VNQc8oPom2Q1y1gaOZDSoNRj2hzm/O9nHFM5FPboby1CvOGr
	 QDKDhLOKCFJttWwGs9LpxCfxIjO8SIYhHFjhphew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 5.10 317/355] net: atm: fix /proc/net/atm/lec handling
Date: Mon, 23 Jun 2025 15:08:38 +0200
Message-ID: <20250623130636.297696692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



