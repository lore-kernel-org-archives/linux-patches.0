Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921DB35CB7C;
	Fri,  4 Sep 2026 06:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502148; cv=none; b=Da3tSuruDkei+nYPz9JMWHASARZ0dOfU0hFwquDD51DriEJGmjMs6995RmLrJtgvf+Xjrpk7YDM76l7k/10xFrQLCCTuvkvDlYfsw4/NjjAcYgvTbtv8r2SEfF/kLcyTBG4rhZVuvojgca/az6KwsDM5/uMsp8JSzMrHcqxXwik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502148; c=relaxed/simple;
	bh=Z/+WjHTCSzMvH40ICe3kZ53beF1r5slci0eRAahk/Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAukF9/ER5etWcKyl/pIXpn8dBi5jv4akM9tiXj0ujyvfmSXSWjIDV0lqskl7yKwbcn1kKgihAizswybgYWG3it06d7kE4nGN1LrAerTM+E31iBxpyN2Gi/U+vXlM7MtAkGSxjodTBukwcNO9sDk6cLNZByTnZ7gVG0MNMA2EAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twBnBuz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twBnBuz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC031F00A3D;
	Fri,  4 Sep 2026 06:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502145;
	bh=AbQ/1MYUOOYQnweY2pzUKlnel7MSU/JwD6HDLI0Op6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twBnBuz25GlLMz25ZS6SkvYTY+Aj/XZiQxX3300CAVoY2aA41Ozae+sV/fTeAfTu9
	 tdxGqoh3O1MSh+DRjxBXPG5OCXmlLxzwpjuFP4gd01pdsiJvpCUbytM8T0Ck9+LaSk
	 tZt0TxXXm0UylJUxfGbmIy8tPc3pnNg3cz+TvjtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 088/403] nfsd: clear opcnt on compound arg release to prevent OOB read
Date: Fri,  4 Sep 2026 06:58:11 +0200
Message-ID: <20260904045736.837520219@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit ae4c38555e81563b8dc5eae55ffd70f0ea97aa5a upstream.

nfsd4_release_compoundargs() resets args->ops to the inline iops[8]
array when the dynamically-allocated ops buffer is freed, but leaves
args->opcnt at its original value (which can be up to 200 for NFSv4.1+
compounds).

If rq_status_counter is stuck at an odd value (which can happen when
nfsd_dispatch() hits an error path after setting it odd), the RPC
status dumpit handler reads min(opcnt, 16) entries from args->ops[].
Since iops only has 8 elements and is the last field in struct
nfsd4_compoundargs, reading indices 8-15 accesses adjacent slab memory
and leaks it to userspace via netlink.

Zero opcnt unconditionally in nfsd4_release_compoundargs() so stale
compound metadata is never exposed through the status interface.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: Remove the kvfree_rcu_mightsleep() sleep from the exposure window ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-1-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5876,6 +5876,7 @@ void nfsd4_release_compoundargs(struct s
 {
 	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 
+	args->opcnt = 0;
 	if (args->ops != args->iops) {
 		vfree(args->ops);
 		args->ops = args->iops;


