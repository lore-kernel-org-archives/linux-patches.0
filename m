Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DF5414A34;
	Fri,  4 Sep 2026 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500692; cv=none; b=VkWUK//ryBFBCS0Rp1uTGQLEmQT/AlksZwrZGbgAM1lRMjnoEEBEEk/HYZDTJbEUaLEn/DPRsns1Nd9nnQYLAguLxgnalw5DvPy7FqWWzNghw2ENslB6dfwJJo49BClL8T9qWpGaNPs3UJtlxbx/dld0vx+IYZCNj2yo0OX9iNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500692; c=relaxed/simple;
	bh=eXTsyd8/yDVVkrwwpRH5GuxP6Oq+8EyxZ0XxYD3cewE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV/HVqmHDvh3A3tFYwEsD/XOC6DBiaZs8KKEbI4eTFx2ebfxyn5qX3AGetm1L0iE4jF8IOpp8hXnWX5oq5A+wRmMMa8k0eFzgQniCK6MIY1abtUVc4dTZ++kR2cAoFsSxUhj6RL9srec9+21+0zwlNtpZnTCoDErLBOj4kxaHz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDXkvtsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDXkvtsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D201F00A3D;
	Fri,  4 Sep 2026 05:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500691;
	bh=5lupxxQaDu6KftUpz9SO0J76o+K8brzRxbRNm0Iz1kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDXkvtsnZA28vNy92vyz3fDnNPMM7pr9lzqn31thTdU0rYsTs/SfOu1Pc+Iu6G5T7
	 njNMxzi5b6dKU+sTMj5tRA6//l44xatqRsFpVAN/5lfj0WDYkMPaE/oHMkNakjDicC
	 mvEXH4beINSs1nlojzIvjqMhcFVIknt+Mxt9MMXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 119/552] nfsd: add missing read barrier to rpc_status_get dumpit seqcount retry
Date: Fri,  4 Sep 2026 06:54:36 +0200
Message-ID: <20260904045750.730454482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit a71f161a857117e8e0264deb7d14fff5c98adcf5 upstream.

The hand-rolled seqcount-like protocol in nfsd_nl_rpc_status_get_dumpit()
is missing a read memory barrier (smp_rmb) before its second counter
check.  The standard kernel read_seqcount_retry() includes smp_rmb()
to ensure that all data reads complete before the counter is re-checked.

Without this barrier, on weakly-ordered architectures (ARM, POWER),
the CPU may reorder field reads past the second counter check, making
the retry logic ineffective: it could observe a consistent counter pair
while reading fields that have been concurrently modified by the writer.

Add smp_rmb() before the second counter check to order the field reads
ahead of it, matching the barrier semantics of the standard seqcount
read-side.  The begin-side smp_load_acquire() already pairs with the
smp_store_release() in nfsd_dispatch(); with the smp_rmb() now ordering
the field reads, the retry check no longer needs acquire semantics and
reads the counter with a plain READ_ONCE(), as read_seqcount_retry()
does.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: Use READ_ONCE instead of smp_load_acquire() ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-2-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1555,11 +1555,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
 #endif /* CONFIG_NFSD_V4 */
 
 			/*
-			 * Acquire rq_status_counter before reporting the rqst
-			 * fields to the user.
+			 * Read-side load-load fence: order the field reads
+			 * above before the counter re-read below, mirroring
+			 * the smp_rmb() in the standard seqcount retry. The
+			 * begin-side smp_load_acquire() above pairs with the
+			 * smp_store_release() in nfsd_dispatch().
 			 */
-			if (smp_load_acquire(&rqstp->rq_status_counter) !=
-			    status_counter)
+			smp_rmb();
+			if (READ_ONCE(rqstp->rq_status_counter) != status_counter)
 				continue;
 
 			ret = nfsd_genl_rpc_status_compose_msg(skb, cb,


