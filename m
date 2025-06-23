Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C8F2940B;
	Mon, 23 Jun 2025 22:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716056; cv=none; b=G1m1kfEDXSUmr847KBenB8ofpRh40VFYH4/OqQNy7A3Bif/NLD5JcFVqjX42xH3wXLmTKkdgOu388F4U9y4yUx/tM94D7kVDO/sGB+nmxKGg8x+tDeTmFKvK5R/BmS3Az/u7GXmOp+0t0zGcq5HjWZcK5niLphFov3FzecCytqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716056; c=relaxed/simple;
	bh=qZdsNlxoowM4P3VcxIza9qhjAN6VmRY6cQpMFq5B1tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=it3wzV7Sj/2ORkJeICzU+fQzP2YhcZnT4+D06CV4lGmZJc0xhNqlgYbsoDExZnwYbF9zjlwiKjgS/Jkf8MxNJqZYClsD78RwPCaRcsrL6gqEzITUnctk7VnEohCGUT/A7Id1nCrgQPiSWtpuB7PZ203PlH0mvL+hQfY1MWelVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9lTk9du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9lTk9du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55ADC4CEF1;
	Mon, 23 Jun 2025 22:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716056;
	bh=qZdsNlxoowM4P3VcxIza9qhjAN6VmRY6cQpMFq5B1tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9lTk9dukRP+6uRX2Y07VFuTA1Q05rzW0Ve/1ilvFk0xL+Wbh56vi+dUeGZSelRDX
	 7Wo4W6fG8KY9qmLxZDNbL9YYko1HErieOff8s0Mo0luMd58ajJYn28KYQmT2jDmS8O
	 /1Gub+v0ufJNe6sk/BzPCBwQo/ytjxaYCi0XplBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.15 499/592] nfsd: use threads array as-is in netlink interface
Date: Mon, 23 Jun 2025 15:07:37 +0200
Message-ID: <20250623130712.302043287@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 8ea688a3372e8369dc04395b39b4e71a6d91d4d5 upstream.

The old nfsdfs interface for starting a server with multiple pools
handles the special case of a single entry array passed down from
userland by distributing the threads over every NUMA node.

The netlink control interface however constructs an array of length
nfsd_nrpools() and fills any unprovided slots with 0's. This behavior
defeats the special casing that the old interface relies on.

Change nfsd_nl_threads_set_doit() to pass down the array from userland
as-is.

Fixes: 7f5c330b2620 ("nfsd: allow passing in array of thread counts via netlink")
Cc: stable@vger.kernel.org
Reported-by: Mike Snitzer <snitzer@kernel.org>
Closes: https://lore.kernel.org/linux-nfs/aDC-ftnzhJAlwqwh@kernel.org/
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1611,7 +1611,7 @@ out_unlock:
  */
 int nfsd_nl_threads_set_doit(struct sk_buff *skb, struct genl_info *info)
 {
-	int *nthreads, count = 0, nrpools, i, ret = -EOPNOTSUPP, rem;
+	int *nthreads, nrpools = 0, i, ret = -EOPNOTSUPP, rem;
 	struct net *net = genl_info_net(info);
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	const struct nlattr *attr;
@@ -1623,12 +1623,11 @@ int nfsd_nl_threads_set_doit(struct sk_b
 	/* count number of SERVER_THREADS values */
 	nlmsg_for_each_attr(attr, info->nlhdr, GENL_HDRLEN, rem) {
 		if (nla_type(attr) == NFSD_A_SERVER_THREADS)
-			count++;
+			nrpools++;
 	}
 
 	mutex_lock(&nfsd_mutex);
 
-	nrpools = max(count, nfsd_nrpools(net));
 	nthreads = kcalloc(nrpools, sizeof(int), GFP_KERNEL);
 	if (!nthreads) {
 		ret = -ENOMEM;


