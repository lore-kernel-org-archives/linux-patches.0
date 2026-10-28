Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216464;
	b=up/YUGq/FTqOSkZKaIDFPsygR6BEbbseo4cYYcA95aqomI+bENylH8M4a7jcJMsAqIOk
	 bWUn1xVZ+GV3aHx1C0UuKYbfjm4lTkGuBbWKOMjDpJeTSA3KZ+wm43RLY+xxmGA0ZGK+t
	 nlnYW0rHYdTxyrT+LiFOq3Vvqy/aaeRttVaDmI1rV0IemVSqaL5OnEfQlY9tdjTvCaGLa
	 POKyQZvwAntXgBSAkUKM0jMsGe64DWTSmel8fc6EzWSzQYBj+5kQgLVCWHPK4adG9egO7
	 6ZmIAzMXDJYYSVSl5cuW6VGartdZV/WG6IjjP8MEOPoe48jSnFHWrHkCKpGNnR3ceAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xbvykV8TeOpihO76jy4JXgjAn2GYBcQ3iPMVGuLuNs4=;
	b=I/7DF7OsqWgNgFyjM0KjYcoJwjxnSGV7esnnmdu+iIHPpiZp08I465iFifnP6OWrRUv1
	 qQEEObf0FngyP6zqxknGkzZA1W+gXUZovytrgONjB+iHLQJZ+Vb+cXvoPE2qAXQZ9Uohc
	 3O6wNR0YE0VoZ/zKjzu+0AZDDXmUZW/3gm5MmLgjJxPO+CISKDdSJ0wb0hoEaQ7ljbwYH
	 yyXao9vGVNMM9Sv3XWm/b5dXLPJ7ryZ6u5ereOh+qmNtMAx+uVyMrbUEDoZLxuxl+2ByZ
	 VcBi0Pvgw7zZTIxM4lv4i5gpDvUG0pOnuMMsN0xvP/ESE8dzafeQKM2NldOPq0OqULw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ajq2IjQ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D5606A32F;
	Wed, 28 Oct 2026 19:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ajq2IjQ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2321F01828;
	Wed, 28 Oct 2026 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216463;
	bh=xbvykV8TeOpihO76jy4JXgjAn2GYBcQ3iPMVGuLuNs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ajq2IjQ+ehFWfxx1yp7+2Puor/y+U6GiJdUGvHqSsETA9+dyxBqHFuEvaRsgDW99X
	 YTiFnXpStPsoz1H/rRKvVMKWnV9cEik+YSLu2rCuiBFW7nsgrhuvm+V/46X5oktuJX
	 kr3ZMgMOjFFcwqgeJ1nrzxIa1ry1DvD5XWmDPjao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1566/1887] bpf, cgroup: Fix storage null-ptr-deref after replacing prog
Date: Wed, 28 Oct 2026 18:01:02 +0100
Message-ID: <20261028170535.102550483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 3f562c537e9ecf4bc5e206cfffc2cc047f1b7e94 ]

Syzkaller reported a storage null-ptr-deref issue after replacing prog.
This occurs in the following scenario:
1. prog A, an empty prog, is attached to a cgrp.
2. prog B uses BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE and calls the
   bpf_get_local_storage helper.
3. link_update is called to replace prog A with prog B.

The reason is that __cgroup_bpf_replace fails to alloc and assign the
required cgrp storage for the incoming replacement prog. Consequently,
the new prog inherits an uninit storage, leading to null-ptr-deref panic
when kick the new prog.

Fix this by rejecting a link update if new_prog's cgroup storage is
incompatible with link->prog.

Fixes: 0c991ebc8c69 ("bpf: Implement bpf_prog replacement for an active bpf_cgroup_link")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260728132336.2857800-1-pulehui@huaweicloud.com [0]
Link: https://lore.kernel.org/bpf/f87b53c0-8f00-45a6-82db-8242fa9b143f@huaweicloud.com [1]
Link: https://lore.kernel.org/bpf/20260807104403.1013064-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6158b021f617f..3771a041d9de5 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -797,6 +797,20 @@ static void replace_effective_prog(struct cgroup *cgrp,
 	}
 }
 
+static bool cgroup_bpf_storages_compatible(struct bpf_prog *old_prog,
+					   struct bpf_prog *new_prog)
+{
+	enum bpf_cgroup_storage_type stype;
+
+	for_each_cgroup_storage_type(stype) {
+		if (old_prog->aux->cgroup_storage[stype] !=
+		    new_prog->aux->cgroup_storage[stype])
+			return false;
+	}
+
+	return true;
+}
+
 /**
  * __cgroup_bpf_replace() - Replace link's program and propagate the change
  *                          to descendants
@@ -834,6 +848,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (!found)
 		return -ENOENT;
 
+	if (!cgroup_bpf_storages_compatible(link->link.prog, new_prog))
+		return -EINVAL;
+
 	old_prog = xchg(&link->link.prog, new_prog);
 	replace_effective_prog(cgrp, atype, link);
 	bpf_prog_put(old_prog);
-- 
2.53.0



