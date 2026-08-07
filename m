Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0A1412C05;
	Fri,  7 Aug 2026 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117078; cv=none; b=uY+swq/y5iy3PKTbBEsSSxxFroHguicG86HHmIw7Kac8YEqCIROVrlpeqweVqhYYyPq1rk1K61Gm+cFWrI4Ih3e7Jazb4J7bMl5lpr7fxBTcltYYSMF5jN3vW5EZa8HXaSO4JAoCG23T2ieEyfEVAtC6GT1kbH/O91mx/CBSgVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117078; c=relaxed/simple;
	bh=bihfbhtdjZzBf7cz+Nj9qpIquSb4AP7raewNGoCjjKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJrpmJzKOpeMKMH8EKxEosO4C1ZmWLBN9T5w9725bC6mlQDei6wdlFZzlSsXkWrUsHX2kbTTh92zId3CDtnm4OWMaxHufLtYexYJNxhl3Nt7SaVZ6htS9d81rO7L++NVnLZVDjNva0hqC92uHEoftP6AzQMr0qoduzs34ijtj0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WI9/wzrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI9/wzrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3101F000E9;
	Fri,  7 Aug 2026 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117077;
	bh=I+/3rf1OhCC9suptnC0OXwtNX510MvTBY9oQCKIZPkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WI9/wzrYLQnKHUuUvIGriibz4lSkge2C6cmh5Hm9bIxrXDqhcMhAil5kglggCgBah
	 MsTNnRiFEtWpryUsQQyvPxMYJ25X8naHEAQj8+zOZ35t8iAUIoAq4T/3u03zEzEjqI
	 edSY1wqMdcOgJBF/5Esz36GHwhPn2lR8eAf4u+pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 165/438] fprobe: Fix module reference count leak on error in register_fprobe()
Date: Fri,  7 Aug 2026 16:36:01 +0200
Message-ID: <20260807143431.550658099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 8cf2f40ceb85047ad8a84dffae3bebc9fed18216 ]

In register_fprobe(), get_ips_from_filter() resolves target function
addresses and increments module reference counts via try_module_get() for
symbols in kernel modules. If get_ips_from_filter() fails on the second
pass and returns an error, register_fprobe() returned directly without
releasing module references acquired up to that point.

Fix this by ensuring the cleanup loop executing module_put() runs even when
get_ips_from_filter() returns a negative error.

Link: https://lore.kernel.org/all/178528125360.101985.4144133640239273153.stgit@devnote2/

Fixes: d24fa977eec5 ("tracing: fprobe: Fix to lock module while registering fprobe")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index f215990b90613..f681015413b83 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -961,10 +961,8 @@ int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter
 		return -ENOMEM;
 
 	ret = get_ips_from_filter(filter, notfilter, addrs, mods, num);
-	if (ret < 0)
-		return ret;
-
-	ret = register_fprobe_ips(fp, addrs, ret);
+	if (ret >= 0)
+		ret = register_fprobe_ips(fp, addrs, ret);
 
 	for (int i = 0; i < num; i++) {
 		if (mods[i])
-- 
2.53.0



