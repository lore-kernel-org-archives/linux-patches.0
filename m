Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B11936B93B;
	Sat, 17 Oct 2026 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254290; cv=none; b=tXUO0mVo1FYkBpT3JMWNxBMPcmPNjWECVn4qJvF6baNO5Kme9Y3PWIHTo4lL/OFhKw4UKEj6Gip+FAGhb4og1/058uGYLCX0KHuFxzLyMC8fyihVmP5iTDxicWpnbdpOdm8Xdr1fV7WuX6AU6YQ5VH6R+OqhirbLuqOGs7zD464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254290; c=relaxed/simple;
	bh=vCcSn+qtMCdiYYGc1VuI+tDsMNCXMjUpha86b2p0nog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1MuKBHC+0xRE009pHh8Z/+Hf/YdrmbFBWCRmPqaZeRenJxIhQm+RWLxYfThMqHCXr6AbMkeY4fhEbZoD7QLAAulOqbWF/yWYsmpQ6ApKPUeCHi9mXXh2il7P2Ej+05Cubs8veac3lgycildrxuOjYc7/DQZuMPSrFuq2CYTlaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYaginA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYaginA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988D11F000C4;
	Sat, 17 Oct 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254289;
	bh=a/Ip+e3FmNAkYGJHWGFJnjkcTZfU5tQBjqKWF8LUdYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYaginA6Bz8XxLFuPKdfWo3hpeHqxD9ilomdP338ugUZTpiwmCp0ZDwe6HpBeoEPK
	 0miZiYcCoPwrZ3B+xCNoikjhokRKcdrwYYMAIni8FoihYh5KK6+B2hLKjT48n2dc+v
	 NycwJlvdljXAUUTz+/YkJP56VRQrEUOmpZ5Ljm0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/869] bpf: Disable migration when cloning sock storage
Date: Sat, 17 Oct 2026 17:53:59 +0200
Message-ID: <20261017160047.326870144@linuxfoundation.org>
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
index 5cd1220cc7a5e..50ce498742596 100644
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



