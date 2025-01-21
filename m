Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBD1F7596;
	Tue, 21 Jan 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482303; cv=none; b=Js0Ybk1lLH6YGpxIosIYyIauth3mEan6xvd47WIF6ABdtGt/3TLRYORh6eWdbaaC8PnXGEFuDBSpQ8eQxnKvB3wBMA8niufR51xMwTEwTkb8DwoMN0WW0Upkc7n/0fT4R/Dv2bAx0NoLubBSiR+FYIRWhbXW2xulzgK9EpLBCl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482303; c=relaxed/simple;
	bh=WgFtrnVdTreZ+UqPixjbDbf7jv03DXniUTvJ6JdN3oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqcXZbgdgA7DDOWG2eWvwLx/Ce4pHMET5l+BVOiy1L83U0ccST0tAIAGLlXgo8BTTtu41HapV1sUKPo5GedxAbtrY4Qhv5eaOWY0eT3OpYZctYRFLcptcvyNnXm6PpP1CsewbE8diUgo6FR/BggqFrHUapm9REO7P+NTLEzVgj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAy7kUDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAy7kUDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C795BC4CEDF;
	Tue, 21 Jan 2025 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482303;
	bh=WgFtrnVdTreZ+UqPixjbDbf7jv03DXniUTvJ6JdN3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAy7kUDI6n5yA7S8afiNTipA2ikhbkxyBz+/pK08BKNkS49S8MQrJZKcC9GqX68MQ
	 z6a5vjqq/JWmvGM0NMBzG3gmj0iD3MHUsw38OMY3/fmG50noqwFS7xAW4plh2dIbtr
	 jOMZ3jorVEl/fQw3e6YlH3Py0pW2slRq99fRuQA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/122] bpf: Fix bpf_sk_select_reuseport() memory leak
Date: Tue, 21 Jan 2025 18:50:51 +0100
Message-ID: <20250121174533.126306860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit b3af60928ab9129befa65e6df0310d27300942bf ]

As pointed out in the original comment, lookup in sockmap can return a TCP
ESTABLISHED socket. Such TCP socket may have had SO_ATTACH_REUSEPORT_EBPF
set before it was ESTABLISHED. In other words, a non-NULL sk_reuseport_cb
does not imply a non-refcounted socket.

Drop sk's reference in both error paths.

unreferenced object 0xffff888101911800 (size 2048):
  comm "test_progs", pid 44109, jiffies 4297131437
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    80 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 9336483b):
    __kmalloc_noprof+0x3bf/0x560
    __reuseport_alloc+0x1d/0x40
    reuseport_alloc+0xca/0x150
    reuseport_attach_prog+0x87/0x140
    sk_reuseport_attach_bpf+0xc8/0x100
    sk_setsockopt+0x1181/0x1990
    do_sock_setsockopt+0x12b/0x160
    __sys_setsockopt+0x7b/0xc0
    __x64_sys_setsockopt+0x1b/0x30
    do_syscall_64+0x93/0x180
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 64d85290d79c ("bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250110-reuseport-memleak-v1-1-fa1ddab0adfe@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 54a53fae9e98f..46da488ff0703 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -11263,6 +11263,7 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
+	int err;
 
 	selected_sk = map->ops->map_lookup_elem(map, key);
 	if (!selected_sk)
@@ -11270,10 +11271,6 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
 	if (!reuse) {
-		/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
-		if (sk_is_refcounted(selected_sk))
-			sock_put(selected_sk);
-
 		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
 		 * The only (!reuse) case here is - the sk has already been
 		 * unhashed (e.g. by close()), so treat it as -ENOENT.
@@ -11281,24 +11278,33 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 		 * Other maps (e.g. sock_map) do not provide this guarantee and
 		 * the sk may never be in the reuseport group to begin with.
 		 */
-		return is_sockarray ? -ENOENT : -EINVAL;
+		err = is_sockarray ? -ENOENT : -EINVAL;
+		goto error;
 	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
 		struct sock *sk = reuse_kern->sk;
 
-		if (sk->sk_protocol != selected_sk->sk_protocol)
-			return -EPROTOTYPE;
-		else if (sk->sk_family != selected_sk->sk_family)
-			return -EAFNOSUPPORT;
-
-		/* Catch all. Likely bound to a different sockaddr. */
-		return -EBADFD;
+		if (sk->sk_protocol != selected_sk->sk_protocol) {
+			err = -EPROTOTYPE;
+		} else if (sk->sk_family != selected_sk->sk_family) {
+			err = -EAFNOSUPPORT;
+		} else {
+			/* Catch all. Likely bound to a different sockaddr. */
+			err = -EBADFD;
+		}
+		goto error;
 	}
 
 	reuse_kern->selected_sk = selected_sk;
 
 	return 0;
+error:
+	/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
+	if (sk_is_refcounted(selected_sk))
+		sock_put(selected_sk);
+
+	return err;
 }
 
 static const struct bpf_func_proto sk_select_reuseport_proto = {
-- 
2.39.5



