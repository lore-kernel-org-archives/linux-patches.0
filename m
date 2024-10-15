Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B386F1C07DB;
	Tue, 15 Oct 2024 13:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997539; cv=none; b=AZ60vXVp3gH4+PueS11JjWkllxw57OeleyBFeO817QIsB04dxau0QQOdJoxksuD8J9zuP+LrQjJdxIxrV04pNYsjTKnuVgWoHlp5ZB7SOZPZPedRx+I0XAFlb91tXpvRKOBlS2dSk52HrVe3WiT9ZBBSf7z3sGr6E3/uGL4ni3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997539; c=relaxed/simple;
	bh=KmqiT1ZaUOUy133FfgvnXsho6OQXlA1CF9WihsW5BRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWQMRjIm7FK2BShkJgeC8HC6w0Bez4e2jOSLM4BaYAKyhPXNxDGU0wo2NgmpoucSu3CmUq5j7ptZjL1Maz++9Kng+ojz8VtSun3bjJGLBC0OoAKgugpga2Gs5ypqwbjAsolEK0AnOUuJH8HbQ0DU9clx5TViQMLERTRy0puBoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msPDumIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msPDumIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23780C4CEC6;
	Tue, 15 Oct 2024 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997539;
	bh=KmqiT1ZaUOUy133FfgvnXsho6OQXlA1CF9WihsW5BRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msPDumIr45CEYTksWd7UEs1DB70uI6pR5uxYRZWQYmB8uEK3D0oDg2e+d0ZjSSTSr
	 Hz6dLEoHhonBRVsjeYiNFp9zQsa9bf6r5gjhAK4KprJzjvo8KaBwKOROuKtm51j3ax
	 6H93qsbJ91v4A4TIxkHduOnddtbclxMhlcLNRhfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 213/518] Revert "bpf: Eliminate rlimit-based memory accounting for devmap maps"
Date: Tue, 15 Oct 2024 14:41:57 +0200
Message-ID: <20241015123925.213792215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pu Lehui <pulehui@huawei.com>

This reverts commit 70294d8bc31f3b7789e5e32f757aa9344556d964 which is
commit 844f157f6c0a905d039d2e20212ab3231f2e5eaf upstream.

Commit 70294d8bc31f ("bpf: Eliminate rlimit-based memory accounting for
devmap maps") is part of the v5.11+ base mechanism of memcg-based memory
accounting[0]. The commit cannot be independently backported to the 5.10
stable branch, otherwise the related memory when creating devmap will be
unrestricted. Let's roll back to rlimit-based memory accounting mode for
devmap.

Link: https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com [0]
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -109,6 +109,8 @@ static inline struct hlist_head *dev_map
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
 	u32 valsize = attr->value_size;
+	u64 cost = 0;
+	int err;
 
 	/* check sanity of attributes. 2 value sizes supported:
 	 * 4 bytes: ifindex
@@ -133,13 +135,21 @@ static int dev_map_init_map(struct bpf_d
 
 		if (!dtab->n_buckets) /* Overflow check */
 			return -EINVAL;
+		cost += (u64) sizeof(struct hlist_head) * dtab->n_buckets;
+	} else {
+		cost += (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev *);
 	}
 
+	/* if map size is larger than memlock limit, reject it */
+	err = bpf_map_charge_init(&dtab->map.memory, cost);
+	if (err)
+		return -EINVAL;
+
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
 							   dtab->map.numa_node);
 		if (!dtab->dev_index_head)
-			return -ENOMEM;
+			goto free_charge;
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
@@ -147,10 +157,14 @@ static int dev_map_init_map(struct bpf_d
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
-			return -ENOMEM;
+			goto free_charge;
 	}
 
 	return 0;
+
+free_charge:
+	bpf_map_charge_finish(&dtab->map.memory);
+	return -ENOMEM;
 }
 
 static struct bpf_map *dev_map_alloc(union bpf_attr *attr)


