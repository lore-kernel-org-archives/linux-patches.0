Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE950B8A8;
	Wed, 30 Sep 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785118; cv=none; b=i4hM27epIJha57nPHc2GoE2ES7JP3W8ZM7dNaFaXq6u0ZOxG6K7AGX1NVWElZs1f7INVDFb5EaPmEotKam9tWDEXZHkmSlPN+r7uaK/1fILSUET0WyZQnuNCMXbm/v36kvUJVCORM7D8SyW5YYn7XuUOFFig5V5cqE+uYlqbw9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785118; c=relaxed/simple;
	bh=MwE3erRS2wzC0p16uJmt6BYr6uJkkTC7Uk2eFPPj1U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOqbhMEosDYlOM4Cssl31y03Yirri32I11UwVIUF6B0B7LIKFrW6DJbu6moRaUl7hqywdgOLsZgY+VIfzwgjcLE4SL53WW2N3tv5HxnpqxcBItZepiw3UOJLJKrtu80tXmglmeSA3uas7rnyX4ydGEY1kp3Xnt6niOugaJ3M718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb65T9Rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb65T9Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F8A1F000FF;
	Wed, 30 Sep 2026 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785113;
	bh=6u9qweoYUrQZYU0a9v6kdM+xcwtPeb5q30CewveqMz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb65T9RzhTZGLi0dsJN7ATpmf3CM8rVgb0EZ74541Af5cPBtPdWFf5BYl+8c0t0e1
	 QPiEni1GjICgAOBcXbllgtAmEDpRWktEVOTY3gyI5w0vmzgUVcTR/ogdl+qFXPf7Hq
	 lhuEQjq/sRIKvAnF11cTAAdnwpSOWHWkaUe8/Qt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/982] net/rds: clear cp_flags bits individually in rds_conn_path_reset()
Date: Wed, 30 Sep 2026 17:18:48 +0200
Message-ID: <20260930152425.227507659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index beecd408e93ab..9e0c89b7bc4cd 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -119,7 +119,15 @@ static void rds_conn_path_reset(struct rds_conn_path *cp)
 
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



