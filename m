Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D02236EB;
	Tue, 30 Sep 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244737; cv=none; b=J7VtrBTJSU80EokjlIBiuhspXa5RGUm9EIuEFT3P723Jz/DEpuf4nYe0FA140pOvcsVSX8aRZF7ua5lV4YvLn9+TNpsxXJHy6bWT/UEaEArTiQZ9bGWhYHJoBlS27ifFANDimSeCGKbtpbiTDE56mdg1wwc8zZoTkpwBq0WTpvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244737; c=relaxed/simple;
	bh=kK60t0qUC5EJvBBxAwQ1lMaBW1zIWJG/4t8j7mTOBDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ2CLZvqae93Lq7rfcWy4+QKRBxypzf6lE7BKTqTKaT+mLX2bsk+3c6I2gXoR72eNsZs1XN4fYpvwqqfTJDVtpPHu58Oy+qMSmz0hO085KNIMZudtyfH7c0AIXXgu/3opLEryFxedoE6+qm7liZCbHuqxV7wzOGPO5Yt1gsoSFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJe0dEvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJe0dEvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3077C4CEF0;
	Tue, 30 Sep 2025 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244737;
	bh=kK60t0qUC5EJvBBxAwQ1lMaBW1zIWJG/4t8j7mTOBDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJe0dEvjN0Pq0fWeg5cuH5lmxD5Wznet+e32o/TohTzxQSDinlX9hpuH4k1VcKG/l
	 g52PlqQ7JOU5TdyvYi08RqhgItiXIoOyllJKQX4tzbkFlNQs/g38YO8frVYHDabMei
	 DingI/v6aPI6q32kOcSsab9v/8wFgIKbS9kn504Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tglozar@redhat.com,
	Wang Liang <wangliang74@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 099/143] tracing/osnoise: Fix slab-out-of-bounds in _parse_integer_limit()
Date: Tue, 30 Sep 2025 16:47:03 +0200
Message-ID: <20250930143835.173033843@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit a2501032de0d1bc7971b2e43c03da534ac10ee9b ]

When config osnoise cpus by write() syscall, the following KASAN splat may
be observed:

BUG: KASAN: slab-out-of-bounds in _parse_integer_limit+0x103/0x130
Read of size 1 at addr ffff88810121e3a1 by task test/447
CPU: 1 UID: 0 PID: 447 Comm: test Not tainted 6.17.0-rc6-dirty #288 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x55/0x70
 print_report+0xcb/0x610
 kasan_report+0xb8/0xf0
 _parse_integer_limit+0x103/0x130
 bitmap_parselist+0x16d/0x6f0
 osnoise_cpus_write+0x116/0x2d0
 vfs_write+0x21e/0xcc0
 ksys_write+0xee/0x1c0
 do_syscall_64+0xa8/0x2a0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This issue can be reproduced by below code:

const char *cpulist = "1";
int fd=open("/sys/kernel/debug/tracing/osnoise/cpus", O_WRONLY);
write(fd, cpulist, strlen(cpulist));

Function bitmap_parselist() was called to parse cpulist, it require that
the parameter 'buf' must be terminated with a '\0' or '\n'. Fix this issue
by adding a '\0' to 'buf' in osnoise_cpus_write().

Cc: <mhiramat@kernel.org>
Cc: <mathieu.desnoyers@efficios.com>
Cc: <tglozar@redhat.com>
Link: https://lore.kernel.org/20250916063948.3154627-1-wangliang74@huawei.com
Fixes: 17f89102fe23 ("tracing/osnoise: Allow arbitrarily long CPU string")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 337bc0eb5d71b..dc734867f0fc4 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2325,12 +2325,13 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	if (count < 1)
 		return 0;
 
-	buf = kmalloc(count, GFP_KERNEL);
+	buf = kmalloc(count + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	if (copy_from_user(buf, ubuf, count))
 		return -EFAULT;
+	buf[count] = '\0';
 
 	if (!zalloc_cpumask_var(&osnoise_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
-- 
2.51.0



