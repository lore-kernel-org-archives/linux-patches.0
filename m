Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B24B7A30;
	Thu, 17 Sep 2026 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671566; cv=none; b=TgtXlOn20uDURuD1Xw+PiIlKqsPPSrS4cy0mzT6dO0no/22SISrFItaFrKbJ9q0ORyTq1id/7J9ZDeTG9BnjWBuDhqKUR+7sAZsYXU7mQgxkUygpHU4v35unmCVAkAcw3L+fyLFZ8SjnsERNlHYA9sCtFnPlrZ+JQkAnqSNYOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671566; c=relaxed/simple;
	bh=f52Vj8cfEIrP6SUWkg5nd+ar++1MMomyUB4DWyhaUgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwPfzbyOIvHj4sa6ma79BsGZKJTHoFWWDkTlmzDJsAiKlWHlSgiQgGxH65afPut4Ydjx0ctEF86Ewt2InJjSKbwvX27JkitU5wGEYq4TXjP8nOhZmnE9PVgDlGxj0JHggixNbPWOfTsR+N6rOI7hayddOqywbSnClXlsw1AC8G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPxb6GUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPxb6GUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5591F0089F;
	Thu, 17 Sep 2026 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671564;
	bh=azYXjfCSxP4sVyRgIY/Id5QCkywA0a6b61ZZksQ2HGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPxb6GUpmtPEdtUzXCb6HK5Y+OdfyZcLXvjJV5BFNd9jqNAf8HcYiQpSlgpHPBRmC
	 Bc91jfBimZySgDd0Bq8nNDJi6KU6D091jw7/+BhgU+fxkj0eh++Mpe0BRYhRTlfyKv
	 UYbozTFZDD55h2SHKs5ovKefcTX0cGIU//t0KMC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1019/1102] nfsd: validate sockaddr length per family in listener_set
Date: Thu, 17 Sep 2026 16:16:02 +0100
Message-ID: <20260917151606.338348444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bdcc85c2b05a9378d8bd2d65f9fc41440a3cf464 ]

nfsd_sock_nl_policy declares NFSD_A_SOCK_ADDR as a bare NLA_BINARY
attribute with no minimum length. A CAP_NET_ADMIN caller can send a
16-byte NFSD_A_SOCK_ADDR with sa_family=AF_INET6, causing a 12-byte
OOB read across three consumers (rpc_cmp_addr_port, svc_find_listener,
kernel_bind).

nfsd_nl_listener_set_doit() also parsed and validated each listener
entry inline in two separate loops, interleaved with mutating the
running listener configuration. The validation was duplicated, used an
open-coded "nla_len < sizeof(struct sockaddr)" check that was too short
for AF_INET6, and handled a malformed entry inconsistently depending on
which loop noticed it.

Add an nfsd_nl_validate_listeners() helper that walks the entire list
once and confirms each entry parses, carries both an address and a
transport name, and is long enough for its address family
(sizeof(struct sockaddr_in) for AF_INET, sizeof(struct sockaddr_in6)
for AF_INET6, -EAFNOSUPPORT otherwise). Call it before taking
nfsd_mutex or creating the serv, so a malformed request fails cleanly
with no side effects.

Since every entry is known valid by the time the two existing loops
run, drop the redundant presence and per-family length checks from
both, leaving only the nla_parse_nested() call needed to extract the
data.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260615-nfsd-testing-v5-1-188d75aedda0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 12 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1959,6 +1959,60 @@ err_free_msg:
 }
 
 /**
+ * nfsd_nl_validate_listeners - sanity-check the listener list from userland
+ * @info: netlink metadata and command arguments
+ *
+ * Walk every NFSD_A_SERVER_SOCK_ADDR attribute and confirm that each entry
+ * is well-formed: it parses against the policy, carries both an address and
+ * a transport name, and the address is long enough for its family. Doing
+ * this up front lets the callers below assume every entry is valid and
+ * guarantees we make no changes when the request is malformed.
+ *
+ * Return: 0 if every entry is valid, or a negative errno otherwise.
+ */
+static int nfsd_nl_validate_listeners(struct genl_info *info)
+{
+	const struct nlattr *attr;
+	int rem;
+
+	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
+				 GENL_HDRLEN, rem) {
+		struct nlattr *tb[NFSD_A_SOCK_MAX + 1];
+		struct sockaddr *sa;
+		int err;
+
+		err = nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
+				       nfsd_sock_nl_policy, info->extack);
+		if (err < 0)
+			return err;
+
+		if (!tb[NFSD_A_SOCK_ADDR] || !tb[NFSD_A_SOCK_TRANSPORT_NAME])
+			return -EINVAL;
+
+		sa = nla_data(tb[NFSD_A_SOCK_ADDR]);
+		if (nla_len(tb[NFSD_A_SOCK_ADDR]) < sizeof(sa->sa_family))
+			return -EINVAL;
+
+		switch (sa->sa_family) {
+		case AF_INET:
+			if (nla_len(tb[NFSD_A_SOCK_ADDR]) <
+			    sizeof(struct sockaddr_in))
+				return -EINVAL;
+			break;
+		case AF_INET6:
+			if (nla_len(tb[NFSD_A_SOCK_ADDR]) <
+			    sizeof(struct sockaddr_in6))
+				return -EINVAL;
+			break;
+		default:
+			return -EAFNOSUPPORT;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * nfsd_nl_listener_set_doit - set the nfs running sockets
  * @skb: reply buffer
  * @info: netlink metadata and command arguments
@@ -1976,6 +2030,15 @@ int nfsd_nl_listener_set_doit(struct sk_
 	bool delete = false;
 	int err, rem;
 
+	/*
+	 * Validate the entire listener list before making any changes, so a
+	 * malformed request fails cleanly without creating a serv or touching
+	 * the existing listeners.
+	 */
+	err = nfsd_nl_validate_listeners(info);
+	if (err)
+		return err;
+
 	mutex_lock(&nfsd_mutex);
 
 	err = nfsd_create_serv(net);
@@ -2002,16 +2065,11 @@ int nfsd_nl_listener_set_doit(struct sk_
 		const char *xcl_name;
 		struct sockaddr *sa;
 
+		/* validated up front in nfsd_nl_validate_listeners() */
 		if (nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
 				     nfsd_sock_nl_policy, info->extack) < 0)
 			continue;
 
-		if (!tb[NFSD_A_SOCK_ADDR] || !tb[NFSD_A_SOCK_TRANSPORT_NAME])
-			continue;
-
-		if (nla_len(tb[NFSD_A_SOCK_ADDR]) < sizeof(*sa))
-			continue;
-
 		xcl_name = nla_data(tb[NFSD_A_SOCK_TRANSPORT_NAME]);
 		sa = nla_data(tb[NFSD_A_SOCK_ADDR]);
 
@@ -2063,16 +2121,11 @@ int nfsd_nl_listener_set_doit(struct sk_
 		struct sockaddr *sa;
 		int ret;
 
+		/* validated up front in nfsd_nl_validate_listeners() */
 		if (nla_parse_nested(tb, NFSD_A_SOCK_MAX, attr,
 				     nfsd_sock_nl_policy, info->extack) < 0)
 			continue;
 
-		if (!tb[NFSD_A_SOCK_ADDR] || !tb[NFSD_A_SOCK_TRANSPORT_NAME])
-			continue;
-
-		if (nla_len(tb[NFSD_A_SOCK_ADDR]) < sizeof(*sa))
-			continue;
-
 		xcl_name = nla_data(tb[NFSD_A_SOCK_TRANSPORT_NAME]);
 		sa = nla_data(tb[NFSD_A_SOCK_ADDR]);
 


