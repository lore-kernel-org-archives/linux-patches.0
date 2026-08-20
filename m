Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D58E477E58;
	Thu, 20 Aug 2026 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244321; cv=none; b=A9FT1MW5pFakm8Wxg5ax+fq0AAAMyvWWE3MJ6k8cN5UKGISXchNmIku/wMyYqWP2wnyRy7Ax1x8GUfQBJOUDFycmqycdND8zwPfsd9fLgQxutTy8FOpBpK9t4e5G2+O120WBcau0yyZMtRhveOZeF0t3Ej3Di9r7dmVILoHLEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244321; c=relaxed/simple;
	bh=ydbq+osGYgqlUwDwVPHtQVDUOElhYnDGaLRxWdVsbl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0E3CAQmMx1wDRYt122PI5ymwcJ++aCGjKDxuUIji94SYiJrB3r8QylVtlDAmOfNAs7YCdD9E68hLWepkZ7zLVdW1dNOBF0ZLqhv6pbqQih5i0Aoub5hGNgu3LNXdKLsrEhcnA47YZo/1g9cELEOFFp6P187eNQXpiq6AXYVVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjrPAO4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjrPAO4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754021F00A3D;
	Thu, 20 Aug 2026 16:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244320;
	bh=jlhJDM3VI6Pn23l4A/RGtf5mMjJaGYxrgz4pwMcw+r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjrPAO4obYVZ5vIm7W4Nva4hVBT9DmP4JgBuGbtpt6QXCtLdMJJkBF5adnry5+Jdx
	 O7YGujK2nkjqtS682oW30pE2ZTIRDM68u2m1OWmdtihXzHX6Vrf5YSvE8XaMbNhavC
	 6zP8bkjCFjWj+MMkHNWG7AsZ7V4RZccezJoTK3Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/235] bootconfig: do not put quotes on cmdline items unless necessary
Date: Thu, 20 Aug 2026 16:56:03 +0200
Message-ID: <20260820145220.295908326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 212f863fa8811c780abacc1d0404c573fdc0a2de ]

When trying to migrate to using bootconfig to embed the kernel's and
PID1's command line with the kernel image itself, and so allowing changing
that without modifying the bootloader, I noticed that /proc/cmdline
changed from e.g.

  console=ttymxc0,115200n8 cma=128M quiet -- --log-level=notice

to

  console="ttymxc0,115200n8" cma="128M" quiet -- --log-level="notice"

The kernel parameters are parsed just fine, and the quotes are indeed
stripped from the actual argv[] given to PID1.  However, the quoting
doesn't really serve any purpose and looks excessive, and might confuse
some (naive) userspace tool trying to parse /proc/cmdline.  So do not
quote the value unless it contains whitespace.

Link: https://lkml.kernel.org/r/20240320101952.62135-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dec4d8118c17 ("bootconfig: fix NULL-pointer arithmetic in xbc_snprint_cmdline()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -323,7 +323,7 @@ static int __init xbc_snprint_cmdline(ch
 {
 	struct xbc_node *knode, *vnode;
 	char *end = buf + size;
-	const char *val;
+	const char *val, *q;
 	int ret;
 
 	xbc_node_for_each_key_value(root, knode, val) {
@@ -341,8 +341,14 @@ static int __init xbc_snprint_cmdline(ch
 			continue;
 		}
 		xbc_array_for_each_value(vnode, val) {
-			ret = snprintf(buf, rest(buf, end), "%s=\"%s\" ",
-				       xbc_namebuf, val);
+			/*
+			 * For prettier and more readable /proc/cmdline, only
+			 * quote the value when necessary, i.e. when it contains
+			 * whitespace.
+			 */
+			q = strpbrk(val, " \t\r\n") ? "\"" : "";
+			ret = snprintf(buf, rest(buf, end), "%s=%s%s%s ",
+				       xbc_namebuf, q, val, q);
 			if (ret < 0)
 				return ret;
 			buf += ret;


