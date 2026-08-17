Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C9303C97;
	Mon, 17 Aug 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975837; cv=none; b=bB+AKSz9kENO+F08E/403daMzptiHEsmOIb0DjOlbvfr2Ba04vAi2iCwt7vxG4E5lR1f1+CqJrex3RBu6hbNzA4RwdPmby2cgOxfRbotJinpB+/pqcMxWp8aH0OtPvYj8tve2MJysfF78sUmfQfs8clpyzScAi4RIkROFSWIn1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975837; c=relaxed/simple;
	bh=Uf5gKUm/s8AeSJeKGnPkaGgcfNVgXme+rhMBycuIIbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKVWc+cpuVGsYCro1Fv+8X8G8ql8axHzGhBKP4mYMJQfRhk4FxfGmxm0iKBUPGZbJJ3btE/pRuPNqkkrWV80cxvTK1ipR9mm1vwSauqR2FBf5MoHqimFNVu0dXPxt6u+LEqlzIHt8qllRXF7d9/xGucD0aWhpxO3kKcpyL6tZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA31/KLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA31/KLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2831F000E9;
	Mon, 17 Aug 2026 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975835;
	bh=x9Z+n+rJM6ADmbo6R9hxW67mlKD4GMTXyPTccJxNxxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iA31/KLSs4kHR8b7797u6EBKXfyXTjj6kIyLG77uHXIcGPY7eN3qR4Dr4fW4EmSLG
	 XzhxsohsZ+PGMCJDl4U9BEthKQbcsqQnnrquT6PzYo0XRrtwySItqbgWp3B9lhR/ZO
	 g/OkfqDrl0KtKol7Q7o6CqiLBS24X/+CNRaMiafc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 166/389] libceph: remove debugfs files before client teardown
Date: Mon, 17 Aug 2026 15:30:05 +0200
Message-ID: <20260817132545.656826989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Douya Le <ldy3087146292@gmail.com>

commit e4c804726c4afce3ba648b982d564f6af2cfa328 upstream.

ceph_destroy_client() tears down the monitor client before removing
the per-client debugfs files. A concurrent read of the monmap debugfs
file can enter monmap_show() after ceph_monc_stop() has freed
monc->monmap, triggering a use-after-free.

Remove the debugfs files before stopping the OSD and monitor clients.
debugfs_remove() drains active handlers and prevents new accesses, so
the debugfs callbacks can no longer race the rest of client teardown.

Cc: stable@vger.kernel.org
Fixes: 76aa844d5b2f ("ceph: debugfs")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/ceph_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -727,13 +727,13 @@ void ceph_destroy_client(struct ceph_cli
 
 	atomic_set(&client->msgr.stopping, 1);
 
+	ceph_debugfs_client_cleanup(client);
+
 	/* unmount */
 	ceph_osdc_stop(&client->osdc);
 	ceph_monc_stop(&client->monc);
 	ceph_messenger_fini(&client->msgr);
 
-	ceph_debugfs_client_cleanup(client);
-
 	ceph_destroy_options(client->options);
 
 	kfree(client);


