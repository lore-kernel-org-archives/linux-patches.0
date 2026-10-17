Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2EE3BFAF7;
	Sat, 17 Oct 2026 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259089; cv=none; b=r5MRD9egTgS5z0FFxL7hFU9RKKR88wtGAPY4eXOnCfBDWiYliX0EDHbxqXvbzrAFjCnGwiPNfC8cNvDNu7iUpz54A2tZ7cprNQTaHA6pnrNHnNoeFPP8gZuMrWcYeDNTGGHSk55YpMjb0ArRXe4+BMyKcBwmvBqEt5IS8JcJ2iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259089; c=relaxed/simple;
	bh=pzHrB+dlIh7jr+OZc5CWW/mS94b9JiBFscSn0IDrrkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLAaOiPpVeydeJK1vM+94CVtq8qXVK00pXH3yJj6NAd4JRqjymD8MW4B9grMb+j1BltWqlbqBWvPLh7PSUhyrgr3alFFf7OWL9KxsZZrqGQzr8xx3kNPvzcyd8OzhaWtiMWnJGkHyLB0RMgOI3VwgzeO5jFKXNnVVT2Pdjj44AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgClpLSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgClpLSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0108B1F000C4;
	Sat, 17 Oct 2026 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259087;
	bh=CVfGpckNrN3zZhBi9viaLbpzRxJAHTS2DUNqXnHkyoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgClpLSVlCAPvJUYoYD4sw/NfkTIE4yomqN0xe3GYGY1LTAKW7wdP/oYEArmwizfe
	 KSmVLyIRY4A/ATYuG94aECBm2gALQ4BC1hu8m3G6cRaSNwHf9xP4IDpGe6Lw062f8w
	 sm25++/kWlRpI1ORKuj7g7Ia2rI04PXZHiiErnqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1097/1674] bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c
Date: Sat, 17 Oct 2026 17:56:09 +0200
Message-ID: <20261017160459.290125233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83c0ed5f50dea..77c09f7495bc3 100644
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



