Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1DD51A122;
	Wed, 30 Sep 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788363; cv=none; b=JKtnp2Rd8nzu47mKAYNAoKMDJmtowYpaNBt9AAfi1YCthrX5sChGaSEj8dshq0rJJGaAjHJTusnfCMWb9J/0WFmAO6LynbdRczVeEHjUHlj+pHu2+wOeHvLvCHcoawVUN7F/bpCWh3XuFGsZ9fiVrxt6ThcnbOSsQG9TyfS+TpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788363; c=relaxed/simple;
	bh=79pAvz2IJlHj3Y0RV23vNVmACRVLEjnYXYwNrHmIAuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO8JtpXrQt5fWa1yu20UUbk8FrFMm5XAjxM6AdpIg71aqL01iuCtyeupgxa/3rHz1AOkbxuWN+1DU2lzkWbYnGLbvWzd7y3pTVU3rcbFluZhm7FCdhCoOe20KyoAz0e65kYm8Sg+U8/73P+U3gGsV8dtN/9T/JKviGkqmpWB7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqP8Dpog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqP8Dpog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203C71F00899;
	Wed, 30 Sep 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788362;
	bh=4rU8QWXhLZABf36AKdf1fZsewIvRxurmGsmZqrkM8hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqP8Dpog81SEbt57piiQ8JZo71et4uAURIIMTfxnCHHibpX5rI4vPN2IIqrfh1dYs
	 Xw5nkcYQtGRDyj2eH3bEUx+awtZyv+YCa+iunRwqbU1Sb+nyeXlsETlk7+ntlLbGsp
	 VUEOQMQdIa0TU0A4pmuOoiIAkyZTwefE9iyYoaO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/877] neighbour: Convert RTM_GETNEIGH to RCU.
Date: Wed, 30 Sep 2026 17:16:48 +0200
Message-ID: <20260930152416.829602565@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit ed6e380d2d419a3e8ca73de7b4c7ccb522835f1e ]

Only __dev_get_by_index() is the RTNL dependant in neigh_get().

Let's replace it with dev_get_by_index_rcu() and convert RTM_GETNEIGH
to RCU.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250716221221.442239-10-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0dc0ba5cf7443..50a18ae55409e 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3010,27 +3010,29 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	if (!skb)
 		return -ENOBUFS;
 
+	rcu_read_lock();
+
 	tbl = neigh_find_table(ndm->ndm_family);
 	if (!tbl) {
 		NL_SET_ERR_MSG(extack, "Unsupported family in header for neighbor get request");
 		err = -EAFNOSUPPORT;
-		goto err_free_skb;
+		goto err_unlock;
 	}
 
 	if (nla_len(tb[NDA_DST]) != (int)tbl->key_len) {
 		NL_SET_ERR_MSG(extack, "Invalid network address in neighbor get request");
 		err = -EINVAL;
-		goto err_free_skb;
+		goto err_unlock;
 	}
 
 	dst = nla_data(tb[NDA_DST]);
 
 	if (ndm->ndm_ifindex) {
-		dev = __dev_get_by_index(net, ndm->ndm_ifindex);
+		dev = dev_get_by_index_rcu(net, ndm->ndm_ifindex);
 		if (!dev) {
 			NL_SET_ERR_MSG(extack, "Unknown device ifindex");
 			err = -ENODEV;
-			goto err_free_skb;
+			goto err_unlock;
 		}
 	}
 
@@ -3041,28 +3043,31 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		if (!pn) {
 			NL_SET_ERR_MSG(extack, "Proxy neighbour entry not found");
 			err = -ENOENT;
-			goto err_free_skb;
+			goto err_unlock;
 		}
 
 		err = pneigh_fill_info(skb, pn, pid, seq, RTM_NEWNEIGH, 0, tbl);
 		if (err)
-			goto err_free_skb;
+			goto err_unlock;
 	} else {
 		neigh = neigh_lookup(tbl, dst, dev);
 		if (!neigh) {
 			NL_SET_ERR_MSG(extack, "Neighbour entry not found");
 			err = -ENOENT;
-			goto err_free_skb;
+			goto err_unlock;
 		}
 
 		err = neigh_fill_info(skb, neigh, pid, seq, RTM_NEWNEIGH, 0);
 		neigh_release(neigh);
 		if (err)
-			goto err_free_skb;
+			goto err_unlock;
 	}
 
+	rcu_read_unlock();
+
 	return rtnl_unicast(skb, net, pid);
-err_free_skb:
+err_unlock:
+	rcu_read_unlock();
 	kfree_skb(skb);
 	return err;
 }
@@ -3876,7 +3881,7 @@ static const struct rtnl_msg_handler neigh_rtnl_msg_handlers[] __initconst = {
 	{.msgtype = RTM_NEWNEIGH, .doit = neigh_add},
 	{.msgtype = RTM_DELNEIGH, .doit = neigh_delete},
 	{.msgtype = RTM_GETNEIGH, .doit = neigh_get, .dumpit = neigh_dump_info,
-	 .flags = RTNL_FLAG_DUMP_UNLOCKED},
+	 .flags = RTNL_FLAG_DOIT_UNLOCKED | RTNL_FLAG_DUMP_UNLOCKED},
 	{.msgtype = RTM_GETNEIGHTBL, .dumpit = neightbl_dump_info},
 	{.msgtype = RTM_SETNEIGHTBL, .doit = neightbl_set},
 };
-- 
2.53.0



