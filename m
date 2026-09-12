Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426AF202F71;
	Sat, 12 Sep 2026 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217712; cv=none; b=XxozeyWk+kQPeIkJHYOkKDXO50OgD1eaenb9zud9HTbw4Ix4SIPL3IcwQ0D/XaQ29CuCscblSU8uzV1hZ4P2f2uNOKn5DjL+P0fHA5tFwwalaxCRl4LOoYv+H6G2IJveysD98ogbAbRUM8UNhaVfJVRiD/1UumJiadQw2rGBuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217712; c=relaxed/simple;
	bh=poQRFylIuoUFlaLI/AnLm5eUaVjkEX6TnZzUdm0+Iyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rK6Uo/tP9rF/FeaBmTNnJ7Q+mI0p89oPA8SxJloUbwRmkEoflkaEps39XQ1adCK9RB98cRDWxkkkWMEV8xntZJGUYmWD7vi/tbtKJH7Z1I8eOP/TZ8wcG1OgfPrWxIvpvNWfdeO1Fo5SmSqIVq/FpWmKJUpzstWZqvaCQzoqRdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5PvbUPj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5PvbUPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B865A1F000FF;
	Sat, 12 Sep 2026 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217710;
	bh=oQ8X7tD9niTHJwa6cE5nvQJgEb7alRJjOuD41e9hF7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5PvbUPjxUs27Qi65i0dRQC0KtplyDmmgX4sJoeNnStLTCn3hbsk8h4V8kXFqT+LM
	 BudsQMfVGmEnWGkcxfkaulcROveoHhzkkmi80L/96Jg1KlapJbJTwS5MdAI8gs856o
	 viQhfV2nn4TGQTdxciO0X6BGjFl0LktYHcF00HtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0995/1376] cgroup: Add bpf prog revisions to struct cgroup_bpf
Date: Sat, 12 Sep 2026 08:57:01 +0200
Message-ID: <20260912065629.741571433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 9b8367b604c739947ec308874f087fe0eb80f412 ]

One of key items in mprog API is revision for prog list. The revision
number will be increased if the prog list changed, e.g., attach, detach
or replace.

Add 'revisions' field to struct cgroup_bpf, representing revisions for
all cgroup related attachment types. The initial revision value is
set to 1, the same as kernel mprog implementations.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250606163136.2428732-1-yonghong.song@linux.dev
Stable-dep-of: 3f562c537e9e ("bpf, cgroup: Fix storage null-ptr-deref after replacing prog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf-cgroup-defs.h | 1 +
 kernel/cgroup/cgroup.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 0985221d54788..c9e6b26abab6d 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -63,6 +63,7 @@ struct cgroup_bpf {
 	 */
 	struct hlist_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
 	u8 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
+	u64 revisions[MAX_CGROUP_BPF_ATTACH_TYPE];
 
 	/* list of cgroup shared storages */
 	struct list_head storages;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3c7d466f13df7..ce012aca272a5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2081,6 +2081,11 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
 
+#ifdef CONFIG_CGROUP_BPF
+	for (int i = 0; i < ARRAY_SIZE(cgrp->bpf.revisions); i++)
+		cgrp->bpf.revisions[i] = 1;
+#endif
+
 	init_waitqueue_head(&cgrp->offline_waitq);
 	INIT_WORK(&cgrp->release_agent_work, cgroup1_release_agent);
 }
-- 
2.53.0



