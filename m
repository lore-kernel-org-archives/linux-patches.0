Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F287E58C;
	Mon,  8 Apr 2024 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583505; cv=none; b=kq6ctQY/tnVTkleRyMZJqo8sU/0aZxa0v5l82mj05/Src0uuCe/xCAPBIiwaOhueVUyL9uEwMOBRofHCs4oszu+SPwzjDKKEk4jC61dIWpO8MX9buLo2H0U4VRwnbLFdX10x9olNJDjgzQjAhoZIVAyC4jEAkfVgbwLXTAZAqEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583505; c=relaxed/simple;
	bh=6Aoc2gHnEccDIaL6AQPJt/hVlrGT8pDriQaA3ihG1gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPpautE8d5xIb6aIoPKHHCAJnfB4I+TdojZBF+2ewJhoAOWT3cfu4/2j7sFwAm6xz5wI6yRb6+95s8iX1jPTQOUh3wtGXhbAr1FdyAYwujZqYx81j5dQGoaBNDpsrRU10jsDs1Exu3heVHTbU+BAWuYbnkDiJbEbDAr0Ulnl5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbDYoJCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbDYoJCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF78C433C7;
	Mon,  8 Apr 2024 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583505;
	bh=6Aoc2gHnEccDIaL6AQPJt/hVlrGT8pDriQaA3ihG1gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbDYoJCltQ3u5pNUUgq1Qi14PQUtIiJUYlvWgrZZoVX44+tOlCtw69s+1BptZYgpl
	 p/Vbl5MJ9c3mTJXWh3acgEKqIHKYuCTDj1lGKX5S+S/kujHfvYeCruzdC8svYoy87l
	 KuLPjhvwgodLzu9UrMk45uhticUF+X3Yhleo0edg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Tao <tao.peng@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 254/690] nfsd: map EBADF
Date: Mon,  8 Apr 2024 14:52:00 +0200
Message-ID: <20240408125408.821717386@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Peng Tao <tao.peng@primarydata.com>

[ Upstream commit b3d0db706c77d02055910fcfe2f6eb5155ff9d5e ]

Now that we have open file cache, it is possible that another client
deletes the file and DP will not know about it. Then IO to MDS would
fail with BADSTATEID and knfsd would start state recovery, which
should fail as well and then nfs read/write will fail with EBADF.
And it triggers a WARN() in nfserrno().

-----------[ cut here ]------------
WARNING: CPU: 0 PID: 13529 at fs/nfsd/nfsproc.c:758 nfserrno+0x58/0x70 [nfsd]()
nfsd: non-standard errno: -9
modules linked in: nfsv3 nfs_layout_flexfiles rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_connt
pata_acpi floppy
CPU: 0 PID: 13529 Comm: nfsd Tainted: G        W       4.1.5-00307-g6e6579b #7
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
 0000000000000000 00000000464e6c9c ffff88079085fba8 ffffffff81789936
 0000000000000000 ffff88079085fc00 ffff88079085fbe8 ffffffff810a08ea
 ffff88079085fbe8 ffff88080f45c900 ffff88080f627d50 ffff880790c46a48
 all Trace:
 [<ffffffff81789936>] dump_stack+0x45/0x57
 [<ffffffff810a08ea>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff810a0975>] warn_slowpath_fmt+0x55/0x70
 [<ffffffff81252908>] ? splice_direct_to_actor+0x148/0x230
 [<ffffffffa02fb8c0>] ? fsid_source+0x60/0x60 [nfsd]
 [<ffffffffa02f9918>] nfserrno+0x58/0x70 [nfsd]
 [<ffffffffa02fba57>] nfsd_finish_read+0x97/0xb0 [nfsd]
 [<ffffffffa02fc7a6>] nfsd_splice_read+0x76/0xa0 [nfsd]
 [<ffffffffa02fcca1>] nfsd_read+0xc1/0xd0 [nfsd]
 [<ffffffffa0233af2>] ? svc_tcp_adjust_wspace+0x12/0x30 [sunrpc]
 [<ffffffffa03073da>] nfsd3_proc_read+0xba/0x150 [nfsd]
 [<ffffffffa02f7a03>] nfsd_dispatch+0xc3/0x210 [nfsd]
 [<ffffffffa0233af2>] ? svc_tcp_adjust_wspace+0x12/0x30 [sunrpc]
 [<ffffffffa0232913>] svc_process_common+0x453/0x6f0 [sunrpc]
 [<ffffffffa0232cc3>] svc_process+0x113/0x1b0 [sunrpc]
 [<ffffffffa02f740f>] nfsd+0xff/0x170 [nfsd]
 [<ffffffffa02f7310>] ? nfsd_destroy+0x80/0x80 [nfsd]
 [<ffffffff810bf3a8>] kthread+0xd8/0xf0
 [<ffffffff810bf2d0>] ? kthread_create_on_node+0x1b0/0x1b0
 [<ffffffff817912a2>] ret_from_fork+0x42/0x70
 [<ffffffff810bf2d0>] ? kthread_create_on_node+0x1b0/0x1b0

Signed-off-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsproc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index b009da1dcbb50..3c5e87805cc8d 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -845,6 +845,7 @@ nfserrno (int errno)
 		{ nfserr_io, -EIO },
 		{ nfserr_nxio, -ENXIO },
 		{ nfserr_fbig, -E2BIG },
+		{ nfserr_stale, -EBADF },
 		{ nfserr_acces, -EACCES },
 		{ nfserr_exist, -EEXIST },
 		{ nfserr_xdev, -EXDEV },
-- 
2.43.0



