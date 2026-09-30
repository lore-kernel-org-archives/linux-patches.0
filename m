Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E7A4F405E;
	Wed, 30 Sep 2026 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790200; cv=none; b=ESftBEh4KtZj5HPV2CDbo3xlRi6MUleA+ziYZMqXz5iLU5UTVwrbATdrZF6acRuW+hzqGm35k8k0SIo8nN4G9jTSeRxL9H97XNx6nJwFAlPH6vWVW6nIbSxzMml8uc99g4nm+Q4jp8zuaBolRPSPqDrUSYqiqGb2+GaYJ9ICk9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790200; c=relaxed/simple;
	bh=yShpSY4rY0W+ovkJjqL8C/Hbh/ze5HZ6MNHIVzHqLMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMF4WifwqKTtvOVQOG1w+Bo/MPAgNcVSWcWOvmlgiFbzC8GXhe/xBgCWDSyCBXIvUuVcM91ZzYunlEN0tlugvSXt4MuXJWs123WH8ZgW9kNIYXo0BmARmUBB8jTN7Cgm+45m9kDrffT0QVVGt518GPmZdZfRgnZlMmB6YF1DHm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXapgn79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXapgn79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4191F0089A;
	Wed, 30 Sep 2026 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790199;
	bh=jDS+t1FBiWBUtsYSAUrKAriyvItm6NOvO3+BGcFOWkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXapgn79J7XIIke7X7wJgMjFoog07Kg7dz1Yd4Eyw0rjhJmRtv0u/OBHdgI3DjpEU
	 x3N4YqKq9CcG56wKq790hcenJPw9rc2dZFmH/pmd2qgMXkq0mfx/1rZE8gEEJWTr0m
	 HBl2Vparm+G6oFe+zQlhIB0Cc7Hy2/oLP6G0w/8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 746/877] ipv4: remove fib_devindex_hashfn()
Date: Wed, 30 Sep 2026 17:27:37 +0200
Message-ID: <20260930152430.793210817@linuxfoundation.org>
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

[ Upstream commit 8a0f62fdeb9ea66ad3d0e959c7c4addbabeac1be ]

fib_devindex_hashfn() converts a 32bit ifindex value to a 8bit hash.

It makes no sense doing this from fib_info_hashfn() and
fib_find_info_nh().

It is better to keep as many bits as possible to let
fib_info_hashfn_result() have better spread.

Only fib_info_devhash_bucket() needs to make this operation,
we can 'inline' trivial fib_devindex_hashfn() in it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20241004134720.579244-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -322,17 +322,12 @@ static inline int nh_comp(struct fib_inf
 	return 0;
 }
 
-static inline unsigned int fib_devindex_hashfn(unsigned int val)
-{
-	return hash_32(val, DEVINDEX_HASHBITS);
-}
-
 static struct hlist_head *
 fib_info_devhash_bucket(const struct net_device *dev)
 {
 	u32 val = net_hash_mix(dev_net(dev)) ^ dev->ifindex;
 
-	return &fib_info_devhash[fib_devindex_hashfn(val)];
+	return &fib_info_devhash[hash_32(val, DEVINDEX_HASHBITS)];
 }
 
 static unsigned int fib_info_hashfn_1(int init_val, u8 protocol, u8 scope,
@@ -363,10 +358,10 @@ static inline unsigned int fib_info_hash
 				fi->fib_priority);
 
 	if (fi->nh) {
-		val ^= fib_devindex_hashfn(fi->nh->id);
+		val ^= fi->nh->id;
 	} else {
 		for_nexthops(fi) {
-			val ^= fib_devindex_hashfn(nh->fib_nh_oif);
+			val ^= nh->fib_nh_oif;
 		} endfor_nexthops(fi)
 	}
 
@@ -381,7 +376,7 @@ static struct fib_info *fib_find_info_nh
 	struct fib_info *fi;
 	unsigned int hash;
 
-	hash = fib_info_hashfn_1(fib_devindex_hashfn(cfg->fc_nh_id),
+	hash = fib_info_hashfn_1(cfg->fc_nh_id,
 				 cfg->fc_protocol, cfg->fc_scope,
 				 (__force u32)cfg->fc_prefsrc,
 				 cfg->fc_priority);


