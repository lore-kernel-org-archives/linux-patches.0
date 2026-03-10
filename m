Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0538946E;
	Tue, 10 Mar 2026 11:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142035; cv=none; b=by5OGIbcOq2G3ihUIgYc3MMhVYIda+5XW9Aki0mk8sWY/zGk+0Xz0gWyJe1V6KJFlvQQasReMwqmPmygXiDts7ChkhbKCSGpR+JLQtnkzs26t38/l295sdshlEeC0L9zRGMNsLD46dQdjHN47ZafBMFfmKkbj6vnXw8isxEpSNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142035; c=relaxed/simple;
	bh=L0wYUwMq94zzuJI06sf2BKD7vh/GWRG3SbMI2hYJ2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAuPTkEG3IWBV3WtO/liBi1sim20lNk1ZW2lIUDiOcPGi+R/6x2hYcwUHFtB0biNDAIapu7MpN5nangdkuqd7cnMXUV7VJjtxnGguCK/XBRhkcsEZNKxTLg1Hm47LBWlhh3W88hLwUv4XZsU5aCeomyA9WYlzuVrtmlNw1N8BSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K82OszbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K82OszbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6BBC19423;
	Tue, 10 Mar 2026 11:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142035;
	bh=L0wYUwMq94zzuJI06sf2BKD7vh/GWRG3SbMI2hYJ2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K82OszbHTEaLxSbPhyWGRNLi/0oST4hvkInArv4wSvnyKOuFxTcD+amMyTLRfQf9u
	 KgmHUlReYTmSqiXEzT8zLZ5nTe6qRdqE5RikZNOpYVDTjVRcwSfC0oZMIuOZ2/6Qyt
	 0q/LmB1D+WVif67eTnFkdEG1CJgbXAdgOrFsiw5PRw4CcZcsLbBkIQOyrKSksEfuj4
	 ui5LUpNkH3FNtzs3sdjhXqlipmLV7ZYGQHmvZN4Kp0pqr9+VPzuIrdX2v4CdEqNi2R
	 uknV6t3VxSK6r9JQYj6au9mdMff7Seea9s71ytesHN0TBNxrHTAmYQNNNM7JGvpKHt
	 n7ObujZQ+Owmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 162/314] wifi: libertas: fix use-after-free in lbs_free_adapter()
Date: Tue, 10 Mar 2026 07:17:01 -0400
Message-ID: <ea21ffd746f9fd2cd232f97f80ddd23deb369e09.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Hodges <git@danielhodges.dev>

commit 03cc8f90d0537fcd4985c3319b4fafbf2e3fb1f0 upstream.

The lbs_free_adapter() function uses timer_delete() (non-synchronous)
for both command_timer and tx_lockup_timer before the structure is
freed. This is incorrect because timer_delete() does not wait for
any running timer callback to complete.

If a timer callback is executing when lbs_free_adapter() is called,
the callback will access freed memory since lbs_cfg_free() frees the
containing structure immediately after lbs_free_adapter() returns.

Both timer callbacks (lbs_cmd_timeout_handler and lbs_tx_lockup_handler)
access priv->driver_lock, priv->cur_cmd, priv->dev, and other fields,
which would all be use-after-free violations.

Use timer_delete_sync() instead to ensure any running timer callback
has completed before returning.

This bug was introduced in commit 8f641d93c38a ("libertas: detect TX
lockups and reset hardware") where del_timer() was used instead of
del_timer_sync() in the cleanup path. The command_timer has had the
same issue since the driver was first written.

Fixes: 8f641d93c38a ("libertas: detect TX lockups and reset hardware")
Fixes: 954ee164f4f4 ("[PATCH] libertas: reorganize and simplify init sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Link: https://patch.msgid.link/20260206195356.15647-1-git@danielhodges.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index d44e02c6fe385..dd97f1b61f4d1 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -799,8 +799,8 @@ static void lbs_free_adapter(struct lbs_private *priv)
 {
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
-	timer_delete(&priv->command_timer);
-	timer_delete(&priv->tx_lockup_timer);
+	timer_delete_sync(&priv->command_timer);
+	timer_delete_sync(&priv->tx_lockup_timer);
 }
 
 static const struct net_device_ops lbs_netdev_ops = {
-- 
2.51.0

