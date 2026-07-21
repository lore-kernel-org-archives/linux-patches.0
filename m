Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E52F269CE6;
	Tue, 21 Jul 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656826; cv=none; b=VHz0GnwRJyLOCN1hmjZULZ1QFjlpeUembFjK43AqqrKbgbvNKzwvdoWOGOjdnojpwKh1x4OJVesu5+J0Llwg3lb04EXnfReaPxLG6M8DjU5ZqRYKcy/007ePzMfHSetqDBvWgc6zKhkUMogMbCmLRyvxVLaHEeO+Teq0/v+4Apw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656826; c=relaxed/simple;
	bh=FiYXGNXYtXHT66+v5B9WIY/OTIRyvZfH+5kPCyutgRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTuN4rP3uFXvaeRRzNoAwPLyR1g1xx8cv8lZt7MFHTIRcDha5ekv7508VZhfYfJOsebSBGkMLOOZSH5zejc2XYmVqDL/uAUgX+qW7qpCob1jcCRmDvB2ycmqvV2sYuviFPcayDM1NklaqRY5C4QxixsMZVFgmxsMGrAGdi+gv3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCUouany; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCUouany"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE66B1F00A3A;
	Tue, 21 Jul 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656825;
	bh=/CejBzpkISPO/Bt/4qaqheRr9QBEtY/ts7eifHkHZbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCUouanyTBE9eSkGvspnnO75aRhKEf8p8y5WiDgeBcvWI85c/GrleHs4dG8Vf06js
	 t7xLTjkTkTJiG3QNScAzUlWgBaI7IbdjzbrCfKpGcU9OJ2J8WhKvj+ZcxMDTE6Bq/b
	 KOP3P1jb2PkxbjaPSsW/+iN9NsY8KuHoVO9ULWd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0533/1611] netfilter: nf_conncount: callers must hold rcu read lock
Date: Tue, 21 Jul 2026 17:10:49 +0200
Message-ID: <20260721152527.345109736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 64d7d5abe2160bba369b4a8f06bdf5630573bab0 ]

rcu_derefence_raw() should not have been used here, it concealed this bug.
Its used because struct rb_node lacks __rcu annotated pointers, so plain
rcu_derefence causes sparse warnings.

The major tradeoff is that rcu_derefence_raw() doesn't warn when the caller
isn't in a rcu read section.

Extend the rcu read lock scope accordingly and cause sparse warnings,
those warnings are the lesser evil.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Closes: https://sashiko.dev/#/patchset/20260603230610.7900-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 6 +++---
 net/openvswitch/conntrack.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 14e62b3263cd94..e880e4b3cd82d4 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -499,7 +499,7 @@ count_tree(struct net *net,
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference_raw(root->rb_node);
+	parent = rcu_dereference(root->rb_node);
 	while (parent) {
 		int diff;
 
@@ -507,9 +507,9 @@ count_tree(struct net *net,
 
 		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
-			parent = rcu_dereference_raw(parent->rb_left);
+			parent = rcu_dereference(parent->rb_left);
 		} else if (diff > 0) {
-			parent = rcu_dereference_raw(parent->rb_right);
+			parent = rcu_dereference(parent->rb_right);
 		} else {
 			int ret;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a0811e1fba6563..f63c8ac74e4a88 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1800,10 +1800,10 @@ static int ovs_ct_limit_get_zone_limit(struct net *net,
 		} else {
 			rcu_read_lock();
 			limit = ct_limit_get(info, zone);
-			rcu_read_unlock();
 
 			err = __ovs_ct_limit_get_zone_limit(
 				net, info->data, zone, limit, reply);
+			rcu_read_unlock();
 			if (err)
 				return err;
 		}
-- 
2.53.0



