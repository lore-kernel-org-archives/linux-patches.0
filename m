Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4611A63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC9CC4339B;
	Mon, 20 Feb 2023 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901585;
	bh=hpX5RhqmE8LsUZC3W8HZj54TpXjhg0t0DD4ui0J6Ebc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOybwMIXlL9djtAfuz5j7NRqYi51DbnDauhKVmRlcIFYZjI5Uw0ynqFqmHglLhpY1
	 9Hlx5fJ3HcLH0sUyF6N8k9NJ4E9EOFcK+mcCA7zANO9k2lfsasIgHYHpnpSooilIS6
	 BkCfYmtU6zvcIaXi8Cdp/S+9eGgn+nCrKIn5avQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 074/118] coredump: Move dump_emit_page() to kill unused warning
Date: Mon, 20 Feb 2023 14:36:30 +0100
Message-Id: <20230220133603.381642402@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9c7417b5ec440242bb5b64521acd53d4e19130c1 upstream.

If CONFIG_ELF_CORE is not set:

    fs/coredump.c:835:12: error: ‘dump_emit_page’ defined but not used [-Werror=unused-function]
      835 | static int dump_emit_page(struct coredump_params *cprm, struct page *page)
          |            ^~~~~~~~~~~~~~

Fix this by moving dump_emit_page() inside the existing section
protected by #ifdef CONFIG_ELF_CORE.

Fixes: 06bbaa6dc53cb720 ("[coredump] don't use __kernel_write() on kmap_local_page()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -831,6 +831,30 @@ static int __dump_skip(struct coredump_p
 	}
 }
 
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (cprm->to_skip) {
+		if (!__dump_skip(cprm, cprm->to_skip))
+			return 0;
+		cprm->to_skip = 0;
+	}
+	return __dump_emit(cprm, addr, nr);
+}
+EXPORT_SYMBOL(dump_emit);
+
+void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
+{
+	cprm->to_skip = pos - cprm->pos;
+}
+EXPORT_SYMBOL(dump_skip_to);
+
+void dump_skip(struct coredump_params *cprm, size_t nr)
+{
+	cprm->to_skip += nr;
+}
+EXPORT_SYMBOL(dump_skip);
+
+#ifdef CONFIG_ELF_CORE
 static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 {
 	struct bio_vec bvec = {
@@ -864,30 +888,6 @@ static int dump_emit_page(struct coredum
 	return 1;
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
-{
-	if (cprm->to_skip) {
-		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
-		cprm->to_skip = 0;
-	}
-	return __dump_emit(cprm, addr, nr);
-}
-EXPORT_SYMBOL(dump_emit);
-
-void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
-{
-	cprm->to_skip = pos - cprm->pos;
-}
-EXPORT_SYMBOL(dump_skip_to);
-
-void dump_skip(struct coredump_params *cprm, size_t nr)
-{
-	cprm->to_skip += nr;
-}
-EXPORT_SYMBOL(dump_skip);
-
-#ifdef CONFIG_ELF_CORE
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len)
 {


