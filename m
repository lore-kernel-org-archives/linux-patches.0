Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0287C44CF4E;
	Tue, 16 Jun 2026 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624754; cv=none; b=R68lXQLgoL9qc1UxtXF9otYDWwuji15B2ad4IFFWONCWgmPNxjuj1cS6SPnljBx2hIT6luD/PJDJlAw+MXEgC9JSRJZ5hTwEpf4frgZDGWuyu1X5niX6fQAxG08o74UIMvnGPQPKthhyl6Q89KIibt3xcTn9U6QUSh+Kn5hU0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624754; c=relaxed/simple;
	bh=qcF6UrEwND6yoNeLF5HFmCaSETpnFwGFnx+laQI8yX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKnEeZPbCO8Iy/ocjt1sNRkMSccOg2A0SIds2JoERkeIZEOP3ETBbSETy5wBa994SyGygGpDNkYaajMzg3pWfjLsaJnWLab6hlVi1BeVghHDoPZT970na9eDmIVSyjXcq5/ehnGnxaEQsRrKQxCyRUsKMD/f7rYkw0Cy6QXei88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awdGx3t0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awdGx3t0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EBE1F000E9;
	Tue, 16 Jun 2026 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624751;
	bh=ld4MrRoMFHP5wQYooovJNTHUlV1w0VObgomj8WSIfsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awdGx3t0I3UJTVvPYA83KfsIvcjinJUxkdhXg4z3kftRl8zcVxqCfczGP/iqBYFO1
	 BTEP/P0nVBcrdgALoh1oeuYB42DYqvO98U4EwwCwI05gfUdp4ubDC/91RAeYgULuD4
	 XM2/2zy3+pRx5W+r+4XSkhgEcDd1lEF2fKrm+nAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/325] netfilter: synproxy: add mutex to guard hook reference counting
Date: Tue, 16 Jun 2026 20:26:59 +0530
Message-ID: <20260616145058.932434347@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 2fcba19caaeb2a33017459d3430f057967bb91b6 ]

As the synproxy infrastructure register netfilter hooks on-demand when a
user adds the first iptables target or nftables expression, if done
concurrently they can race each other.

Introduce a mutex to serialize the refcount control blocks access from
both frontends. While a per namespace mutex might be more efficient, it
is not needed for target/expression like SYNPROXY.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6a851ac4dd048f..a277b2bd3275dc 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -21,6 +21,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_synproxy.h>
 
+static DEFINE_MUTEX(synproxy_mutex);
+
 unsigned int synproxy_net_id;
 EXPORT_SYMBOL_GPL(synproxy_net_id);
 
@@ -768,26 +770,31 @@ static const struct nf_hook_ops ipv4_synproxy_ops[] = {
 
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref4 == 0) {
 		err = nf_register_net_hooks(net, ipv4_synproxy_ops,
 					    ARRAY_SIZE(ipv4_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref4++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
 
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref4--;
 	if (snet->hook_ref4 == 0)
 		nf_unregister_net_hooks(net, ipv4_synproxy_ops,
 					ARRAY_SIZE(ipv4_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_fini);
 
@@ -1192,27 +1199,32 @@ static const struct nf_hook_ops ipv6_synproxy_ops[] = {
 int
 nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net)
 {
-	int err;
+	int err = 0;
 
+	mutex_lock(&synproxy_mutex);
 	if (snet->hook_ref6 == 0) {
 		err = nf_register_net_hooks(net, ipv6_synproxy_ops,
 					    ARRAY_SIZE(ipv6_synproxy_ops));
 		if (err)
-			return err;
+			goto out;
 	}
 
 	snet->hook_ref6++;
-	return 0;
+out:
+	mutex_unlock(&synproxy_mutex);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_init);
 
 void
 nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net)
 {
+	mutex_lock(&synproxy_mutex);
 	snet->hook_ref6--;
 	if (snet->hook_ref6 == 0)
 		nf_unregister_net_hooks(net, ipv6_synproxy_ops,
 					ARRAY_SIZE(ipv6_synproxy_ops));
+	mutex_unlock(&synproxy_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
 #endif /* CONFIG_IPV6 */
-- 
2.53.0



