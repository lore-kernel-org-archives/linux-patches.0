Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FB336B93B;
	Sat, 17 Oct 2026 16:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254284; cv=none; b=QW+kv5BhUygIup6vl5wVRKBxpmtyNEiJOr8u/FPIvwMcs8r2JRlRCGrhP5ofIJ8vIatsenOXX6lxgTSNwG5MKROzeoTwv+vCsW6Rgky/QwxGFYwrMs4JTCEf2laiw0yMerQ08Xi0Hw3I6kYwpLe7DyDo4KAgcnF/TN/QHagXRK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254284; c=relaxed/simple;
	bh=/tuBMznIxUXMEGw/U05nGgIEoWM77zJwP2vLr+PxBdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M64yCpARri2qAN5EkeKV73RdzQ+eyMqQ47/yujsu8mriVNYSjFNPY/EUtiyyJQCnZK8F6Zbbay1ctBklGPzxvRgphOqSMBR9RvTZDvAzbJhfwxtvMnNDeVxTOh0AqWv3xgqzCFcq0gJT+hb+f77143cvxjNdob2OCGjWoPJP5eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6oOA4hC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6oOA4hC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ABA1F000C4;
	Sat, 17 Oct 2026 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254282;
	bh=f9VNG6sjEhIosvjR9YgR3mikO/4qkw9kwVNsrmq2GYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6oOA4hCNglLiREeEOb82mqhYF9fHVUpXsUnnj3c+77oGw/df5nx7o3w0apsqTzKf
	 f1jax0Dir+oxnEzthFvOIm6BQzY+5npI1yPIsdFegzws+5jCo9Egs8Q7bNrjOZRR/G
	 y9x9Yx8vV6t+5X/2uO/bax7VK0sNj7Sm4d9HTkGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/869] bpf: Disable migration when destroying sock storage
Date: Sat, 17 Oct 2026 17:53:58 +0200
Message-ID: <20261017160047.298761985@linuxfoundation.org>
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
index bc01b3aa6b0fa..5cd1220cc7a5e 100644
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



