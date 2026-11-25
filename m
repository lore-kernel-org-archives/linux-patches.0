Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623827;
	b=bw1LiWWr2wVOw42Z6MzyneDu/x4/ZnXxkH7dMsuWNmlSUprurTUt6SDusfM5alMBnqpJ
	 5apq2osI+Q42/ns20ku32BnvF9rNTNIPh4Yc8gPcgMtlczfjYZA/EGkjJqgmUoRSfhXTK
	 JtIDBVdLYjMTvz+w+mLnqc6IilbjoSkZ98lFXbhvahz42ztIvGJLTkndG5MyL0Csqv0Zi
	 Z+56QHIy4Pej/W/vDaq6rO/UIYbEyxz9T4GFCPH6CBM8HRlth6Vua8Oc7Nb0bmkhGS65o
	 apqg0O8fV9sU6HsOVJZdUfL0oeJN5EvL1KRlhC8VBYZpASVM1esNn3iihlT+SCITu0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fiNarr2gdX4FHSTvylPckE6px7OsLazt7z2UJ5GPdIU=;
	b=OBrWBwojaJHmC8ZhHMymDuIpae1mwUbyVn2DWLpLI0n2+WagA69GkyVTnHr9r+3pdFrd
	 t8tznZnBi61BlxsR763Kn/iA1zXOBWQVylyRR3fc+PjxXSfT/v1gkG/Ky/HGU9x/omjEe
	 wLB5mO9YiMRSFPGbDlbyePkKFvYi8IDZxRK50GOdE7QPVIBS/QAAeJtfz6kGLBD/57QQA
	 VPfuIDnKt2Y/5FEn8phHWu13EUnpGViyAROieW82Im6vaukNKTt/vsUttCcpCPCLFVyCV
	 XhyLMQ8FyMltVM5hxbyKnkp3IiiVQI9VYFlfGKOe68+SnXZdEjtFs/PrdPx9m9yNiig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGN2DCCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E332606A31E;
	Wed, 25 Nov 2026 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGN2DCCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18551F000C0;
	Wed, 25 Nov 2026 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623827;
	bh=fiNarr2gdX4FHSTvylPckE6px7OsLazt7z2UJ5GPdIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGN2DCCnuQsQhSW2dH7CFuoOlk/IZzSClOXM9dFty+6fFmZQzJAnuHFlJwq14gF7d
	 Q+khKgPLHv0uaBcL/wVXO2DzWp0kG16Nwk99sU0FI+oF24v3Za8SuDSbSgiEqw3T3k
	 VgaujkEuJG/emqCCYXGwi9qJY3MSt5YLQbNyg4Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>
Subject: [PATCH 6.18 985/990] xfrm: hold net_device reference under RCU in bundle creation
Date: Wed, 25 Nov 2026 15:39:12 +0100
Message-ID: <20261125143845.050775826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 9fa903b24b1f46b4ff5443bcd4aca23e5c57f9c1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2777,9 +2777,12 @@ static struct dst_entry *xfrm_bundle_cre
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
@@ -2787,8 +2790,10 @@ static struct dst_entry *xfrm_bundle_cre
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
@@ -2796,6 +2801,7 @@ static struct dst_entry *xfrm_bundle_cre
 		trailer_len -= xdst_prev->u.dst.xfrm->props.trailer_len;
 	}
 
+	rcu_read_unlock();
 	return &xdst0->u.dst;
 
 put_states:
@@ -3065,11 +3071,15 @@ static struct xfrm_dst *xfrm_create_dumm
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
 


