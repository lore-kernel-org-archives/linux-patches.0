Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE23D6664;
	Fri,  4 Sep 2026 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498822; cv=none; b=IQsPKmIkkV12PUbZ1Dxu8hlJyjAWzr83F6PbeB/bUq9DA0rU7FflNKiNWq+79CiPBUK5FYcJM3i3hNmU2Y1AEOlSE/9nMcykKYIpVcifiGUZuaSaXGKs3Wd0Pa+QWX1UO/ZhdMGZuGJqVjTguWRT+1m+YvDWdzgZoT2qJeN3+bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498822; c=relaxed/simple;
	bh=6c/aBp0ymhbf3JtHVtEkF+p5liq8XYqNYKC0DTZSWjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuXsuLM+mf5imUBsAbiyKr328HGpnsrdzmt5D0pT9pCCICF+G4onjHKGfWPL/tZh0bWp74/LqyuSnYUOcNnBd1Fbkz97yAxAS0FDEahM8kb2gORiyxlOxnUlk0Snz1xgrR++0WR6qSEfDHL5JyNPiKVnU3O+Q8s059DfOaHzPyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr5j9unS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr5j9unS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF061F00A3D;
	Fri,  4 Sep 2026 05:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498821;
	bh=GO6SjydxgF6gnh1K1WYVjbmkm3woWhJe3mhmnd/r+54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mr5j9unSXreLT/33/qQ0J/OVj546sce223ydrF6adaq/gvslizbRN3aBgzgryLosT
	 2k/pgjaq45UuEbjhzfGoddcWjVDfBpTvuPh9bNW+wJoqWhLH458uSnTiShVBbyTLwD
	 kiT4g4ky4Pq+OeYYDHsym6G089VslwEwOakLgxGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 172/713] nfsd: defer vfree of compound ops to fix rpc_status UAF
Date: Fri,  4 Sep 2026 06:52:20 +0200
Message-ID: <20260904045807.675492323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6456,8 +6456,10 @@ void nfsd4_release_compoundargs(struct s
 
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


