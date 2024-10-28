Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7287F8837;
	Mon, 28 Oct 2024 06:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098372; cv=none; b=jHd8BxRP5s2hSkFRlWB19RvXkxa/2yL89wqi0cIkNXl424Azc0jAHxVUqkH6UdFQxiYAXJECfGNrTPkYY7KSpUzt0diicOYReVV01aQLA1HAT384z1bl5K6seERcIOiFhDpkGZ0gLkAG0aOrGXzgAuttWBcb9lUNCS0Mrvr1ui4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098372; c=relaxed/simple;
	bh=gijV34DYHc27QIxrDglO5Vrp0OQCLZrtVW66Vmt1/cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktX56JEqX1YhEZokcpInMzovvBqA/8T/6P4S8s7dru5Ixp3frvhlMGJs89HfgP2N/Ixwtq6QdE9gow8jJXEJ58EKHWxH4E8kBOIFb17/JNNBVgzluRpXoBDY5UtTLBCpn/YyE95wPavSAibMI8+m6UsJW4IxWJ096bwz11koFnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJoHX9tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJoHX9tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ABCC4CEC7;
	Mon, 28 Oct 2024 06:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098372;
	bh=gijV34DYHc27QIxrDglO5Vrp0OQCLZrtVW66Vmt1/cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJoHX9tIsiLHJy6fchfCFquKt9QPCE6BseZKkbcDfgGtMdRc0RemoRqTf0gXg+vYi
	 uM8CofmWWiKpIOv6VqojDmsjPcqvAqJ/nx6Dz00hw0Qr9X4RUQRBY1Bg5YVqDBqMtm
	 tVBZw3o8qbDjDo2AjpoN+IKdYvg2HzaYcndRb09U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 197/261] cifs: fix warning when destroy cifs_io_request_pool
Date: Mon, 28 Oct 2024 07:25:39 +0100
Message-ID: <20241028062316.982250520@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 2ce1007f42b8a6a0814386cb056feb28dc6d6091 ]

There's a issue as follows:
WARNING: CPU: 1 PID: 27826 at mm/slub.c:4698 free_large_kmalloc+0xac/0xe0
RIP: 0010:free_large_kmalloc+0xac/0xe0
Call Trace:
 <TASK>
 ? __warn+0xea/0x330
 mempool_destroy+0x13f/0x1d0
 init_cifs+0xa50/0xff0 [cifs]
 do_one_initcall+0xdc/0x550
 do_init_module+0x22d/0x6b0
 load_module+0x4e96/0x5ff0
 init_module_from_file+0xcd/0x130
 idempotent_init_module+0x330/0x620
 __x64_sys_finit_module+0xb3/0x110
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Obviously, 'cifs_io_request_pool' is not created by mempool_create().
So just use mempool_exit() to revert 'cifs_io_request_pool'.

Fixes: edea94a69730 ("cifs: Add mempools for cifs_io_request and cifs_io_subrequest structs")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Acked-by: David Howells <dhowells@redhat.com
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 33e2860010158..9bdb6e7f1dc3a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1780,7 +1780,7 @@ static int cifs_init_netfs(void)
 nomem_subreqpool:
 	kmem_cache_destroy(cifs_io_subrequest_cachep);
 nomem_subreq:
-	mempool_destroy(&cifs_io_request_pool);
+	mempool_exit(&cifs_io_request_pool);
 nomem_reqpool:
 	kmem_cache_destroy(cifs_io_request_cachep);
 nomem_req:
-- 
2.43.0



