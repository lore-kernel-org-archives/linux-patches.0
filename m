Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5DD4A441D;
	Wed, 30 Sep 2026 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790203; cv=none; b=qQJh4PKOVnn729RngGXxOKDC5mWUY5Njoyj1CLrIGMKhh/z/G2nlxGLvp2jOt8eWDPnwcKia57kDWlcASwaH1jThKA57E/idMoyC1wXydcszKO1qZh3v3h/7ZLpx9HSaRkUojg9XDZvW5uZbtoaF8zIOnTmahcdGBzrEwP8PSnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790203; c=relaxed/simple;
	bh=1Zq4EvTq3bEjkt7A7wh0m/J41WEjAh+el5FMAQgAQ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlbhk830RaIkg/dP7c0N9JsrothVVXTLjvwfGnALy7lirP+/uqhF9vHsOuuClZVP6Cl5vucn7FUG8fDcX7zWnnLiNKnykp1w4wFBybTdUeomaMAwVMELasBNGwqcl1qRptmQf0n1d0L0bmiD1atjtT+AeMmunSG7svU9LRRm+fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4v4uayI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4v4uayI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520001F000FF;
	Wed, 30 Sep 2026 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790201;
	bh=kfWVZqL13slxWf7gMAgU0lyDChxALfIVVhSvXDZrHJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4v4uayIk94jcvF5wTrpa9IwdpxYaWWd16fNO2JEoqaJDS2+qFtGLGTaQtVc6VxXc
	 2MEaHw6qrOSy87NillQuLJppxpIQkMFHkIBb+5W9NlR1o8WvKrwaODhJ4GsN+cDUo+
	 EqYoDVOu0JUEP7zFM908TLmnlVZ95ZA0WE9nAaCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 747/877] ipv4: use rcu in ip_fib_check_default()
Date: Wed, 30 Sep 2026 17:27:38 +0200
Message-ID: <20260930152430.815230829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fc38b28365e5f1396209d2878a34065468765087 ]

fib_info_devhash[] is not resized in fib_info_hash_move().

fib_nh structs are already freed after an rcu grace period.

This will allow to remove fib_info_lock in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20241004134720.579244-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -275,7 +275,7 @@ void fib_release_info(struct fib_info *f
 			change_nexthops(fi) {
 				if (!nexthop_nh->fib_nh_dev)
 					continue;
-				hlist_del(&nexthop_nh->nh_hash);
+				hlist_del_rcu(&nexthop_nh->nh_hash);
 			} endfor_nexthops(fi)
 		}
 		/* Paired with READ_ONCE() from fib_table_lookup() */
@@ -432,28 +432,23 @@ static struct fib_info *fib_find_info(st
 }
 
 /* Check, that the gateway is already configured.
- * Used only by redirect accept routine.
+ * Used only by redirect accept routine, under rcu_read_lock();
  */
 int ip_fib_check_default(__be32 gw, struct net_device *dev)
 {
 	struct hlist_head *head;
 	struct fib_nh *nh;
 
-	spin_lock(&fib_info_lock);
-
 	head = fib_info_devhash_bucket(dev);
 
-	hlist_for_each_entry(nh, head, nh_hash) {
+	hlist_for_each_entry_rcu(nh, head, nh_hash) {
 		if (nh->fib_nh_dev == dev &&
 		    nh->fib_nh_gw4 == gw &&
 		    !(nh->fib_nh_flags & RTNH_F_DEAD)) {
-			spin_unlock(&fib_info_lock);
 			return 0;
 		}
 	}
 
-	spin_unlock(&fib_info_lock);
-
 	return -1;
 }
 
@@ -1638,7 +1633,7 @@ link_it:
 			if (!nexthop_nh->fib_nh_dev)
 				continue;
 			head = fib_info_devhash_bucket(nexthop_nh->fib_nh_dev);
-			hlist_add_head(&nexthop_nh->nh_hash, head);
+			hlist_add_head_rcu(&nexthop_nh->nh_hash, head);
 		} endfor_nexthops(fi)
 	}
 	spin_unlock_bh(&fib_info_lock);


