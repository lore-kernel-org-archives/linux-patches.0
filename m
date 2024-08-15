Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A931AC893;
	Thu, 15 Aug 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733012; cv=none; b=f8l01pjTqKk1N9PAj0+/SHyvGdt3Wx+yeYEQPb+2dCeCRmaTT8TGVj1tm4TDErPj2Qegre9dRNeDMV8yxG4vgPTcVMFI2UB3NF/nl7PvwjzjA1v4zOiL632uIBL4ZRFq7gUOWU3xk65jQKHBqHNL0MUzrAKKqGlllpnzmvVhJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733012; c=relaxed/simple;
	bh=jdEmxlVoL/wcfzzDxzlkTAO0AOJ9KcxMlH5tyKBC8Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdRo80sAy9/ok+Rea6Zx1DLHJ3kJqL3AAMY3ikbGz9JuCw1grKiTyIBI779vFYODdnbBdb7EdYGkYvtZ6BFKlw6wgFVlkLna9a2/p69y6LoDUE68sFjYRPSiYBYMn5ZBWi6k8mCeIh1urmd56MuKC7rRwjyfjZAgsFcKAJOcOdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1/akCrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1/akCrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40398C32786;
	Thu, 15 Aug 2024 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733011;
	bh=jdEmxlVoL/wcfzzDxzlkTAO0AOJ9KcxMlH5tyKBC8Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1/akCrrrce0kxNdmUXBsbxbjYgJGgJFdB3a0RWtQ7qZX9ao5I03oBhLp1ryAxpkW
	 RTdn+r10awEd9dCLIp9To1VgLIfF8w37Yh/DBNcty80d60cyYJRRQt2PEflrjqKWXf
	 FV26MT2ECP9C3jPQW35ifHQmDqNicHYxzdgDhRaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 323/352] tracing: Fix overflow in get_free_elt()
Date: Thu, 15 Aug 2024 15:26:29 +0200
Message-ID: <20240815131931.938303644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

commit bcf86c01ca4676316557dd482c8416ece8c2e143 upstream.

"tracing_map->next_elt" in get_free_elt() is at risk of overflowing.

Once it overflows, new elements can still be inserted into the tracing_map
even though the maximum number of elements (`max_elts`) has been reached.
Continuing to insert elements after the overflow could result in the
tracing_map containing "tracing_map->max_size" elements, leaving no empty
entries.
If any attempt is made to insert an element into a full tracing_map using
`__tracing_map_insert()`, it will cause an infinite loop with preemption
disabled, leading to a CPU hang problem.

Fix this by preventing any further increments to "tracing_map->next_elt"
once it reaches "tracing_map->max_elt".

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 08d43a5fa063e ("tracing: Add lock-free tracing_map")
Co-developed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Link: https://lore.kernel.org/20240805055922.6277-1-Tze-nan.Wu@mediatek.com
Signed-off-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/tracing_map.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -454,7 +454,7 @@ static struct tracing_map_elt *get_free_
 	struct tracing_map_elt *elt = NULL;
 	int idx;
 
-	idx = atomic_inc_return(&map->next_elt);
+	idx = atomic_fetch_add_unless(&map->next_elt, 1, map->max_elts);
 	if (idx < map->max_elts) {
 		elt = *(TRACING_MAP_ELT(map->elts, idx));
 		if (map->ops && map->ops->elt_init)
@@ -699,7 +699,7 @@ void tracing_map_clear(struct tracing_ma
 {
 	unsigned int i;
 
-	atomic_set(&map->next_elt, -1);
+	atomic_set(&map->next_elt, 0);
 	atomic64_set(&map->hits, 0);
 	atomic64_set(&map->drops, 0);
 
@@ -783,7 +783,7 @@ struct tracing_map *tracing_map_create(u
 
 	map->map_bits = map_bits;
 	map->max_elts = (1 << map_bits);
-	atomic_set(&map->next_elt, -1);
+	atomic_set(&map->next_elt, 0);
 
 	map->map_size = (1 << (map_bits + 1));
 	map->ops = ops;


