Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0761E89C;
	Tue, 27 May 2025 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366359; cv=none; b=i0d/l7PZ7rTVwfk/a5GI5bluU0gEUbQYx+i5p3lwfFNAvUcb46SFiWHJts/UmmDVGZGQ+jQVmuwFv/2eA4UdeXXAUHZ2Zo1j/OqhoJ6JnYSM7IGG3tHv1gM2WsGxHqEw1kNl4LXCp6TpFkrhGxYrUyQFXLOuou93zRvCvYGFxAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366359; c=relaxed/simple;
	bh=+naDAzyjVI7eEwH72/rVGtMTxIX0cE5HHf9hkRB+g4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6sTdj/frEJ8lAGQOnugHU0l9BLT8NV9jfKJs1JxDGSpOEzQruSox85t9ZGh37zUovo6h0eOX1kt2CIm1XpxBO1SX+csBRtyeGQ2LVknGG1r4DLxUHhvzhnvaRKeQ+oaAuwgLbx2DmVHiPS5Es4TFr0Uy49uCzQRDR6N5rmuCNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeByTJBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeByTJBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA32C4CEE9;
	Tue, 27 May 2025 17:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366359;
	bh=+naDAzyjVI7eEwH72/rVGtMTxIX0cE5HHf9hkRB+g4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeByTJBzFBO+Obw9cclxZUpQyDsGGqkCUnmAGG6zjvdBeHyTw9IdSFZ56iKZaP9TV
	 vh8Lu26z9Baejp+WrELIIMVycVFj/zLcefOGRSpweNXS6YIMbiwBAagKcMkHvcDH4z
	 j6yDPUE8sxBdYqNUsV/q/KandKsS6wBpC22km+j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Kammerdiener <brandon.kammerdiener@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 042/783] bpf: fix possible endless loop in BPF map iteration
Date: Tue, 27 May 2025 18:17:19 +0200
Message-ID: <20250527162514.845116275@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brandon Kammerdiener <brandon.kammerdiener@intel.com>

[ Upstream commit 75673fda0c557ae26078177dd14d4857afbf128d ]

The _safe variant used here gets the next element before running the callback,
avoiding the endless loop condition.

Signed-off-by: Brandon Kammerdiener <brandon.kammerdiener@intel.com>
Link: https://lore.kernel.org/r/20250424153246.141677-2-brandon.kammerdiener@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index c308300fc72f6..c620ffb2b6629 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2224,7 +2224,7 @@ static long bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_
 		b = &htab->buckets[i];
 		rcu_read_lock();
 		head = &b->head;
-		hlist_nulls_for_each_entry_rcu(elem, n, head, hash_node) {
+		hlist_nulls_for_each_entry_safe(elem, n, head, hash_node) {
 			key = elem->key;
 			if (is_percpu) {
 				/* current cpu value for percpu map */
-- 
2.39.5



