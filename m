Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C533C2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4749EC433EF;
	Tue, 18 Apr 2023 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820904;
	bh=7xr2AnK4r08rNlc8o836OoT+cKVRB9ELER0GpEolU1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJhH9ySpYi/VLA8XM08LPu4eiBwxo77ms40GqNwHNhZVntMAZKDF/dRaW/6mFcPwD
	 nt0HOj/5wkIQuhU4CAeR0Ao72SiGdGyK9atyAfcJ/pbrzM01WLUyW4nL+4GYJPFEzW
	 +kKJoPtdDMnJn6kol/yOl5+98ySFwDkVvgXE4JzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/92] sunrpc: only free unix grouplist after RCU settles
Date: Tue, 18 Apr 2023 14:20:53 +0200
Message-Id: <20230418120305.439758856@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
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
index 5c04ba7d456b2..5b47e33632399 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -428,14 +428,23 @@ static int unix_gid_hash(kuid_t uid)
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



