Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B3C3A16AC;
	Fri,  4 Sep 2026 05:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498740; cv=none; b=jvVytFAZ+pKA9YTvJgba7h9wLm++FJyodgZdUodDEdKyvS0srZlEbeqcM9VMDY0Zt6Y0ZxYKLbhFdoFQ6NuE1GctB3DcLlG9sKXDEdT2LxwdI1yyH+yq8meK/IIDKQnraRSO8Zr89g0oIcF+2uavDMkKqdvH7FpjYPVGDiHWOhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498740; c=relaxed/simple;
	bh=ff9QfawaHH/m9/PP1igDbEUTiej14gF7UVd+NlL+Q9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAbM76X86LCjA8GJJXKx189gk1APW7oTx522PHfQLX5Mv7YFTWzcz3bu+b9JPxri6TdSLo3mTMUOd/5V8a4U3OOpW1GwfaW+rEwfBkHS40BBYFikf3OaB36iqGh9t/o3yR8hFcvOnGznYosyNcBHUFoK5XnQ42y7iQ0MNDGNeZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV5RAXm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV5RAXm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F81F00A3D;
	Fri,  4 Sep 2026 05:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498739;
	bh=sBGZR+FKvcxrgSpWXmQ3+nuatNPQPifoNC6Ed9SO3Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uV5RAXm8y/ybPDUsvEsqBibNEgHPuGFJNFZqgns13MvNnWxP4RlBe6Ksx6Rq6fvt4
	 C6ulPw5yPzfH9FJOoKMiFqPxbhfPWe5vx53vBp5yv9tiz2hY89VWXVhInRTgLxyYzb
	 YNjPICZWNyf2tNv0ayS/E10aO2qQxwFsHTey+nI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 168/713] nfsd: clear opcnt on compound arg release to prevent OOB read
Date: Fri,  4 Sep 2026 06:52:16 +0200
Message-ID: <20260904045807.586575970@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6454,6 +6454,7 @@ void nfsd4_release_compoundargs(struct s
 {
 	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 
+	args->opcnt = 0;
 	if (args->ops != args->iops) {
 		vfree(args->ops);
 		args->ops = args->iops;


