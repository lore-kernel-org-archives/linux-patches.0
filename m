Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C655293E9;
	Wed, 23 Sep 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172737; cv=none; b=U/sAGFqx8Lu9ds5YccaoOEd9u7swKba5oQHkNsDUUkanbDZD6PHCciTxjwilt2hrLXkn8xN0qA632TnqT5eNv7XDoYa4N6wibFmkRUjr3U0TAD4d3fAsc4rzDncGsTYLjsiVCrJiyw8SOQh/4cuhcxcjEfllp2HQQge55o+B4Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172737; c=relaxed/simple;
	bh=GmjZHXUik1z9XSUED2AVMJBYWvBTKXIOVldX7pXKRwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbEST4tr0gD+W8+9gCRpnL43yAwoxvfOW/G8CduzSOkwT+uSY2yNxfINe2D8KOs43AQAtDpndh09BXN/c3zzwIhwYhaAMgKzJWpxJcIiGGNoEHWQYw8Q8SVRroCJz9Ea4q3Bs++/95KiGlm5qtkAKQvcxPSD248mxpXfFkbfTfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkA9WlIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkA9WlIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3431F000FF;
	Wed, 23 Sep 2026 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172735;
	bh=9RRh8R9pPWj+eotXyC/b3XzSHehWSA7F8ui9jzL2mVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkA9WlIWH9FqkbS1qxZUlbZMv4yt1Q7L800qoHnloyW0QjGmgKz5w9sm/UaDlrXdN
	 +xtJ4W8on0vYogeeK9fqlV1Un/nO7PVxoqScYJyYhyZddXiF9OEEjJWujU39JI7zAY
	 HOXfx0CbiiGH7V0+IAoiLEdD6IAQmSa4blz7jCgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 020/438] xfrm: hold net_device reference under RCU in bundle creation
Date: Wed, 23 Sep 2026 16:00:41 +0200
Message-ID: <20260923140645.298801344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

[ Upstream commit 9fa903b24b1f46b4ff5443bcd4aca23e5c57f9c1 ]

xfrm_bundle_create() and xfrm_create_dummy_bundle() read dst->dev into
a local pointer without taking a device reference, then pass it to
xfrm_fill_dst(). A concurrent RTM_DELLINK replaces dst->dev via
dst_dev_put() and frees the old net_device, causing a use-after-free
when xfrm6_fill_dst() later dereferences the stale dev pointer.

  BUG: KASAN: slab-use-after-free in xfrm6_fill_dst+0x82c/0x860
  (net/ipv6/xfrm6_policy.c:86 netdev_hold())
  Read of size 8 at addr ffff8880142fe588 by task exploit/153
  Call Trace:
   xfrm6_fill_dst+0x82c/0x860
   xfrm_resolve_and_create_bundle+0x21d4/0x2bd0
   xfrm_lookup_with_ifid+0x485/0x1640
   ip6_dst_lookup_flow+0x19b/0x1e0
   udpv6_sendmsg+0x1443/0x2dd0

Fix this by reading dst->dev via dst_dev_rcu() and keeping the RCU
read-side critical section active until xfrm_fill_dst() has taken the
required device references.

Fixes: 25ee3286dcbc ("[IPSEC]: Merge common code into xfrm_bundle_create")
Fixes: a0073fe18e71 ("xfrm: Add a state resolution packet queue")
Suggested-by: Steffen Klassert <steffen.klassert@secunet.com>
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Link: https://lore.kernel.org/all/20260820200245.44312-1-blbllhy@gmail.com/
Cc: AutonomousCodeSecurity@microsoft.com
Assisted-by: GitHub-Copilot:claude-opus-4.6
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 932a313b9460a..513c9f2283347 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2770,9 +2770,12 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 	xdst0->path = dst;
 
 	err = -ENODEV;
-	dev = dst->dev;
-	if (!dev)
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	if (!dev) {
+		rcu_read_unlock();
 		goto free_dst;
+	}
 
 	xfrm_init_path(xdst0, dst, nfheader_len);
 	xfrm_init_pmtu(bundle, nx);
@@ -2780,8 +2783,10 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 	for (xdst_prev = xdst0; xdst_prev != (struct xfrm_dst *)dst;
 	     xdst_prev = (struct xfrm_dst *) xfrm_dst_child(&xdst_prev->u.dst)) {
 		err = xfrm_fill_dst(xdst_prev, dev, fl);
-		if (err)
+		if (err) {
+			rcu_read_unlock();
 			goto free_dst;
+		}
 
 		xdst_prev->u.dst.header_len = header_len;
 		xdst_prev->u.dst.trailer_len = trailer_len;
@@ -2789,6 +2794,7 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 		trailer_len -= xdst_prev->u.dst.xfrm->props.trailer_len;
 	}
 
+	rcu_read_unlock();
 	return &xdst0->u.dst;
 
 put_states:
@@ -3058,11 +3064,15 @@ static struct xfrm_dst *xfrm_create_dummy_bundle(struct net *net,
 	xfrm_init_path((struct xfrm_dst *)dst1, dst, 0);
 
 	err = -ENODEV;
-	dev = dst->dev;
-	if (!dev)
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	if (!dev) {
+		rcu_read_unlock();
 		goto free_dst;
+	}
 
 	err = xfrm_fill_dst(xdst, dev, fl);
+	rcu_read_unlock();
 	if (err)
 		goto free_dst;
 
-- 
2.53.0



