Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8A2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72050C433EF;
	Wed, 12 Apr 2023 08:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288613;
	bh=Ni5WgqAd/x+43oEnTth3WHu4cNR8PvwnKPSmFqQL+ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inkd7/GRNsXRFrwdifD2n1m8oGJg4b6ysgrhlNYGYHXjgXTDpfaxT5nvD761Vnzdj
	 V3tK/uuPKh5GMWRuIC5TrC8CJrp4EOtHcEuUM4Sk7AldAkXTgQmOFp0ur5Pvacv+AU
	 BFMSF500R8Nj/x0xRcEsHmi86/3PxotfyuL+zTvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 44/93] sunrpc: only free unix grouplist after RCU settles
Date: Wed, 12 Apr 2023 10:33:45 +0200
Message-Id: <20230412082825.001176111@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 5085e41f9e83a1bec51da1f20b54f2ec3a13a3fe ]

While the unix_gid object is rcu-freed, the group_info list that it
contains is not. Ensure that we only put the group list reference once
we are really freeing the unix_gid object.

Reported-by: Zhi Li <yieli@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2183056
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Fixes: fd5d2f78261b ("SUNRPC: Make server side AUTH_UNIX use lockless lookups")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcauth_unix.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index d7ed7d49115ac..a7d107167c05c 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -415,14 +415,23 @@ static int unix_gid_hash(kuid_t uid)
 	return hash_long(from_kuid(&init_user_ns, uid), GID_HASHBITS);
 }
 
-static void unix_gid_put(struct kref *kref)
+static void unix_gid_free(struct rcu_head *rcu)
 {
-	struct cache_head *item = container_of(kref, struct cache_head, ref);
-	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+	struct unix_gid *ug = container_of(rcu, struct unix_gid, rcu);
+	struct cache_head *item = &ug->h;
+
 	if (test_bit(CACHE_VALID, &item->flags) &&
 	    !test_bit(CACHE_NEGATIVE, &item->flags))
 		put_group_info(ug->gi);
-	kfree_rcu(ug, rcu);
+	kfree(ug);
+}
+
+static void unix_gid_put(struct kref *kref)
+{
+	struct cache_head *item = container_of(kref, struct cache_head, ref);
+	struct unix_gid *ug = container_of(item, struct unix_gid, h);
+
+	call_rcu(&ug->rcu, unix_gid_free);
 }
 
 static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
-- 
2.39.2



