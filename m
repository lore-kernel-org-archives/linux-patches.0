Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D4130C366;
	Fri,  4 Sep 2026 06:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502178; cv=none; b=StdoaLWegXfT3uZz0tpcuUt2kXtw/agA/Ago50f4ZwwNW4A5JczCWsSYXM7LJl+pm9LOZKlxN9gl7DJ4XJXnWXjMGNqEMhqUPSTSaq/mwRc+80HxKDnI5tVtrkktYN6Y2tx8XGBgcSXNSRGM0NJUFJX79NwE31+p7op//RWSL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502178; c=relaxed/simple;
	bh=GR+vdKSlGoIKAG3xJHEWRIeMR1k8wsmqVNmhQiDRXPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hSQU+uXLSnlSX7qqO25V7IqEvRXeYBnPBMBpymgs+PM9FG50N0UzjeKL/zJUjAfYN9I4SZsz2ahiW8EBXJeiuaciKpEPVV6h9I1vvvq1/Shd5SC1z+S2M74Nplj9c6qNvyFBoCdo8d4ehl1LiOGjUFkUD7YnxzCWwBAURE/P8DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KamS7IOK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KamS7IOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A3B1F00A3D;
	Fri,  4 Sep 2026 06:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502177;
	bh=ev/AYym2IN1zWQtJjeZ+iZc0jjclM1NovnwIRCITh0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KamS7IOK8iEp9evJA/FIaqs6jF+Wmg8mqmdULLQVFRiEVd11TjjqaBdJG168QDV5V
	 7GUwMovwqoO6JCETTjs6F1xWIZMDY3e8nWgjxU5S/2UphLl/KY5CAa6x31z0EN6mh+
	 MGtocKoC2rmjo/X0XItPwniIvTvtI5KT02rSXPNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 089/403] nfsd: defer vfree of compound ops to fix rpc_status UAF
Date: Fri,  4 Sep 2026 06:58:12 +0200
Message-ID: <20260904045736.860358910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit fca26a3fc19ed02278aa2a150af82d43db0302cb upstream.

The rpc_status netlink dumpit walks every in-flight svc_rqst under
rcu_read_lock and, for NFSv4 requests, reads opnums out of
args->ops[]. But args->ops is a separate vmalloc buffer freed
synchronously by vfree() in nfsd4_release_compoundargs() at the end
of every compound. The dumpit's rcu_read_lock pins the svc_rqst
struct itself (freed via kfree_rcu), but nothing defers the vfree
of the ops buffer across the RCU grace period. A concurrent compound
completion can therefore free the buffer while the dumpit is reading
it — a use-after-free on vmalloc memory.

The trailing seqcount recheck (smp_load_acquire of rq_status_counter)
cannot undo a load that already retired against freed memory.

Fix by replacing vfree(args->ops) with kvfree_rcu_mightsleep(), which
defers the free until after an RCU grace period. This makes the
existing rcu_read_lock in the dumpit sufficient to protect the read.
The tradeoff is that completed compound ops buffers (up to
200 * sizeof(struct nfsd4_op)) persist in memory slightly longer,
across one grace period, before being reclaimed.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-1-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5878,8 +5878,10 @@ void nfsd4_release_compoundargs(struct s
 
 	args->opcnt = 0;
 	if (args->ops != args->iops) {
-		vfree(args->ops);
+		void *old_ops = args->ops;
+
 		args->ops = args->iops;
+		kvfree_rcu_mightsleep(old_ops);
 	}
 	while (args->to_free) {
 		struct svcxdr_tmpbuf *tb = args->to_free;


