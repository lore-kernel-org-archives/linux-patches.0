Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4FD375F88;
	Tue, 13 Oct 2026 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893566; cv=none; b=fCAfFUED+nw5TKMzLmJgk1gA2qeH6aR3EuILDDlgpp4YeQ2SlnEe1leqj0dol8tIh1XlH0/R77Ge0JIJftUJ9ykoN1mhrUFnyXK+ctwfC5N6aaGaZf4I1NVL0LHklq2kcYVMZ454eDA2epuzsbmknUeJbOHidp48QBwh4YYbyb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893566; c=relaxed/simple;
	bh=9w7Nm3kBlNwUoL2BSBxUIwnYAVY/HcehTEQeJJ4eVRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F54vjb3Qcf/KJFUN22d2ex/SRgi1BUDUhhw+92HA5DlmC6Viqk/t1yENEboEkFHyUxi9DXnAUqlXsiObg3EBE5SCJvHhjvcxLn+h11HXDwSrfOQ0ioxms5m8+0XKQafDI9Eq25zw+g2cBASuoYNYcJ9zWjHE8WaEoWm0YhcumZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcp7scS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcp7scS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9971F000FF;
	Tue, 13 Oct 2026 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893565;
	bh=QoNQbHn1xlJdYYzsDNvD5QOvC47+7w46WWjIFdTvph8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcp7scS7taYmG8yVn7gdyQNhRQ6xirnBFCairT1zyd7Fw42/YIERzUxYvXpy1CxyT
	 TnsKVSO4S5C4spKM6Nd0KUhfDSnEPhLtsxYpa3IO+cY5/nkBgk4C/uX2UGwPj3XCMt
	 a1O6j2GXkFsii8lT+yfUHAD2kKUolL1FT74aapGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/621] bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c
Date: Tue, 13 Oct 2026 13:34:23 +0200
Message-ID: <20261013112927.222356446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e538399757fe..d3fbaf89a698d 100644
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



