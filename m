Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318C04EB85D;
	Thu, 17 Sep 2026 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659420; cv=none; b=RKNDYqw4HujTGo2MTKnXGtsjgKGa42zwOi1Q/k+UBdSBfI9ztcNbs2wvPSzK3AoVuc4Wb9XTVilMS6eUTPHqrgnwK+grjt8JR7CV/XXw7vx02TxH5PQWImhgOd+/jkJhg6Znl+rVIldvj3xSLvuMNyc27oxzQnM3520q2fLBgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659420; c=relaxed/simple;
	bh=v6syUgfWjK8d3AxnZ0w+wdf6kyNQGfgIO8qgjVZDupI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuLEUTdKdrG2hnEeeLJiq222OjVO+haCl3hJXLiI8TIf2sSdAooguSJwsU3taRMfbXpa7H8YlnhK3/3RaL2eIUUAlurCkdwTvBE5hJLcn5aKy1kidxwUSmIo7+ZuD0knSQvxGdMSssDmlfTtoN0ixTvqlD4qGy/zlBymu6IDqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3NpnzVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3NpnzVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0ED1F000FF;
	Thu, 17 Sep 2026 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659415;
	bh=is0zmsU3YV6NxPMtQZ7fMuC/Blj0bAxbtKOUZuzeN5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3NpnzVFeL6321NBamjEaR3lmV9nG21O+K6l+2MBKG3qDgIpVPKCR3ELD+Gehb7i4
	 1rCO6DCvMy6nR+Jyz8scnxHk2VBbTPqoSwx0eBnzrmro+EjL/wmK8Pje7t51IrladH
	 JsGvMWkTAWkTeliDY6laffbBEc36HqtVyuhih6ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 210/733] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
Date: Thu, 17 Sep 2026 16:08:38 +0100
Message-ID: <20260917151356.417095966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 103c4b13c4f50322910078d1c02f29334a574122 ]

rds_conn_path_reset() wipes the whole flag word with a plain
cp->cp_flags = 0 store.  Every other accessor of that word uses
atomic bitops, and some of them can run concurrently with the reset:
RDS_LL_SEND_FULL is set from rds_send_xmit() and cleared from the
transport completion paths, neither of which holds anything that
excludes the shutdown worker.  A plain store racing an atomic
read-modify-write on the same word is a data race, and whichever
side loses has its update silently discarded.

Clear the two bits the reset is actually responsible for instead.
RDS_IN_XMIT and RDS_RECV_REFILL need no store at all here: they
belong to the caller, rds_conn_shutdown(), which waits for both to be
clear before calling the transport shutdown and this reset.

This also gives every bit in cp_flags a single well-defined writer
discipline, which the following patches rely on when they turn
RDS_IN_XMIT and RDS_RECV_REFILL into bit locks held across the
teardown: a blanket store mid-teardown would destroy lock ownership
that an atomic clear preserves.

Oracle UEK carries the same conversion ("net/rds: Preserve essential
connection state flags"), motivated by its asynchronous shutdown
state machine, whose progress and destroy flags must survive the
reset.  UEK's variant also clears RDS_IN_XMIT and RDS_RECV_REFILL
because there the reset runs as the final step of a teardown that
owns both bits, making those clears its unlock.  Upstream that
release belongs in rds_conn_shutdown(): once a later patch in this
series turns the two bits into locks held across the teardown, ending
ownership needs release semantics and a wake-up that a plain clear
inside the reset would not provide.

Based on Oracle UEK commit "net/rds: Preserve essential connection
state flags" by Gerd Rausch.

Fixes: 00e0f34c6166 ("RDS: Connection handling")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-4-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7c8ab8e973e1b..46ac72088f842 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -120,7 +120,15 @@ static void rds_conn_path_reset(struct rds_conn_path *cp)
 
 	rds_stats_inc(s_conn_reset);
 	rds_send_path_reset(cp);
-	cp->cp_flags = 0;
+
+	/* Clear the bits the reset is responsible for individually: a
+	 * blanket cp_flags = 0 is a plain store that can clobber a
+	 * concurrent atomic read-modify-write on the same word.
+	 * RDS_IN_XMIT and RDS_RECV_REFILL belong to the caller,
+	 * rds_conn_shutdown(), and are left alone here.
+	 */
+	clear_bit(RDS_LL_SEND_FULL, &cp->cp_flags);
+	clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
 
 	/* Do not clear next_rx_seq here, else we cannot distinguish
 	 * retransmitted packets from new packets, and will hand all
-- 
2.53.0



