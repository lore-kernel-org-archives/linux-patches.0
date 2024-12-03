Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233B1F7567;
	Tue,  3 Dec 2024 16:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242650; cv=none; b=fGpyk4PKzTWQ+ThCoUvwOlPSCY6oxJWbQf0qEc/JHHZDqAfaLq4/uWfNd/AubJ5BKkUEGjusTK+eYuhv5g5c1U7Adn3eRnms/le9aJOng3nGtDqC0710Outcrxg0Taf2gSwYH1RC3aTpRUeZ4F+T762OixfzgUNes1HU0doMMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242650; c=relaxed/simple;
	bh=cAGurfIRCWAQfJ9HijU0u9PwuRQLsgKdp1XBbXtxqrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emfeHNAIDiw6Ajx7GmDdNzxyzJrujjhIyMGVRnTyQPr7E1T0xRiOdVtuGS4c8XXhUS6Vs79BBc6rdu8SCaEWoxUBRzBYXxxGsqjCSk/UcIUwxsO0/tQehXtzIxCZsEWZkNnRheMG7dYPkeltqyHTRmEZqIWTzJrJ5JLgWhziBDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow42VEfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow42VEfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB6FC4CECF;
	Tue,  3 Dec 2024 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242650;
	bh=cAGurfIRCWAQfJ9HijU0u9PwuRQLsgKdp1XBbXtxqrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow42VEfYt0nnXKf1mx67v2RG+AR2T/WG14A1UF2YHayrXssDRekah41w+N5nUR7AB
	 bm3MJxCcbEqoGS410b7wO/9bbgzUe4w6/rWdlfGKSR1ehOYJQEOO/YJCFE1DV03ilH
	 mPmQPgOQEhlXxYmaKufR8cf4dHGfcOQHsDkF4zv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 768/826] ipc: fix memleak if msg_init_ns failed in create_ipc_ns
Date: Tue,  3 Dec 2024 15:48:15 +0100
Message-ID: <20241203144813.725214919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Wupeng <mawupeng1@huawei.com>

commit bc8f5921cd69188627c08041276238de222ab466 upstream.

Percpu memory allocation may failed during create_ipc_ns however this
fail is not handled properly since ipc sysctls and mq sysctls is not
released properly. Fix this by release these two resource when failure.

Here is the kmemleak stack when percpu failed:

unreferenced object 0xffff88819de2a600 (size 512):
  comm "shmem_2nstest", pid 120711, jiffies 4300542254
  hex dump (first 32 bytes):
    60 aa 9d 84 ff ff ff ff fc 18 48 b2 84 88 ff ff  `.........H.....
    04 00 00 00 a4 01 00 00 20 e4 56 81 ff ff ff ff  ........ .V.....
  backtrace (crc be7cba35):
    [<ffffffff81b43f83>] __kmalloc_node_track_caller_noprof+0x333/0x420
    [<ffffffff81a52e56>] kmemdup_noprof+0x26/0x50
    [<ffffffff821b2f37>] setup_mq_sysctls+0x57/0x1d0
    [<ffffffff821b29cc>] copy_ipcs+0x29c/0x3b0
    [<ffffffff815d6a10>] create_new_namespaces+0x1d0/0x920
    [<ffffffff815d7449>] copy_namespaces+0x2e9/0x3e0
    [<ffffffff815458f3>] copy_process+0x29f3/0x7ff0
    [<ffffffff8154b080>] kernel_clone+0xc0/0x650
    [<ffffffff8154b6b1>] __do_sys_clone+0xa1/0xe0
    [<ffffffff843df8ff>] do_syscall_64+0xbf/0x1c0
    [<ffffffff846000b0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

Link: https://lkml.kernel.org/r/20241023093129.3074301-1-mawupeng1@huawei.com
Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -83,13 +83,15 @@ static struct ipc_namespace *create_ipc_
 
 	err = msg_init_ns(ns);
 	if (err)
-		goto fail_put;
+		goto fail_ipc;
 
 	sem_init_ns(ns);
 	shm_init_ns(ns);
 
 	return ns;
 
+fail_ipc:
+	retire_ipc_sysctls(ns);
 fail_mq:
 	retire_mq_sysctls(ns);
 


