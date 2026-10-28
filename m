Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210778;
	b=4POp00U4zAIuq5UEMAte1AfqywP0I9+K4sUNJxDMmIMaWIPxXJcZ76rzZwpnnqOMhoV2
	 NIHstuzHW2jd5E6sEQo7nIeX3EgnZgF4Hl+kG98uuno+TbIl0TooDfieQzj/OsMoWXtnb
	 5IfffmVz4d21UVRrThkJD9CHkyvWWOMmlf/v6SZQ1gYDXXmKV9Kq8shU8sKZ3ulSO1TmJ
	 lb7pyOEJ3JK3ui1mpsoRf1DyrceJBswZhk2PM/X2WnYWvOMgwrTm9swU+XUS+R59ql0bp
	 yN7UiFli8KIJ1Z/K2zZVGk6j/I7y70cKh2SKLPXeJ104BQtJPepLMANf+XwkpFkcysQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOdxJmahu9pCb8fQoV/l55BrB2faxRZxFD9QZVZE0Dc=;
	b=1K764FVI6dN9IbPMBF22zbW7OjsXhBhNxgBeQzHYjYSncrmQEbf456JbBj9HuFEeyYpl
	 uVt/KjRWDHXh4TKTPqz0kezrD13aYPL/82rFwFAq7d/lUpWCvuVhU5a8yW/fA194r4PLn
	 Ay8Y74xbegJ5PyK0dl7YUYpPC4niqVS0+6wvCkh2oLM7YtyiNXOBhdvyoA3fST5TawzoJ
	 t8xh1EyMr9uP8H472nOuHZHvqJ9GFEtrvxuVR6H4CLLxr/wgSdutPKlmBPJF9ErfHqsdk
	 W3Kc9CSBbRbeYkET9m31wK+Y4XmEts/fIk5HDIhdXpzj+d/vQatXqtH+h1BQY8H8EVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umqKQZUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50A7606A31A;
	Wed, 28 Oct 2026 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umqKQZUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD71F01829;
	Wed, 28 Oct 2026 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210777;
	bh=HOdxJmahu9pCb8fQoV/l55BrB2faxRZxFD9QZVZE0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umqKQZUIaaIGwdukAWFzN8yVNv5xpNUbdxad+b+NaW6Kbt9bKhvXyKE2R2sTdRdAr
	 B7CAucqvBIYUt8oiv2RbEsRKCdh1LgVf2DpCnBJcGg34KesQBMFkRUWBeWRlR6p7Af
	 1gkYNg4xvrcj71v01PYTJzjAwljFfFxAKlzuomqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Xin Long <lucien.xin@gmail.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/571] openvswitch: add nf_ct_is_confirmed check before assigning the helper
Date: Wed, 28 Oct 2026 17:54:53 +0100
Message-ID: <20261028170011.480269653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3c1860543fccc1d0cfe3fd6b190e414a418fe60e ]

A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
applies on a confirmed connection:

  WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
  RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
  Call Trace:
   <TASK>
   nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
   __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
   __ovs_ct_lookup+0x72e/0x780 [openvswitch]
   ovs_ct_execute+0x1d8/0x920 [openvswitch]
   do_execute_actions+0x4e6/0xb60 [openvswitch]
   ovs_execute_actions+0x60/0x140 [openvswitch]
   ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
   genl_family_rcv_msg_doit.isra.15+0x113/0x150
   genl_rcv_msg+0xef/0x1f0

which can be reproduced with these OVS flows:

  table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
  actions=ct(commit, table=1)
  table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
  actions=ct(commit, alg=ftp),normal

The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
attaching helper in later commit") where it somehow removed the check
of nf_ct_is_confirmed before asigning the helper. This patch is to fix
it by bringing it back.

Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Tested-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index f0f0204a0e2b6..ff610c320c284 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1037,7 +1037,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 * connections which we will commit, we may need to attach
 		 * the helper here.
 		 */
-		if (info->commit && info->helper && !nfct_help(ct)) {
+		if (!nf_ct_is_confirmed(ct) && info->commit &&
+		    info->helper && !nfct_help(ct)) {
 			int err = __nf_ct_try_assign_helper(ct, info->ct,
 							    GFP_ATOMIC);
 			if (err)
-- 
2.53.0



