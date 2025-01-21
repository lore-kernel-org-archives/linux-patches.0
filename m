Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11481F238E;
	Tue, 21 Jan 2025 17:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482358; cv=none; b=OjdHp53pmi9GMcc+bH7npduhJNGTYksQOcSQfgZ5PFzSKmNAiSddT5w0MneUtj3DLir24EBOw+ZS48Jn64N4rbRBB5Kbgg5FmkDyJSZu16jK8XZaXOuL3Fh2j4dy9XmMpFjdwLaRsFq+P82RU07wgwbjje3Rdfpi1fUv96bgzcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482358; c=relaxed/simple;
	bh=789Kw0Dc/H00kViCFCwPkpeR54lb9shiMugzIUPWmDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAgCy86C54NFtDTOMfpJOSQXzXDhIloNSvskZ3Q0FeCvjyX8FIsG5t+83IHOzr0KiWuS5xnsy3mV6IXqD9Z9l4SW5C8y8UJLcLU4rqFbXDJY4tqhmXiixOiMeHUXfGqBOo1lnQhL5DovKy0mNPxVIg+BCWhenJDHud+tZPVrC2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0ja6fCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0ja6fCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C7DC4CEDF;
	Tue, 21 Jan 2025 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482358;
	bh=789Kw0Dc/H00kViCFCwPkpeR54lb9shiMugzIUPWmDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0ja6fCuJg/qmap4K16hS7nysSImL8hSz6/QEEd4kKa71fSl9Y37DlmYLM9RUJ+Oj
	 kj3J4rUerXw5wCregSpBrLUDlTQJr8Lgo6oGDUHUpGVW9mJi76KBkEgA3/yqMSzNcy
	 m7qRs/D7lzSifk38A83vbCKH3SnxTIOF42qrtRuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Li <dualli@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/122] netdev: avoid CFI problems with sock priv helpers
Date: Tue, 21 Jan 2025 18:51:20 +0100
Message-ID: <20250121174534.226946917@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a50da36562cd62b41de9bef08edbb3e8af00f118 ]

Li Li reports that casting away callback type may cause issues
for CFI. Let's generate a small wrapper for each callback,
to make sure compiler sees the anticipated types.

Reported-by: Li Li <dualli@chromium.org>
Link: https://lore.kernel.org/CANBPYPjQVqmzZ4J=rVQX87a9iuwmaetULwbK_5_3YWk2eGzkaA@mail.gmail.com
Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250115161436.648646-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl-gen.c | 14 ++++++++++++--
 tools/net/ynl/ynl-gen-c.py | 16 +++++++++++++---
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index b28424ae06d5f..8614988fc67b9 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -178,6 +178,16 @@ static const struct genl_multicast_group netdev_nl_mcgrps[] = {
 	[NETDEV_NLGRP_PAGE_POOL] = { "page-pool", },
 };
 
+static void __netdev_nl_sock_priv_init(void *priv)
+{
+	netdev_nl_sock_priv_init(priv);
+}
+
+static void __netdev_nl_sock_priv_destroy(void *priv)
+{
+	netdev_nl_sock_priv_destroy(priv);
+}
+
 struct genl_family netdev_nl_family __ro_after_init = {
 	.name		= NETDEV_FAMILY_NAME,
 	.version	= NETDEV_FAMILY_VERSION,
@@ -189,6 +199,6 @@ struct genl_family netdev_nl_family __ro_after_init = {
 	.mcgrps		= netdev_nl_mcgrps,
 	.n_mcgrps	= ARRAY_SIZE(netdev_nl_mcgrps),
 	.sock_priv_size	= sizeof(struct list_head),
-	.sock_priv_init	= (void *)netdev_nl_sock_priv_init,
-	.sock_priv_destroy = (void *)netdev_nl_sock_priv_destroy,
+	.sock_priv_init	= __netdev_nl_sock_priv_init,
+	.sock_priv_destroy = __netdev_nl_sock_priv_destroy,
 };
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 717530bc9c52e..463f1394ab971 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2361,6 +2361,17 @@ def print_kernel_family_struct_src(family, cw):
     if not kernel_can_gen_family_struct(family):
         return
 
+    if 'sock-priv' in family.kernel_family:
+        # Generate "trampolines" to make CFI happy
+        cw.write_func("static void", f"__{family.c_name}_nl_sock_priv_init",
+                      [f"{family.c_name}_nl_sock_priv_init(priv);"],
+                      ["void *priv"])
+        cw.nl()
+        cw.write_func("static void", f"__{family.c_name}_nl_sock_priv_destroy",
+                      [f"{family.c_name}_nl_sock_priv_destroy(priv);"],
+                      ["void *priv"])
+        cw.nl()
+
     cw.block_start(f"struct genl_family {family.ident_name}_nl_family __ro_after_init =")
     cw.p('.name\t\t= ' + family.fam_key + ',')
     cw.p('.version\t= ' + family.ver_key + ',')
@@ -2378,9 +2389,8 @@ def print_kernel_family_struct_src(family, cw):
         cw.p(f'.n_mcgrps\t= ARRAY_SIZE({family.c_name}_nl_mcgrps),')
     if 'sock-priv' in family.kernel_family:
         cw.p(f'.sock_priv_size\t= sizeof({family.kernel_family["sock-priv"]}),')
-        # Force cast here, actual helpers take pointer to the real type.
-        cw.p(f'.sock_priv_init\t= (void *){family.c_name}_nl_sock_priv_init,')
-        cw.p(f'.sock_priv_destroy = (void *){family.c_name}_nl_sock_priv_destroy,')
+        cw.p(f'.sock_priv_init\t= __{family.c_name}_nl_sock_priv_init,')
+        cw.p(f'.sock_priv_destroy = __{family.c_name}_nl_sock_priv_destroy,')
     cw.block_end(';')
 
 
-- 
2.39.5



