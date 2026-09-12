Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4367532B108;
	Sat, 12 Sep 2026 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221042; cv=none; b=fD+B0eZNKfbkJF1pL4Xyxmqn2+3xmTuNhfXi5zHSQZd15AFvcw3JravNeqWRQ3bufz0BnEf3bLHEvTPnffcV+7mBiQyOGRxxeLkTNpyz7TBU6nOCoF6ZFMaNxg+Pq8DbXGLcZyL1AGMXv4rdIpNuPnMo3b2Slh6I62n49CyTjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221042; c=relaxed/simple;
	bh=gOhszXQBrPWpvHWPuzetmB8UzlPiIUGPk385BQuCH5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8+2clvMhPJASlguEZdpVy9olk0TvE0ulUwRaBFuF0izFk8jaGJ0ra5/tknmi6bl/lVrhaheHsuARHeR8jne6GRDLBb3p0khTaCR9r3Z4pXtREfw/NGWUBSxy0geURz7fZ9EeSZW1UBXX3AGmxVew8SpNK5PnmOYDDr1S0/9EKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oaf7Gumi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oaf7Gumi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A531F00893;
	Sat, 12 Sep 2026 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221040;
	bh=ZB4H38qm2hWnA7PqaufrsBg54gN0KEKsdohXTpM5hGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oaf7GumiOSIJ8KD78iMP/5Sc3E0DsANlVzWMQ2aV9eQzeAIhj50Pp6do8rA1QDZ7f
	 yfGaQBsNmduKrBanaNjIFQGnyTYI9xE5n/VTFqm0S54HyUX9flA/LC4T8FEX7zMhiD
	 zjxFpyobUntLVbrdkik8XzI83yBLkVP9HiDVQFCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0259/1424] net: openvswitch: fix nf_connlabels leak in ovs_ct_init
Date: Sat, 12 Sep 2026 08:44:51 +0200
Message-ID: <20260912065613.077343540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit f9de5db270a4c2641de87ee558c16a9bc6eb4cd8 upstream.

ovs_ct_init() acquires a connlabels reference before initializing the
conntrack limit state. If ovs_ct_limit_init() fails, its error is returned
directly. The pernet core does not invoke the exit callback for the
operation whose initialization failed, so ovs_ct_exit() cannot drop the
reference.

This leaves labels_used elevated when Open vSwitch pernet registration
fails for an existing network namespace. Subsequent conntrack entries in
that namespace may allocate label extensions even though Open vSwitch
failed to register.

Drop the connlabels reference before returning a conntrack limit
initialization error. ovs_ct_limit_init() already releases its partial
state, and the original error remains unchanged.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260815151729.3757984-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1977,6 +1977,7 @@ int ovs_ct_init(struct net *net)
 {
 	unsigned int n_bits = sizeof(struct ovs_key_ct_labels) * BITS_PER_BYTE;
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+	int err = 0;
 
 	if (nf_connlabels_get(net, n_bits - 1)) {
 		ovs_net->xt_label = false;
@@ -1986,10 +1987,11 @@ int ovs_ct_init(struct net *net)
 	}
 
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
-	return ovs_ct_limit_init(net, ovs_net);
-#else
-	return 0;
+	err = ovs_ct_limit_init(net, ovs_net);
+	if (err && ovs_net->xt_label)
+		nf_connlabels_put(net);
 #endif
+	return err;
 }
 
 void ovs_ct_exit(struct net *net)


