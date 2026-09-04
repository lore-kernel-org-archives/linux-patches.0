Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C2C41D4F3;
	Fri,  4 Sep 2026 06:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502823; cv=none; b=cHAuanLYGR6jg4jPGmRn4D5AZFCmch2nlDYikE4LKpD9kfTbsrHrI4BkYfvmh4MSUhq6N/ViiAcv317tZJYDdeXdq1C/en1nMtlFsNBngZMSzvtvNtdVNkIwIxF8M9rlXIZ6U2R9tSPorIS48oTPvMJ3rp3TDMPgafggng1uWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502823; c=relaxed/simple;
	bh=MvqRUp9Zs7EILbZ3+ZzXT+ZBemVfgSpCos9kK+UjJ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/YHFpOxiavwhKmipINKqwQutUJMfgYYhuOa22UmUoDOn8KCjIlkw99ox3sv2xDYCZAkXNcnEo7vU8tImvvAwzJWQBTo4EFlD7v7gcuZsCXzifxatlyWusafBH67DDQmwjagDfmlhEGAiKT7kDrKlF4fZ2fr+WEoKldnbfadch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLO9ROon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLO9ROon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577571F00A3D;
	Fri,  4 Sep 2026 06:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502821;
	bh=HyjlZwHjE2TdLhebE5F1kFboL2sSTBy4Ih2y9GkIXJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLO9ROonnP+yW4AfMDz24rsHnI6Ou6GDE7ewsaxAJQ7sJlWh2M2WA61gt2oz69Emk
	 x4kfovLSGVnFjTcJHeHyYFZxghLxNN1PuLd0vE0lWfyfNcFpJAEJSPTvWIgilrcZqS
	 INyqvU6mhAnAypeOYnOqzIa2kpHSDEfxLY34OrQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 342/403] net: openvswitch: fix nf_connlabels leak in ovs_ct_init
Date: Fri,  4 Sep 2026 07:02:25 +0200
Message-ID: <20260904045742.596352886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2003,6 +2003,7 @@ int ovs_ct_init(struct net *net)
 {
 	unsigned int n_bits = sizeof(struct ovs_key_ct_labels) * BITS_PER_BYTE;
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+	int err = 0;
 
 	if (nf_connlabels_get(net, n_bits - 1)) {
 		ovs_net->xt_label = false;
@@ -2012,10 +2013,11 @@ int ovs_ct_init(struct net *net)
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


