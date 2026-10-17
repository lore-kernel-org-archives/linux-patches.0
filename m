Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA28384CED;
	Sat, 17 Oct 2026 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254296; cv=none; b=iHFq6illOHM5Z7EyWDZ7lWfzQzmweAQRW+OiAvHvRHWRwVtMTz+N+nTJpPewKT1EE/aoaIDvYZq5AFkOlVikwJIbxU50wQ2Y4mCHDqa7qZxVs4zIywEeI9RZiM6RsdjJFPMBDoh+fg7WtbCFGc45yBnunuU8viYE2Kx4ifBO76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254296; c=relaxed/simple;
	bh=g1teaDFvdq0wgc8mzYO6QFjhokNgZ2f99xXytehle78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFnFF0WOs6Nn9ZvZXUwhP/jQygZb+U1kwrxhlaBEJbnATs1ifEWiciJkiwZM2sDqWpYdTKekkGmE4P0jNTHbieYSq1zSyTLAOvTflr9KO0qJGKeGaLUwuI7jkUg1IMKINWnosEn7aOw/InAUPB9SJ6qljmvOIx7nXitiFkjL9GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB/x2Q+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB/x2Q+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C61F000C4;
	Sat, 17 Oct 2026 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254295;
	bh=POBOnOKNhtCVt7JS6khslqIjKFIeB0E4dWj+8/dIaV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB/x2Q+vJYzgGS8evkkMZkCLfM+pjnJIEKprKTh4K3NVRGIbcXy03rZglKY8OZARY
	 GqKPqiBO6wX7aVRhrXRdAHJzigGVVC9X3JJnakztlrmEeYnmTmgrRvtW5NwWwtqrBq
	 ofVF3h5YLQTPHF7oSz9+u0XfBw/amJTEOSVWx3V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/869] bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c
Date: Sat, 17 Oct 2026 17:54:01 +0200
Message-ID: <20261017160047.378516912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 0db4941d9dae159d887e7e2eac7e54e60c3aac87 ]

Use rcu_read_lock_dont_migrate() and rcu_read_unlock_migrate() in
bpf_sk_storage.c to obtain better performance when PREEMPT_RCU is
not enabled.

Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251007074011.12916-1-wangfushuai@baidu.com
Stable-dep-of: 7cbd0c4cebe4 ("bpf: Fix UAF in sock clone early bailouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 50ce498742596..135570dfcffe6 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -50,16 +50,14 @@ void bpf_sk_storage_free(struct sock *sk)
 {
 	struct bpf_local_storage *sk_storage;
 
-	migrate_disable();
-	rcu_read_lock();
+	rcu_read_lock_dont_migrate();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 	if (!sk_storage)
 		goto out;
 
 	bpf_local_storage_destroy(sk_storage);
 out:
-	rcu_read_unlock();
-	migrate_enable();
+	rcu_read_unlock_migrate();
 }
 
 static void bpf_sk_storage_map_free(struct bpf_map *map)
@@ -161,8 +159,7 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 
-	migrate_disable();
-	rcu_read_lock();
+	rcu_read_lock_dont_migrate();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
 	if (!sk_storage || hlist_empty(&sk_storage->list))
@@ -213,8 +210,7 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	}
 
 out:
-	rcu_read_unlock();
-	migrate_enable();
+	rcu_read_unlock_migrate();
 
 	/* In case of an error, don't free anything explicitly here, the
 	 * caller is responsible to call bpf_sk_storage_free.
-- 
2.53.0



