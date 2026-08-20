Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97693750DC;
	Thu, 20 Aug 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248251; cv=none; b=GEHTDaFArYDmfXoq5bM1CCp2iZ3MhWrQ1s6BGUTt2J4l8h2Pvjn3JQqu5lIMMxm5W5ue8YmvmTW+UWCuXOBbwrH8loz48cxyk48tiA8HlDklsdwCjtqPrbLj7PU9Q/PzGzDE7Lcjthvw3iQiW/bTjJ8N5qkh2ErESuXS7lm1LH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248251; c=relaxed/simple;
	bh=ywei+JcIlngae4lGKcbfHVVXbXYvgylNSARd9p7duQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmVP3nQ3mvNFvjcHWCEwWyonQK9PEWEBDCj8+L6y2n3oRAO5TudaGvGVPtwkHufDS4U7dZoKc09yjgjmWS9T5GXHcnhYgpOzl8IoGl5RP9pMiSmx+gfyDLLUWvGqwdC0JDRLXyt1Tjkop4lLkIPbpP4rL/tkSa3X7PyT/81qOwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPk+KhEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPk+KhEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3129D1F000E9;
	Thu, 20 Aug 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248249;
	bh=cv2Pkj9jijvIf1HPQbYxcp3YQ4CISX8n03Lt3kfByBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPk+KhEi37qOFGi2g0VMi7YhRX5A8VOF5Q/QJyeF75E/D38YwfO5NjtkJgKeZmt20
	 dJNJ1V0+b3g0A92fgcvzIVM2poiwAtdNi8Q2E79ViwofMTPsgf9whN7XIoCpEc1vRO
	 Obcg+LReHyDh1jHgKM9yGd2dqngvc7xtaubf/9FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/303] bootconfig: do not put quotes on cmdline items unless necessary
Date: Thu, 20 Aug 2026 16:54:59 +0200
Message-ID: <20260820145258.202762658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -332,7 +332,7 @@ static int __init xbc_snprint_cmdline(ch
 {
 	struct xbc_node *knode, *vnode;
 	char *end = buf + size;
-	const char *val;
+	const char *val, *q;
 	int ret;
 
 	xbc_node_for_each_key_value(root, knode, val) {
@@ -350,8 +350,14 @@ static int __init xbc_snprint_cmdline(ch
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


