Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590822;
	b=2ZfCUXRRzOdUci6vXLziSKcMK5nwYqBqMF784F0ylEFFNPZEe0mcDec/RkI0wXanYXJm
	 Xj1NBvGXZAej8BAcg/Yj3xrZFF76keVOvYeGdatZp1m9yBEs+z6W5+HZ6+fqi5hgh6+kt
	 ES942z7F2U7Dr8iAV3VwWmrr/k6YkK6jbWad70/iPFvymSBU9GpMOYTqfC3wJQhRujOwl
	 vEfjbOlq9Ley5I64sMAhSBbZxzygZwG6CUqS521EkCElOzdbnGx5eKx9XPDdfb+Thgaew
	 ptluDCtPsHF2n6au/VUuQo2r4uNpVoUU17323t8SPrD08uIpfgHT5GTzWdjunGYU/Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pF4IrFA4X+YvAo7ynsOUCg/MPrCpBE9jiVU2uZG+AtY=;
	b=yLlLGSuv1HxKa+sPCQX4IIhSRstsMeceq6ABI2HOeFK0uoHG2SEHBE0ad9J7yeZNlr3Q
	 /gJY028GrHpxxjWbqMP9RuKKJiNyWhXRQ1exhFscf+zKD6uLCljc3h/JkeW7/Pwd0X4uR
	 bvJYmK6FN5ckH+rUDaO6fXWfZDKKzcsvRIdVnIpVRI45hu/z5BieUqBgPG4/FOJgDtKcz
	 XkxL+ELA0uJ+JIeLpGH3YPCWVQyfylwyHrthVV/nNgWgaP4twVVI2uDyOSvLMEZXt6WiA
	 1HHRCEkkRlidG0An+TB2L2yRGaJGFSrdK7S+QfdX3xln/Dkq0//qa2SHmTebc2xDFtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVCnYjX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484EA607E053;
	Fri, 13 Nov 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVCnYjX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72B31F000C4;
	Fri, 13 Nov 2026 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590822;
	bh=pF4IrFA4X+YvAo7ynsOUCg/MPrCpBE9jiVU2uZG+AtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVCnYjX0liw42utDgBn30CCPfC8Us74oL42cBu6ZLXKreSHOnXapJfnV9oUaGMF62
	 KZo3N/RGhCDRXoLt5fsjlzgl1nR8rHqCs3UvKikd2orcA+pjzh14xTfEIuxEdFZLSO
	 DlPmq1V/Zb7CYOHgaeaWJmCYNUKNc7xgL/INI1Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/670] NFSD: stop registering with rpcbind after a failure in listener_set
Date: Fri, 13 Nov 2026 10:43:12 -0500
Message-ID: <20261113153812.131554528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bf0f3a37e6ccb78ae80cc6eb2edde4f033c7574c ]

nfsd_nl_listener_set_doit() calls svc_xprt_create_from_sa() once for each
requested listener and passes flags of 0, so every listener registers with
rpcbind on its own. A rpcbind that accepts the connection and never replies
therefore costs one timeout for each entry. With the cap of 1024 entries
the request can hold nfsd_mutex for about 34 minutes, which is roughly 17
times the hung-task threshold.

One failure is enough to know that the next call will not fare better.
Read svc_rpcb_failure_count() before the create loop, and pass
SVC_SOCK_ANONYMOUS for the rest of the request once the count moves.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Link: https://syzkaller.appspot.com/bug?extid=c7eae0eb80858a2dba0f
Suggested-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-10-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index ecfdd8e5fd3d3..6ca903922fe9b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2110,7 +2110,10 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 	const struct nlattr *bad_attr = NULL;
 	struct svc_xprt *xprt, *tmp;
 	const char *bad_xprt = NULL;
+	unsigned int rpcb_failures;
 	const struct nlattr *attr;
+	bool skipped_rpcb = false;
+	bool bad_rpcb = false;
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
 	struct nfsd_net *nn;
@@ -2200,13 +2203,16 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 	if (delete)
 		svc_xprt_destroy_all(serv, net);
 
+	rpcb_failures = svc_rpcb_failure_count(serv);
+
 	/* walk list of addrs again, open any that still don't exist */
 	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
 				 GENL_HDRLEN, rem) {
 		struct nlattr *tb[NFSD_A_SOCK_MAX + 1];
 		const char *xcl_name;
 		struct sockaddr *sa;
-		int ret;
+		bool hit_rpcb;
+		int flags, ret;
 
 		/* validated up front in nfsd_nl_validate_listeners() */
 		if (nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
@@ -2225,12 +2231,27 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 			continue;
 		}
 
-		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
+		flags = skipped_rpcb ? SVC_SOCK_ANONYMOUS : 0;
+		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, flags,
 					      current_cred());
+
+		hit_rpcb = false;
+		if (!skipped_rpcb &&
+		    svc_rpcb_failure_count(serv) != rpcb_failures) {
+			skipped_rpcb = true;
+			hit_rpcb = true;
+			if (ret < 0)
+				ret = svc_xprt_create_from_sa(serv, xcl_name,
+							      net, sa,
+							      SVC_SOCK_ANONYMOUS,
+							      current_cred());
+		}
+
 		/* always save the latest error */
 		if (ret < 0) {
 			bad_attr = attr;
 			bad_xprt = xcl_name;
+			bad_rpcb = hit_rpcb;
 			err = ret;
 		}
 	}
@@ -2242,8 +2263,21 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 	 */
 	if (err) {
 		NL_SET_BAD_ATTR(info->extack, bad_attr);
-		NL_SET_ERR_MSG_FMT(info->extack, "cannot create %s listener",
-				   bad_xprt);
+		if (bad_rpcb)
+			NL_SET_ERR_MSG_FMT(info->extack,
+					   "cannot create %s listener; rpcbind did not answer",
+					   bad_xprt);
+		else if (skipped_rpcb)
+			NL_SET_ERR_MSG_FMT(info->extack,
+					   "cannot create %s listener; rpcbind did not answer earlier, so some listeners are not registered",
+					   bad_xprt);
+		else
+			NL_SET_ERR_MSG_FMT(info->extack,
+					   "cannot create %s listener",
+					   bad_xprt);
+	} else if (skipped_rpcb) {
+		NL_SET_ERR_MSG(info->extack,
+			       "rpcbind did not answer, some listeners are not registered");
 	}
 
 	if (!serv->sv_nrthreads && list_empty(&nn->nfsd_serv->sv_permsocks))
-- 
2.53.0



