Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00EE3C0A1E;
	Sat, 17 Oct 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259082; cv=none; b=ksmOfmZOmo5VUhVu9+ueRBuhlbeXlzabVmSrhj7XaJGrd15iUYLFHiz1WEOUk/xVQzoxPftFq7Ah9WcvqAsTNA+0v8jyvnVwUfviQQeTfGBsO8PsbhGX9WPMbUXDi6qAfleV6Vu6ubUpdbRQSn+SqEf1vGaG9So7+j5LXQJ5jk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259082; c=relaxed/simple;
	bh=C4ENv38zr2TXGdRu1ATlMixz1yr1DCdECxhVsmXod/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvpU/5mHrVYgaH0TJkDVIStD4ak2NVVcajzxHS5BH4xeVJidx0NAbupz16UR+X5lqKc8EHsd6n5nkeAd9OlAod7hVZ4AIzmOTzT/cq9LIl2duZ7D3fPLEhsYYKdJBY4Bx+Bo80aSxk7jRfztCb/GLahjuM/OgHH+a+EVRvM3EIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+wgH/n9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+wgH/n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6BF1F000C4;
	Sat, 17 Oct 2026 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259081;
	bh=G/KAbNuuarM2Zel0qinrujshw/e4yhLj30dklPJeCXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+wgH/n9OsOSq18DszuYoS419DILG2kR6BQYBWU5QvDLHRP6y+tUXNFzO+DDK2asq
	 VEk6NQA3KervvF0DoYUPPNyTnpllo4Cs0vKObJ19XcSlUDSbkR6p8aDw6s7yjqh33N
	 sQgUPyDPyQVwLeBV40bP1pA2Qrgek/sV45qgCftI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1095/1674] bpf: Disable migration when cloning sock storage
Date: Sat, 17 Oct 2026 17:56:07 +0200
Message-ID: <20261017160459.237744653@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit dfccfc47bde53f5df5bf42486d12a8a2ecdcea60 ]

bpf_sk_storage_clone() will call bpf_selem_free() to free the clone
element when the allocation of new sock storage fails. bpf_selem_free()
will call check_and_free_fields() to free the special fields in the
element. Since the allocated element is not visible to bpf syscall or
bpf program when bpf_local_storage_alloc() fails, these special fields
in the element must be all zero when invoking bpf_selem_free().

To be uniform with other callers of bpf_selem_free(), disabling
migration when cloning sock storage. Adding migrate_{disable|enable}
pair also benefits the potential switching from kzalloc to bpf memory
allocator for sock storage.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250108010728.207536-9-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7cbd0c4cebe4 ("bpf: Fix UAF in sock clone early bailouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 65287c46a6f27..83c0ed5f50dea 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -161,6 +161,7 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 
+	migrate_disable();
 	rcu_read_lock();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
@@ -213,6 +214,7 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 
 out:
 	rcu_read_unlock();
+	migrate_enable();
 
 	/* In case of an error, don't free anything explicitly here, the
 	 * caller is responsible to call bpf_sk_storage_free.
-- 
2.53.0



