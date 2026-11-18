Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044586;
	b=3uCKNuoUO35F1ZgunxEqj6PMU2LAprrmjm5xu7nMYw/Vy/j03OAxsXTVEJyQTDuOHaV0
	 tOpGRnL1DRt/gLsOK7J9yhbHkhZmyyZVCoKqoJWvEXG7N5QDGvkZzt5gq/zYIalXBCbHn
	 ERIFRK3rmcpYc0U8q6v9Q+l3at6BaIAUgnyl2tCnvUajofPIohUJTujnUwKEz3t5CTcGX
	 tfoPET36Mr3MB91G1o86oG2LQJhD0kUBcK+QSpAEQ8VuM80K+g82mCdrEj+3zuoHJRI6/
	 OXbR/swPkgvPG+LmIunrPhn8HVBBoXKgdyNnxiShkL/suP+bFwO86i5O3FRvrjIR5Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxjEh1itGBK+nLEgKZ3Ctx9+xElAR3+8Mycut6YiKvo=;
	b=Grd9EsFj/eZnZ227nJM84zr+X8x61WnX0gR5LumnUyQcrp76Q7Fq9WVrR6JuIrpl4O8R
	 LvE276GsmramCQ+euLV0MqtHryeDU6HhEm7WOsAEZHXs091ekznZtKiWs072CnFOgobvC
	 2jR6/CxFI5nJNu1o81Iq88vHsWMB1KMbJC18joxLCEU1pYJLI4AzRCL3mnWXJ2rC/lQtO
	 Rz8U3ApWNWpxbYVBNhPPHPnDX/bDWb5nJffB6Afg78lvqudqTpFgeF+cdOpcYgDtBTZX1
	 wUGn8yXgReGmdZbkwULG6F4lQpvJL+GlhCWjZkn1jSbU1N2AwFGGCaFcNgUGL3niQBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnLd13Lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42C8606A31C;
	Wed, 18 Nov 2026 23:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnLd13Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1332F1F000C4;
	Wed, 18 Nov 2026 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044586;
	bh=rxjEh1itGBK+nLEgKZ3Ctx9+xElAR3+8Mycut6YiKvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnLd13LkPXxfi+3yQ7bw0Fwn97qpp5WHP5JgWRZV/Kpr/bMuKjTYGOlLyOZQ4JkxC
	 cr/X0hrtgYV7BoEB2kL7T7EsdHSAo70LdZp2ZE5aWSd94R9yFri4CFcQo1yJilEUCC
	 rspU5LGxksHvT2GLBNJGCpyIwFPJDeieJ7NITsiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0618/2857] sunrpc: pin gss module across auth_domain RCU free
Date: Wed, 18 Nov 2026 15:27:32 +0100
Message-ID: <20261118150223.743128772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit b64d21116374688c33302a6704387c27d1156d72 upstream.

A gss auth_domain stores a raw pointer to svcauthops_gss in
dom->flavour, and its release queues svcauth_gss_domain_release_rcu()
via call_rcu(). Both live in auth_rpcgss.ko text, and nothing pins the
module while a domain referencing it is reachable. rmmod auth_rpcgss
can therefore unmap that text while an NFSD export still holds a
reference to the domain.

The export cache is one such holder. When the export is finally
released, the domain reference drops from module text:

    svc_export_put()
      auth_domain_put(exp->ex_client)
        auth_domain_release()
          dom->flavour->domain_release(dom)   /* into module text */
            svcauth_gss_domain_release()
              call_rcu(&dom->rcu_head,
                       svcauth_gss_domain_release_rcu)

Once auth_rpcgss is unloaded, the domain_release call lands in
unmapped memory. The rcu_barrier() in exit_rpcsec_gss() does not
help: it waits only for callbacks already queued, and this one is
not queued until the export goes away.

NFSD's NFSv4 objects import symbols from auth_rpcgss.ko, so only a
server built without CONFIG_NFSD_V4 can unload auth_rpcgss while
exports still name a gss domain.

Take a module reference in svcauth_gss_register_pseudoflavor() before
publishing the domain and drop it at the end of
svcauth_gss_domain_release_rcu(). The rcu_barrier() then holds the
module image until this callback has returned.

Fixes: 608a0ab2f54a ("SUNRPC: Add lockless lookup of the server's auth domain")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
[ cel: rewrote description ]
Link: https://patch.msgid.link/20260913160706.384180-1-cel@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -872,12 +872,18 @@ svcauth_gss_register_pseudoflavor(u32 ps
 	new->h.flavour = &svcauthops_gss;
 	new->pseudoflavor = pseudoflavor;
 
+	if (!try_module_get(svcauthops_gss.owner)) {
+		stat = -ENODEV;
+		goto out_free_name;
+	}
+
 	test = auth_domain_lookup(name, &new->h);
 	if (test != &new->h) {
 		pr_warn("svc: duplicate registration of gss pseudo flavour %s.\n",
 			name);
 		stat = -EADDRINUSE;
 		auth_domain_put(test);
+		module_put(svcauthops_gss.owner);
 		goto out_free_name;
 	}
 	return test;
@@ -1900,9 +1906,11 @@ svcauth_gss_domain_release_rcu(struct rc
 {
 	struct auth_domain *dom = container_of(head, struct auth_domain, rcu_head);
 	struct gss_domain *gd = container_of(dom, struct gss_domain, h);
+	struct module *owner = dom->flavour->owner;
 
 	kfree(dom->name);
 	kfree(gd);
+	module_put(owner);
 }
 
 static void


