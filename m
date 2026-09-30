Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6DB50254F;
	Wed, 30 Sep 2026 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787389; cv=none; b=chp6pLe018bR0tF9G7BKM6vgXhAQ3i31S4TryebxlsvolZ0ay7ZlEQyhDXtQTVCWAtg5ChjgI58CqvhJZbvYANW6gDL7Ug5ksZKdV7IhAka2H3woqQNLBSjw+3wZOBXyuDFmwKi/Bz+NuKG9hAwO6KiYtiNUONTUT3oe86kvj58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787389; c=relaxed/simple;
	bh=O/0/+XxegHSdGBnYH/4gw7pFDo4T+eY18qui/DCmtpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCUBD4awiAbSJbIhJMlXX/Q1QRghCEp56UxMjQkMS2mGbU1qOsVq5AED0lWhvTuEvpUh82LvlydD63G8qlDbpp+7zpF3cIdlcVEjPBloxD+tCWTCD8RtomfbtDTS0+CsJm1NCHn+C8hQQ8LI0LYMn6LYjqLmk5sK73WIz/1cwcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCsMuR/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCsMuR/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB68F1F000FF;
	Wed, 30 Sep 2026 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787388;
	bh=Olopk5GlO3/H97WPRKotTQEzRzZ7OoPa6ZsghYkogwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCsMuR/UWGL578eeoWTUpxildPHJXF0LL6D0TV503MIrgHuCtXHyx4yJhldO5dcar
	 kktqTzuPu4BYgVFaF5RwkEH/7KRreXcntWZXqUIaVrdW7rRd+bqUpEpw+u50ouA7GX
	 NaBKg74aGR5oA0rhrI455Y0lOEeBuJ9Bg3VbhTnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 214/457] net/rds: size a connections path set by the transport it ends up with
Date: Wed, 30 Sep 2026 17:25:19 +0200
Message-ID: <20260930152350.667899413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

[ Upstream commit ba3d1f480c7a3fba963e7867ad6cc557c197acbc ]

__rds_conn_create() computes npaths from the caller's transport before
it decides whether a connection to one of the host's own addresses is
to be handled by the loopback transport instead.  That substitution is
what an RDS/TCP socket sending to a local address gets, and after it
the path init loop still runs for the TCP transport's RDS_MPATH_WORKERS
paths and allocates an ordered workqueue for each, while
rds_loop_conn_alloc() only ever provides transport data for path 0.

rds_conn_destroy() sizes its teardown from c_trans, by then the
loopback transport, so it visits path 0 only - and
rds_conn_path_destroy() would skip the other paths anyway, since it
returns before destroy_workqueue() for a path without transport data.
kfree(c_path) then drops the last pointers to seven workqueues.  That
repeats for every such connection, on every netns teardown or module
unload, and every distinct local destination address is a separate
connection.

Recompute npaths once the transport is final, so that creation and
destruction agree on the set of paths.  The c_path array stays sized
for the caller's transport; the unused entries are freed with it.

Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueue")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260921215027.174657-1-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index b6c4beb50eaf0..c752a8623cfca 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -276,6 +276,12 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
 	conn->c_trans = trans;
 
+	/* The transport may just have been swapped for loopback; size the
+	 * set of paths - which is also what rds_conn_destroy() tears down
+	 * again - by the transport the connection actually uses.
+	 */
+	npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
+
 	init_waitqueue_head(&conn->c_hs_waitq);
 	for (i = 0; i < npaths; i++) {
 		__rds_conn_path_init(conn, &conn->c_path[i],
-- 
2.53.0



