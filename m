Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BAD409103;
	Wed, 30 Sep 2026 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797056; cv=none; b=nTsOL21GOmmrhE7tYqciLhCeC3aWuygjNUdEHJZNOw8u3TWnPzNN79ydHQ+NGTouaNl89MYVYSXAu7Jfy7g6ndN/WyvzmosDPtkJ9vlbINZ7oSZwsy6OKAcPp7lGgk6r11omfav96tBQrVHFo92Qe2yMCFt8a3mMsvsUm8AIbhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797056; c=relaxed/simple;
	bh=jukgyE9NnrqtZfRcj2gntBya8qKsx+/8gW1hoGi+2Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umXvKgtL7/yX0625NbJd+21rJl41NwCY9vXCRA9MYDdoci8odxkzmpF7VrODTqoKhC5X3k59PuyZXJMcSxUjihvgsAg/GXu0Ly1dJUgSCJcS6lf5SifI4qY26cnKXJzgToGCH26UuzQsdiwx5O4RsFs0yC76YxDxPkeRK/lMkWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIqIefAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIqIefAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6081F000FF;
	Wed, 30 Sep 2026 19:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797054;
	bh=YpCJfoBsj8jRiBgNC8aTrVjDMKsYarH0iSfK7D/PRC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIqIefATRcXI6sDBqmckE28cHcH2F7H1qcVYM67LfyiP8wy6Gw0dAlsTlVXKoEzAG
	 MOdSzK5GIHwgZajYiCx/MP/Bf1EA8Zf7m7Io4i6D4qD5xXgevUkRZM3VzzkDfmFw0G
	 ssAC1Ibl4/QN2lq14QmQh2KK5xVhwRarRdOvgrrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1130/1193] net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry
Date: Wed, 30 Sep 2026 17:30:14 +0200
Message-ID: <20260930152459.344558739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 26b2bd70d22457556e2fa01cbf1192cb1a94d619 upstream.

In a case where skb with an unconfirmed ct entry gets cloned, we may
end up committing both but with different sets of extensions.

The series of events:

 1. The first clone wants to commit and runs the helpers wiring up
    the extension pointer into the expectation list.
 2. Then it looses the confirmation keeping the entry unconfirmed.
 3. Second clone now wants to commit labels and adds the new extension
    for that breaking the pointer in the expectation list causing
    UAF on the destruction path later.

While this is possible to trigger, there should be no practical
network pipeline where committing both clones without modifications
into the same zone is needed.  So, let's just reset the entry in case
for some reason we got an skb with a shared one during commit.  This
doesn't affect any known use cases, but avoids any potential problems
with sharing and modification of the unconfirmed ct entry.

The fixes tag points to the introduction of helpers, since that's the
main UAF trigger for the sharing.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_conntrack.h |    5 +++++
 net/openvswitch/conntrack.c          |   12 ++++++++++++
 2 files changed, 17 insertions(+)

--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -190,6 +190,11 @@ static inline void nf_ct_put(struct nf_c
 		nf_ct_destroy(&ct->ct_general);
 }
 
+static inline bool nf_ct_shared(const struct nf_conn *ct)
+{
+	return refcount_read(&ct->ct_general.use) > 1;
+}
+
 /* load module; enable/disable conntrack in this namespace */
 int nf_ct_netns_get(struct net *net, u8 nfproto);
 void nf_ct_netns_put(struct net *net, u8 nfproto);
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -716,6 +716,18 @@ static int __ovs_ct_lookup(struct net *n
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
+	/* If the ct entry is not confirmed and shared with some other skb,
+	 * e.g., a cloned one, we can't just modify it with the commit as we
+	 * must not modify the extension set.  Reset.
+	 */
+	if (cached && info->commit) {
+		ct = nf_ct_get(skb, &ctinfo);
+		if (ct && !nf_ct_is_confirmed(ct) && nf_ct_shared(ct)) {
+			nf_reset_ct(skb);
+			cached = false;
+		}
+	}
+
 	if (!cached) {
 		struct nf_hook_state state = {
 			.hook = NF_INET_PRE_ROUTING,


