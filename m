Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDAC1F76BB;
	Tue,  3 Dec 2024 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239864; cv=none; b=Bi5/ER32BtXmtAxc2Y/pX7AuNTeebcnm5J5TirfieAh1E7hly/xQ6EtvWqye3u0wuyxITzN9xbfNbUWYALtOAZjSSnr6VgMAHVj9hA9fla6AeqrzumMmMmbJqXER7jOGRCTA9ciy9aZfBQcMmZ3OFi1xsr4qCPOdS4L8g6Suxic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239864; c=relaxed/simple;
	bh=RIwzQloxJ20xgEqR7TEZ5bb+7PVR0ZSzzD4gpw86b4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhB/TfEeLXVK2pz5SZEzcQKlSYkueVAq4R6u7Y0DZeg1nWt7KsTBewAMohsXkU43aLbnLpWe89k2LV82ir3Y16uYarNvEs6HmuiGyhLGG4VJ1Qgv8vDQUi17bL1DCxaTd+7pwTiGaNBXzMmHyQ2zmrYqTb25lUpq9TyZ0qVafSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEUGmNCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEUGmNCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAD7C4CECF;
	Tue,  3 Dec 2024 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239864;
	bh=RIwzQloxJ20xgEqR7TEZ5bb+7PVR0ZSzzD4gpw86b4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEUGmNCpgVPHjhPMhv3Qy1KMYrzBo1QKPAIeCnpanQwQBi+KX3gYypfl9ktxPIbSJ
	 9R/gG0oMljbDKFFVVtIeFLgXiMLqb2LZzNAHgSWxZ0lywLs9louXmxW32YwEKZEYxy
	 QIYbjnxLAZXA8se6Xn8OIjWYeoIPjZ9/UX8sBlyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Wupeng <mawupeng1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 761/817] ipc: fix memleak if msg_init_ns failed in create_ipc_ns
Date: Tue,  3 Dec 2024 15:45:33 +0100
Message-ID: <20241203144025.699323076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


