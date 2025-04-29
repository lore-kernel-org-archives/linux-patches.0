Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA921ABDB;
	Tue, 29 Apr 2025 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947182; cv=none; b=eeOD61MVV9f1SzH4z+cwWZ7+nDgZ1+kFg146jClDWJdGMmTw9HFHB41rkYnM7Ld97pzKpwl6cqKQ/PeqcGpl9HMy7S+5Omm/wcXFTCIJk1hgLyx4I2WzEkE8/aEZ68OD7EMINxx2MxQWeuO8pB1ui/cmYmVwDmQuOdoZjSPLaYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947182; c=relaxed/simple;
	bh=mPNT4DKM+f5efkyrolEWiDARQ9ZRwh3oLkejb29+VBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USVaK+foIWQitndTZJYSyxmIKgmyEz8NgxoT53hREUVqHwHtGjEWgBKN5OV+u5aNJb1gnjC5EzcDNp0c175SydayWtsam7LpSyvWzZuZX5R46JGedHDMrMcCKgMmb35NupH41wQJKXsXzT694bfCywJln03U5A1XAtV/xDgvT30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0IjMb9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0IjMb9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8356BC4CEE3;
	Tue, 29 Apr 2025 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947181;
	bh=mPNT4DKM+f5efkyrolEWiDARQ9ZRwh3oLkejb29+VBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0IjMb9mDNYTfxxYFwOU1EKpx4mUXNv6Qq0te9hQp9z8A8qtl71XIXvzKjwpGyrEy
	 kcaxtxXWfUoOuvR0jzQGb78Noq91ew+FrVj6zvDHuAaijWxpZOxm+6FkziGoglTQVJ
	 IYFeQP8mWbO5gS2BkK11hPvVJq8FxBA/Zt5tnVHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 169/286] bpf: Check rcu_read_lock_trace_held() before calling bpf map helpers
Date: Tue, 29 Apr 2025 18:41:13 +0200
Message-ID: <20250429161114.836721622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit 169410eba271afc9f0fb476d996795aa26770c6d upstream.

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
[Minor conflict resolved due to code context change.]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/helpers.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3,6 +3,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/rcupdate.h>
+#include <linux/rcupdate_trace.h>
 #include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/topology.h>
@@ -24,12 +25,12 @@
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
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 	return (unsigned long) map->ops->map_lookup_elem(map, key);
 }
 
@@ -45,7 +46,7 @@ const struct bpf_func_proto bpf_map_look
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 	return map->ops->map_update_elem(map, key, value, flags);
 }
 
@@ -62,7 +63,7 @@ const struct bpf_func_proto bpf_map_upda
 
 BPF_CALL_2(bpf_map_delete_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
 	return map->ops->map_delete_elem(map, key);
 }
 


