Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF51487CD;
	Thu, 12 Dec 2024 17:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023090; cv=none; b=pz9Xkozn8mdfqOFMEea7dTQobQEWKKJwSVq8arfw0wNkru+CofChMBX6J2Wal+ZW48Ge7ip0yrcRc+7emay2K+xSMIhL0KrlZflToanBbFGLW0lqQKRjePH8V3E9UTf1v0sR5PS0uBB9nTBX7TlOzD/p644UOlDz51SagXcvGAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023090; c=relaxed/simple;
	bh=3+ElpqkLZMb3NRcsERLLsc7E6XsjlXa7KSBScZ2xPvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYguZhUdInQe06HQtE4GpiPrnCGuXmiHHJ7TQi8tKQb11ZSIdpMV8ZeuRg1ojwx+usnVQslHmV03f6ZxD1rL63NTilf0eucNy9dHirHd3SjH7VQI9D9qoZWhhFJna1F8Tcx8baZsCmKv4y1BO1JKV6t436eCHnzkGsB6SfRN7jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQB60SmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQB60SmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375A3C4CECE;
	Thu, 12 Dec 2024 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023090;
	bh=3+ElpqkLZMb3NRcsERLLsc7E6XsjlXa7KSBScZ2xPvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQB60SmRRAYF5suaxTraybKFxVHv6u7/CBBY0bDC38N/UM6ojE/ZmOHtbrncrRdvc
	 0RZig+e+oLU6F56JShCR4pAN9q+KXLDSp8YQu+Ckugd7DRul1kBIuEWYaSjJUoXArq
	 yn4NxDKoGGZIjPeDqKP1ZdHEJO+yaBlwS+vyNkiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 391/565] nfsd: make sure exp active before svc_export_show
Date: Thu, 12 Dec 2024 15:59:46 +0100
Message-ID: <20241212144327.098307540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

commit be8f982c369c965faffa198b46060f8853e0f1f0 upstream.

The function `e_show` was called with protection from RCU. This only
ensures that `exp` will not be freed. Therefore, the reference count for
`exp` can drop to zero, which will trigger a refcount use-after-free
warning when `exp_get` is called. To resolve this issue, use
`cache_get_rcu` to ensure that `exp` remains active.

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 3 PID: 819 at lib/refcount.c:25
refcount_warn_saturate+0xb1/0x120
CPU: 3 UID: 0 PID: 819 Comm: cat Not tainted 6.12.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb1/0x120
...
Call Trace:
 <TASK>
 e_show+0x20b/0x230 [nfsd]
 seq_read_iter+0x589/0x770
 seq_read+0x1e5/0x270
 vfs_read+0x125/0x530
 ksys_read+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: bf18f163e89c ("NFSD: Using exp_get for export getting")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1324,9 +1324,12 @@ static int e_show(struct seq_file *m, vo
 		return 0;
 	}
 
-	exp_get(exp);
+	if (!cache_get_rcu(&exp->h))
+		return 0;
+
 	if (cache_check(cd, &exp->h, NULL))
 		return 0;
+
 	exp_put(exp);
 	return svc_export_show(m, cd, cp);
 }


