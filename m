Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB333C6A5C;
	Sat, 17 Oct 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259079; cv=none; b=rJEoCZr+XNQRJZs47eOIweo1yA2KKV0yxcEn9z4UuwFosx94Tu2eJOCDHLoNYAjU1TAVdo9kEAoEhjNG2YG02QeX22mcbiQCUdaXL26sowBek3rt1re7v8P0HiWmHLkvU4pEgoBYc5zBZPXSHpJVrWIaClims4plLTZjIFcRAAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259079; c=relaxed/simple;
	bh=pVyjpf1ACjNmq91nF5944tCK0ZQIYPs7EktCbuJzUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGHAheJ1Q88pMXAsUYOxe2u0CpGjWzr1O+3w3afIZ9TdNl7Hrv6/13fy8lVqN1mdnBx2xOq6H/RLlR+DNm5Uh8ENUILeJ/ZgC8XqQ9a6kZhaW9oKISVwPkUQwwXn1En0hjyejrpMafxfByJPPO2zqwwbX5SLqs39tbyuFNyhmbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXT4HoS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXT4HoS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9021F000C9;
	Sat, 17 Oct 2026 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259078;
	bh=sxO+oHzETBM4MPQ6uPIBvUzllFvzopdMdpgsYqsuzZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXT4HoS7m5lz5KoufqT5IJVhbXuXhYIpRrprs079cAebiRu/UqRaqNHjHuFjhr5lF
	 4agcdajG2QPExDfj17T/tHd1ApdNjXLgsZi1frA9IDpxd4lqt3XVSxZwrJ6QVME/Xp
	 lbd9epDcxa82H9Bot8bVphP07yB/Xn/bxN+SklZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1094/1674] bpf: Disable migration when destroying sock storage
Date: Sat, 17 Oct 2026 17:56:06 +0200
Message-ID: <20261017160459.213799164@linuxfoundation.org>
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

[ Upstream commit 7d1032d1e3031ef38d1a360380d755f75cb639b8 ]

When destroying sock storage, it invokes bpf_local_storage_destroy() to
remove all storage elements saved in the sock storage. The destroy
procedure will call bpf_selem_free() to free the element, and
bpf_selem_free() calls bpf_obj_free_fields() to free the special fields
in map value (e.g., kptr). Since kptrs may be allocated from bpf memory
allocator, migrate_{disable|enable} pairs are necessary for the freeing
of these kptrs.

To simplify reasoning about when migrate_disable() is needed for the
freeing of these dynamically-allocated kptrs, let the caller to
guarantee migration is disabled before invoking bpf_obj_free_fields().
Therefore, the patch adds migrate_{disable|enable} pair in
bpf_sock_storage_free(). The migrate_{disable|enable} pairs in the
underlying implementation of bpf_obj_free_fields() will be removed by
The following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250108010728.207536-8-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7cbd0c4cebe4 ("bpf: Fix UAF in sock clone early bailouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index cca7594be92ec..65287c46a6f27 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -50,15 +50,16 @@ void bpf_sk_storage_free(struct sock *sk)
 {
 	struct bpf_local_storage *sk_storage;
 
+	migrate_disable();
 	rcu_read_lock();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
-	if (!sk_storage) {
-		rcu_read_unlock();
-		return;
-	}
+	if (!sk_storage)
+		goto out;
 
 	bpf_local_storage_destroy(sk_storage);
+out:
 	rcu_read_unlock();
+	migrate_enable();
 }
 
 static void bpf_sk_storage_map_free(struct bpf_map *map)
-- 
2.53.0



