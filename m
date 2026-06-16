Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE0E47CC65;
	Tue, 16 Jun 2026 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635883; cv=none; b=MIXHF1yt5Q+b5fwAxtcWIajyfSzL3XRTaGNzf0u96Y0Ya134oAhbtWQoBjxL5aR0V7Ytd7prLkbMOliG1KZLoVamHZiCJ5SWVh9MekUcXhyESwHvFVmLFOcFM9j8+UmFGkKl2yuSHxilKMw6cL0Y8Kbqmj84rvWZ+0m3L4aNPZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635883; c=relaxed/simple;
	bh=+bLU4dcNDS/W9/SEMQFVKREOVfyVre5KYLIoxeLXEi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTI34fSBcmv1qHHwQLXuiIxz50UsXHCgvy7nVl5V5QTBuxSm2Jr0+QnihdMsoa9ZhHxWRrINYi7FENBT738nDUC7tcNPPOAhfTFzVChF09MeoU0CAppRe5F1RiLAem1CfgEIFu+YFBsHcjLR57DX+abh7ImK9ghbN5exJGxxWqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eovi+/kP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eovi+/kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621E61F00A3A;
	Tue, 16 Jun 2026 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635882;
	bh=bNGAHnX/00Gncmnt4PwASZOA83Tym9OpuC8P0OaCl8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eovi+/kPixttumNO9LlahhPO/VCAo7AB/J5XoSnuFfZHui5eTsbt1pL5IxT+1JRJQ
	 /TPvRXdGMpb9hLYMADNmxqJI9bU5jlNZQ7phgqZh0IdWK5vpUD+q18v4J3TpvX+u/M
	 n5U/i5MRP5faBT3qN9DPCp09xYNuq8z0mUzYCq8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/342] netfilter: synproxy: add mutex to guard hook reference counting
Date: Tue, 16 Jun 2026 20:27:10 +0530
Message-ID: <20260616145054.434906868@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a97b1a0f53e45..4a742dda15da71 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -21,6 +21,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_synproxy.h>
 
+static DEFINE_MUTEX(synproxy_mutex);
+
 unsigned int synproxy_net_id;
 EXPORT_SYMBOL_GPL(synproxy_net_id);
 
@@ -790,26 +792,31 @@ static const struct nf_hook_ops ipv4_synproxy_ops[] = {
 
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
 
@@ -1214,27 +1221,32 @@ static const struct nf_hook_ops ipv6_synproxy_ops[] = {
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



