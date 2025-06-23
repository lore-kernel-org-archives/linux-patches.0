Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293B94409;
	Mon, 23 Jun 2025 21:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714672; cv=none; b=T3qUYN7ZMAGIp/zEwwc37PUPPIogd+V7ojQnm0oojfce9DSi3W0x5C+6Seg7Tb0AOBR0Qi4qt2VZNB+yWbC7ohE+r0GhhttXkpVBU9StOGJodZ61fHxhhEL4wnYYZ/NoCyWRtODJb19cI1xDT/D4rYkfgpNdP+JlY9dF2MkvE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714672; c=relaxed/simple;
	bh=tXmSukYVWJlgmenilJ2w6BWTXAAwCf6R+3jtIeZVgpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bra+e3AEX+pRPOJVZ8FZGWDm5WDW4xAGCtJJg+L5/cn9ybJlSX9eBG3h+vxGNjB0L8iYINmqFKPMD9JVMKsMBlQrLvieoxohOjJaWQwA28uJYqIMJqUn7FVymSmLvjBjGLndy24o2ED41Ehx2T4dgdtU6LJ1pwBgXS54JSlRyG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmJeJQW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmJeJQW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C58C4CEEA;
	Mon, 23 Jun 2025 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714672;
	bh=tXmSukYVWJlgmenilJ2w6BWTXAAwCf6R+3jtIeZVgpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmJeJQW6NMlqIbI/+ZGiToc/TOffj7GAt/emHzogHSBTUwo2ljWHIfMctLkxDEN/k
	 3mJHVPyewfW7wE3rNrccCWMZROxNEJXQ8DoLlo6GDS5UhsC0maa3yPR1q0H7jBnE1X
	 nGuZVk6ZvMFPaTp3RZ7mR+Nj3XFOxwBRz8mhw3Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 202/411] nfsd: Initialize ssc before laundromat_work to prevent NULL dereference
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130638.757990072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

commit b31da62889e6d610114d81dc7a6edbcaa503fcf8 upstream.

In nfs4_state_start_net(), laundromat_work may access nfsd_ssc through
nfs4_laundromat -> nfsd4_ssc_expire_umount. If nfsd_ssc isn't initialized,
this can cause NULL pointer dereference.

Normally the delayed start of laundromat_work allows sufficient time for
nfsd_ssc initialization to complete. However, when the kernel waits too
long for userspace responses (e.g. in nfs4_state_start_net ->
nfsd4_end_grace -> nfsd4_record_grace_done -> nfsd4_cld_grace_done ->
cld_pipe_upcall -> __cld_pipe_upcall -> wait_for_completion path), the
delayed work may start before nfsd_ssc initialization finishes.

Fix this by moving nfsd_ssc initialization before starting laundromat_work.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -427,13 +427,13 @@ static int nfsd_startup_net(struct net *
 	if (ret)
 		goto out_filecache;
 
+#ifdef CONFIG_NFSD_V4_2_INTER_SSC
+	nfsd4_ssc_init_umount_work(nn);
+#endif
 	ret = nfs4_state_start_net(net);
 	if (ret)
 		goto out_reply_cache;
 
-#ifdef CONFIG_NFSD_V4_2_INTER_SSC
-	nfsd4_ssc_init_umount_work(nn);
-#endif
 	nn->nfsd_net_up = true;
 	return 0;
 


