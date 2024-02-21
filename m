Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81569954;
	Wed, 21 Feb 2024 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521122; cv=none; b=EZywMAJzhRUsvkUnsv/6Rfc7QtV6QBS0sRgkMAItTPetN2i/bS0O3NQRc3VoSOgOMCvTsrEjS0/4qFiwf4eKNDYXIzCoj6Njt3vUT1WMZ8LT29KHYS5tcMkJzmJBcq7dZUEeRoVrpqMOvk1N2zCNF+NHGjtaxzo/nZgcJY2c2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521122; c=relaxed/simple;
	bh=U4ZfJ9wIoSM545IrrfYiEpGnY+983I0qiSDDrF3PgQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWVbG7cV00GD8Ao+poJnNHSSO/LAf1Fwupfmqr3suofGxaOWMKml5LT9MD0bHz0ZFSwiroFU5zWJ4XIPp7SU06Zli+PcWYSAq30DF+9zOhNM+KJlW3E7RNIDKXVus096JdxU/jbqgmNy2XLf11qTADcvVgUG2IXt6k75rKeB9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twdwsKcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twdwsKcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C64C433C7;
	Wed, 21 Feb 2024 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521122;
	bh=U4ZfJ9wIoSM545IrrfYiEpGnY+983I0qiSDDrF3PgQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twdwsKcQYLwqeRGdoW2iVF9NIaxvMgjCBNoaAn2hGonMlHd1neuDqVBtmd15NDZlW
	 EZ6nm8YmnQ8bg/rJLf4TrEaS7qf4dciKIj7Ir+QribGBpvyF8ZY4X5snukv/cPUJbt
	 3elSYCQfBDQrxY0Wlw2OkoUgXjHoEk1svNsCDqdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/202] tracing: Ensure visibility when inserting an element into tracing_map
Date: Wed, 21 Feb 2024 14:05:30 +0100
Message-ID: <20240221125932.727219346@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 2b44760609e9eaafc9d234a6883d042fc21132a7 ]

Running the following two commands in parallel on a multi-processor
AArch64 machine can sporadically produce an unexpected warning about
duplicate histogram entries:

 $ while true; do
     echo hist:key=id.syscall:val=hitcount > \
       /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/trigger
     cat /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/hist
     sleep 0.001
   done
 $ stress-ng --sysbadaddr $(nproc)

The warning looks as follows:

