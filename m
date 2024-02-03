Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1006310795;
	Sat,  3 Feb 2024 04:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933360; cv=none; b=hqZBo/t+x64qCEXoGAZXqMWiMCKZbm2WRg+ttiRrRI1wAIOLnuiBk8aPK7RY2Dkz9jPWbKVvxFGRTjo/E/vrdPljtfrjgL1ySkv+nyaNSmPbsZbMbA7Jl3LxquYjjL7wKLqEz/vAVqQcf/zejyrTKX5uv13zaaf1t4Uc/AJRTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933360; c=relaxed/simple;
	bh=5MEtqB170UnplAhK+8lqAjorG4zmlSoWMQpGPlaNCyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBpy128ybBJwEH/JY4KjSFKaqpgeIUzDAXqNgCznu14wj0oRGzpgOb1taUiWzRrEqhtrqR/l9pQSLlerf/WqG+5zvN29HqOHbpQXX/9GSdn1kRzwJjET408W46VJZBZ+I9rAUP7/uUa734M9T9fuVVDL5KnnP6Wb51uQeOL8FlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eq1c1kt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eq1c1kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDEDC433C7;
	Sat,  3 Feb 2024 04:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933359;
	bh=5MEtqB170UnplAhK+8lqAjorG4zmlSoWMQpGPlaNCyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eq1c1kteLYE96eWS1l3DVql9Y2ahEJJ5EbcyVYNeqfuIpGEVRYA6y0CDGEFaLakQ
	 rjNOV/DurtKClX+82d3wvTGbH7U5wDQv8y+zmtGZIjGV7nW+2mF6327e0QrYNi2nLu
	 oHN+GjYzsj3OFbgwuWDM6LqQiW7Y2h4hB46itXeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/219] bpf: Check rcu_read_lock_trace_held() before calling bpf map helpers
Date: Fri,  2 Feb 2024 20:03:56 -0800
Message-ID: <20240203035325.695166070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 169410eba271afc9f0fb476d996795aa26770c6d ]

These three bpf_map_{lookup,update,delete}_elem() helpers are also
available for sleepable bpf program, so add the corresponding lock
assertion for sleepable bpf program, otherwise the following warning
will be reported when a sleepable bpf program manipulates bpf map under
interpreter mode (aka bpf_jit_enable=0):

  WARNING: CPU: 3 PID: 4985 at kernel/bpf/helpers.c:40 ......
  CPU: 3 PID: 4985 Comm: test_progs Not tainted 6.6.0+ #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996) ......
  RIP: 0010:bpf_map_lookup_elem+0x54/0x60
  ......
  Call Trace:
   <TASK>
   ? __warn+0xa5/0x240
   ? bpf_map_lookup_elem+0x54/0x60
   ? report_bug+0x1ba/0x1f0
   ? handle_bug+0x40/0x80
   ? exc_invalid_op+0x18/0x50
   ? asm_exc_invalid_op+0x1b/0x20
   ? __pfx_bpf_map_lookup_elem+0x10/0x10
   ? rcu_lockdep_current_cpu_online+0x65/0xb0
   ? rcu_is_watching+0x23/0x50
   ? bpf_map_lookup_elem+0x54/0x60
   ? __pfx_bpf_map_lookup_elem+0x10/0x10
   ___bpf_prog_run+0x513/0x3b70
   __bpf_prog_run32+0x9d/0xd0
   ? __bpf_prog_enter_sleepable_recur+0xad/0x120
   ? __bpf_prog_enter_sleepable_recur+0x3e/0x120
   bpf_trampoline_6442580665+0x4d/0x1000
   __x64_sys_getpgid+0x5/0x30
   ? do_syscall_64+0x36/0xb0
   entry_SYSCALL_64_after_hwframe+0x6e/0x76
   </TASK>

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231204140425.1480317-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 6212e4ae084b..34135fbd6097 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -28,12 +28,13 @@
  *
  * Different map implementations will rely on rcu in map methods
  * lookup/update/delete, therefore eBPF programs must run under rcu lock
- * if program is allowed to access maps, so check rcu_read_lock_held in
- * all three functions.
+ * if program is allowed to access maps, so check rcu_read_lock_held() or
+ * rcu_read_lock_trace_held() in all three functions.
  */
 BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 	return (unsigned long) map->ops->map_lookup_elem(map, key);
 }
 
@@ -49,7 +50,8 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 	return map->ops->map_update_elem(map, key, value, flags);
 }
 
@@ -66,7 +68,8 @@ const struct bpf_func_proto bpf_map_update_elem_proto = {
 
 BPF_CALL_2(bpf_map_delete_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 	return map->ops->map_delete_elem(map, key);
 }
 
-- 
2.43.0



