Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E0551AEEE;
	Wed, 30 Sep 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788355; cv=none; b=Bhyg3zbQFDJ1KXn3HYgvDqYFIkbiApmSCnagJRt02y3D0YUrdnHi/M/V0kS+OLE0Xb4a6Il+XuHm1mBDtRkvne/kYfXqVH7XpyqlrewdI0je1k02DOJ43yicINQ+X899Qak+11h5xPNsoPdSB6sC8+YPCAKC5rzykRsR5fPzG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788355; c=relaxed/simple;
	bh=zAhstgf7EKo0IOiBJwJqgoJomNpQ2eWudGxAGj6RaWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jczum6jJfUkNe8BzCQnjOWZZeUP7l8RXFuE8wLZxe7p8orhYTz1qNz3p0wOpTlnws3jYkpBlW2RX72wxu+vu/5834cvA5yxqwEGqtalq9asg2/NQYYwEcJe4/Uc5EeOu1GbAgOSB+gJvTfBemUchCCtGyNvNVm0WtnLfxmAExro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/Ur9Fps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/Ur9Fps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF6F1F00898;
	Wed, 30 Sep 2026 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788354;
	bh=LcCWIxkYdpspxu3oHGxkfJ0xtsB4aSWHzofVXtFU+oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/Ur9FpsAHrpKOXCR9OGE1pYLMIH1Rm9rUgciCnQPK+Q4y0j3eL1pwiVfFz+xFdcI
	 wwPhGaextcyVdX8ozadCT4WqxrY2B0UlYHn5vgffjPQdyR/eyjHgB54EcSGUpsBtuu
	 /tFAmsN5J++2NX3Rqk2GRXU9IecXkQzWR4JsJTAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/877] neighbour: Move two validations from neigh_get() to neigh_valid_get_req().
Date: Wed, 30 Sep 2026 17:16:45 +0200
Message-ID: <20260930152416.764836761@linuxfoundation.org>
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

[ Upstream commit f5046fbc1b6d8c5168d47a617f368f9d4a025e34 ]

We will remove RTNL for neigh_get() and run it under RCU instead.

neigh_get() returns -EINVAL in the following cases:

  * NDA_DST is not specified
  * Both ndm->ndm_ifindex and NTF_PROXY are not specified

These validations do not require RCU.

Let's move them to neigh_valid_get_req().

While at it, the extack string for the first case is replaced with
NL_SET_ERR_ATTR_MISS().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250716221221.442239-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index fe921f8cc81c1..ecfa1cc2f85f2 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2936,6 +2936,11 @@ static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!(ndm->ndm_flags & NTF_PROXY) && !ndm->ndm_ifindex) {
+		NL_SET_ERR_MSG(extack, "No device specified");
+		return ERR_PTR(-EINVAL);
+	}
+
 	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg), tb,
 					    NDA_MAX, nda_policy, extack);
 	if (err < 0)
@@ -2948,11 +2953,13 @@ static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
 	}
 
 	for (i = 0; i <= NDA_MAX; ++i) {
-		if (!tb[i])
-			continue;
-
 		switch (i) {
 		case NDA_DST:
+			if (!tb[i]) {
+				NL_SET_ERR_ATTR_MISS(extack, NULL, NDA_DST);
+				return ERR_PTR(-EINVAL);
+			}
+
 			if (nla_len(tb[i]) != (int)(*tbl)->key_len) {
 				NL_SET_ERR_MSG(extack, "Invalid network address in neighbor get request");
 				return ERR_PTR(-EINVAL);
@@ -2960,6 +2967,9 @@ static struct ndmsg *neigh_valid_get_req(const struct nlmsghdr *nlh,
 			*dst = nla_data(tb[i]);
 			break;
 		default:
+			if (!tb[i])
+				continue;
+
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in neighbor get request");
 			return ERR_PTR(-EINVAL);
 		}
@@ -3052,11 +3062,6 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	if (!dst) {
-		NL_SET_ERR_MSG(extack, "Network address not specified");
-		return -EINVAL;
-	}
-
 	if (ndm->ndm_flags & NTF_PROXY) {
 		struct pneigh_entry *pn;
 
@@ -3069,11 +3074,6 @@ static int neigh_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 					nlh->nlmsg_seq, tbl);
 	}
 
-	if (!dev) {
-		NL_SET_ERR_MSG(extack, "No device specified");
-		return -EINVAL;
-	}
-
 	neigh = neigh_lookup(tbl, dst, dev);
 	if (!neigh) {
 		NL_SET_ERR_MSG(extack, "Neighbour entry not found");
-- 
2.53.0



