Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831786;
	b=T3j5zwas0/PwuBPboktAC9oJk95Vqmx+eA0iMeWD/GYkCyGmKnYhgroxfePPbRFDgWhr
	 oj1Jefvhalr+lS6/ZjSPobvRJajkO9fogmUIn6Yti4VrGQc5x4kpxxKd26IPd3chSqaP6
	 oYOBoyv79YeJ6IclDKARa5Uw5Ydrso3Mytqwrx32ineQrne6HH3RX0yU9IdcMn1tIKCbM
	 mzuumZijKWIO4KTmPVcrpEZpRgzhb4dJJ2j6XPXFmtp48me9N0wZ3XAoGg2vmNY+K5zls
	 2RyWA+5kIyNrt21mcM6/lcqpo5uut2YXISWDKefLrrDAMhJaQPEF4mitEimhpUwZFMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FfenBVSTADel2Dkc8u2ZS3RaajctoDGRHL6ImdlWLDY=;
	b=m9WUxirc4expV+QxFR2LOqgSioMpoJNrIVas0obS23QLQs3iCm+NImqLwsLzPO87CXbu
	 F22lp55uncZMkA12YBMo73B971zk2w24AMV/qp/ObNiM1qDducy4/lMAkRPSzMSHonj5x
	 WcicELojKGgdWHFd/kZEBZxgNq4EKnZ9NVYbmu5li4T16t7rUtPlMikFpNhX6kB9iEpuz
	 UCwUoItTn4NjktVnDlZNnG/WEC07PV8QwyA0HPrn6DQ2qbKGEmDE3Up1bNvyzW0CRnLgi
	 rA4YXyIIwD9B9ykOwYGYf3CuByK7JpzFM4PLAgtZFbv7+NFO2AznhStB60i/HRqYc8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCDEGkYy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA406606AC37;
	Wed,  4 Nov 2026 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hCDEGkYy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7683D1F000C1;
	Wed,  4 Nov 2026 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831785;
	bh=FfenBVSTADel2Dkc8u2ZS3RaajctoDGRHL6ImdlWLDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCDEGkYyhRhnPSwCIVO3ZaFkNp/zvZP8FxbMzxGEkNMDYeHptYCiWnZf9FfNhLmnw
	 b8uiBtrGuCEsm4byn9c3/ftnaVkyuYXwn3gOyxR36jxQAGtWQ7TxrEr735U3UKTWWA
	 zQEJPBq2x/vor8ZbNXA3fwPI6vcRqvZWmA8P/LsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0911/1005] sunrpc: pin gss module across auth_domain RCU free
Date: Wed,  4 Nov 2026 16:10:44 -0500
Message-ID: <20261104211108.685913953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -824,12 +824,18 @@ svcauth_gss_register_pseudoflavor(u32 ps
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
@@ -2004,9 +2010,11 @@ svcauth_gss_domain_release_rcu(struct rc
 {
 	struct auth_domain *dom = container_of(head, struct auth_domain, rcu_head);
 	struct gss_domain *gd = container_of(dom, struct gss_domain, h);
+	struct module *owner = dom->flavour->owner;
 
 	kfree(dom->name);
 	kfree(gd);
+	module_put(owner);
 }
 
 static void