[ 2911.172474] ------------[ cut here ]------------
[ 2911.173111] Duplicates detected: 1
[ 2911.173574] WARNING: CPU: 2 PID: 12247 at kernel/trace/tracing_map.c:983 tracing_map_sort_entries+0x3e0/0x408
[ 2911.174702] Modules linked in: iscsi_ibft(E) iscsi_boot_sysfs(E) rfkill(E) af_packet(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) ena(E) tiny_power_button(E) qemu_fw_cfg(E) button(E) fuse(E) efi_pstore(E) ip_tables(E) x_tables(E) xfs(E) libcrc32c(E) aes_ce_blk(E) aes_ce_cipher(E) crct10dif_ce(E) polyval_ce(E) polyval_generic(E) ghash_ce(E) gf128mul(E) sm4_ce_gcm(E) sm4_ce_ccm(E) sm4_ce(E) sm4_ce_cipher(E) sm4(E) sm3_ce(E) sm3(E) sha3_ce(E) sha512_ce(E) sha512_arm64(E) sha2_ce(E) sha256_arm64(E) nvme(E) sha1_ce(E) nvme_core(E) nvme_auth(E) t10_pi(E) sg(E) scsi_mod(E) scsi_common(E) efivarfs(E)
[ 2911.174738] Unloaded tainted modules: cppc_cpufreq(E):1
[ 2911.180985] CPU: 2 PID: 12247 Comm: cat Kdump: loaded Tainted: G            E      6.7.0-default #2 1b58bbb22c97e4399dc09f92d309344f69c44a01
[ 2911.182398] Hardware name: Amazon EC2 c7g.8xlarge/, BIOS 1.0 11/1/2018
[ 2911.183208] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[ 2911.184038] pc : tracing_map_sort_entries+0x3e0/0x408
[ 2911.184667] lr : tracing_map_sort_entries+0x3e0/0x408
[ 2911.185310] sp : ffff8000a1513900
[ 2911.185750] x29: ffff8000a1513900 x28: ffff0003f272fe80 x27: 0000000000000001
[ 2911.186600] x26: ffff0003f272fe80 x25: 0000000000000030 x24: 0000000000000008
[ 2911.187458] x23: ffff0003c5788000 x22: ffff0003c16710c8 x21: ffff80008017f180
[ 2911.188310] x20: ffff80008017f000 x19: ffff80008017f180 x18: ffffffffffffffff
[ 2911.189160] x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000a15134b8
[ 2911.190015] x14: 0000000000000000 x13: 205d373432323154 x12: 5b5d313131333731
[ 2911.190844] x11: 00000000fffeffff x10: 00000000fffeffff x9 : ffffd1b78274a13c
[ 2911.191716] x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 000000000057ffa8
[ 2911.192554] x5 : ffff0012f6c24ec0 x4 : 0000000000000000 x3 : ffff2e5b72b5d000
[ 2911.193404] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0003ff254480
[ 2911.194259] Call trace:
[ 2911.194626]  tracing_map_sort_entries+0x3e0/0x408
[ 2911.195220]  hist_show+0x124/0x800
[ 2911.195692]  seq_read_iter+0x1d4/0x4e8
[ 2911.196193]  seq_read+0xe8/0x138
[ 2911.196638]  vfs_read+0xc8/0x300
[ 2911.197078]  ksys_read+0x70/0x108
[ 2911.197534]  __arm64_sys_read+0x24/0x38
[ 2911.198046]  invoke_syscall+0x78/0x108
[ 2911.198553]  el0_svc_common.constprop.0+0xd0/0xf8
[ 2911.199157]  do_el0_svc+0x28/0x40
[ 2911.199613]  el0_svc+0x40/0x178
[ 2911.200048]  el0t_64_sync_handler+0x13c/0x158
[ 2911.200621]  el0t_64_sync+0x1a8/0x1b0
[ 2911.201115] ---[ end trace 0000000000000000 ]---

The problem appears to be caused by CPU reordering of writes issued from
__tracing_map_insert().

The check for the presence of an element with a given key in this
function is:

 val = READ_ONCE(entry->val);
 if (val && keys_match(key, val->key, map->key_size)) ...

The write of a new entry is:

 elt = get_free_elt(map);
 memcpy(elt->key, key, map->key_size);
 entry->val = elt;

The "memcpy(elt->key, key, map->key_size);" and "entry->val = elt;"
stores may become visible in the reversed order on another CPU. This
second CPU might then incorrectly determine that a new key doesn't match
an already present val->key and subsequently insert a new element,
resulting in a duplicate.

Fix the problem by adding a write barrier between
"memcpy(elt->key, key, map->key_size);" and "entry->val = elt;", and for
good measure, also use WRITE_ONCE(entry->val, elt) for publishing the
element. The sequence pairs with the mentioned "READ_ONCE(entry->val);"
and the "val->key" check which has an address dependency.

The barrier is placed on a path executed when adding an element for
a new key. Subsequent updates targeting the same key remain unaffected.

>From the user's perspective, the issue was introduced by commit
c193707dde77 ("tracing: Remove code which merges duplicates"), which
followed commit cbf4100efb8f ("tracing: Add support to detect and avoid
duplicates"). The previous code operated differently; it inherently
expected potential races which result in duplicates but merged them
later when they occurred.

Link: https://lore.kernel.org/linux-trace-kernel/20240122150928.27725-1-petr.pavlu@suse.com

Fixes: c193707dde77 ("tracing: Remove code which merges duplicates")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/tracing_map.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 83c2a0598c64..33c463967bb3 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -574,7 +574,12 @@ __tracing_map_insert(struct tracing_map *map, void *key, bool lookup_only)
 				}
 
 				memcpy(elt->key, key, map->key_size);
-				entry->val = elt;
+				/*
+				 * Ensure the initialization is visible and
+				 * publish the elt.
+				 */
+				smp_wmb();
+				WRITE_ONCE(entry->val, elt);
 				atomic64_inc(&map->hits);
 
 				return entry->val;
-- 
2.43.0



