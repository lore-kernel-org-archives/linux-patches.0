Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1D1DED55;
	Tue,  8 Oct 2024 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391445; cv=none; b=N/sr74g8i48YX/C8gCbv03n2UVEn8P4SclfPveM+so/gUHLJZ516Cat/0H1sd+JjW7Nya7AoDek/WGbwt+G0rS3DwIqT5uk2A1NNVQidiOP0QSmdsAMBhPwGg/ss2VDHaOodaktGCZUc7D0yNZZG5b0/YqfKuK0wVt48HAU1Oco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391445; c=relaxed/simple;
	bh=PmE9rrGRdyPr84/stoogRe2UW0ULhhwZKkwyJYGYh/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhtK4d7oQtu/c1W03CNWxGOmU3Wr0MQ3bxNx+hC/QnjbW4XfMzUGR+gbkb+vHdmEeGSG5ceNOzaoq+l/RqVWK7TQHHoQ2UwxBte9M/SGZAOAMfzeGdvWGZ02Ztr6S5Tjz8X4wr+g/DH+cEWMZq/HD1G6dX4iXZZlR10IsdTVi9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh5OrrIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh5OrrIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D589C4CECC;
	Tue,  8 Oct 2024 12:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391445;
	bh=PmE9rrGRdyPr84/stoogRe2UW0ULhhwZKkwyJYGYh/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eh5OrrIqQHK1zBZJsbsqCqh1mLsI70K+jx0cswyqfEXLM6Gc8WgX7eEh9jkimGdfu
	 0vGoxsRVkuEdlUjRdd9jTuO9BwE9Su14btW9/2KZSV2nlhcKmjAHsXfQYpTApISIui
	 2R14L4j/yeiR1MUa/2SK8+nNFQGOA0S7MhBIkseo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	Tom Parkin <tparkin@katalix.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 117/558] l2tp: free sessions using rcu
Date: Tue,  8 Oct 2024 14:02:27 +0200
Message-ID: <20241008115706.970682877@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Chapman <jchapman@katalix.com>

[ Upstream commit d17e89999574aca143dd4ede43e4382d32d98724 ]

l2tp sessions may be accessed under an rcu read lock. Have them freed
via rcu and remove the now unneeded synchronize_rcu when a session is
removed.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: Tom Parkin <tparkin@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 4 +---
 net/l2tp/l2tp_core.h | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a9cbcbc9d016d..edff7afc06199 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -152,7 +152,7 @@ static void l2tp_session_free(struct l2tp_session *session)
 	trace_free_session(session);
 	if (session->tunnel)
 		l2tp_tunnel_dec_refcount(session->tunnel);
-	kfree(session);
+	kfree_rcu(session, rcu);
 }
 
 struct l2tp_tunnel *l2tp_sk_to_tunnel(struct sock *sk)
@@ -1298,8 +1298,6 @@ static void l2tp_session_unhash(struct l2tp_session *session)
 
 		spin_unlock_bh(&pn->l2tp_session_idr_lock);
 		spin_unlock_bh(&tunnel->list_lock);
-
-		synchronize_rcu();
 	}
 }
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 6c25c196cc222..d0e3460089d90 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -67,6 +67,7 @@ struct l2tp_session_coll_list {
 struct l2tp_session {
 	int			magic;		/* should be L2TP_SESSION_MAGIC */
 	long			dead;
+	struct rcu_head		rcu;
 
 	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel context */
 	u32			session_id;
-- 
2.43.0



