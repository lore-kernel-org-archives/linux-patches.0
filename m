Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668F3358378;
	Fri,  4 Sep 2026 06:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502095; cv=none; b=YfCcy4FBJv57M5WWWg5sTFSNGhNKR1EULPB2wxamutUw7jmVJIKqDMFowzasrah7cIEuKh7d0le6FVNvdFv6ZCuFg7l2Df4r5dd4fQMoJEMy9wXfuFstw4AO2tEL+mT0KUrCa6lvQVnNVkCBKJgXiHrkWRw4exsLIG7QogfG51s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502095; c=relaxed/simple;
	bh=Yeuv29S/kDHMIJCumVMl7DoPWqyDRK807W4hl3O58aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wiwy2gdooRwvkS8886dhBUxeVnCcAmWiHYny7QzSvj/BewPymYf7+SPIxx1ByMo0SMlWymegpLuym+hxxjSSD9z2xANou8Go4DlU4gF28pbWiAC/+Y5EMWCx2WdY2Yh0zpte1xDNqK5xvLEiMXM3Ic8xQi+z9u2e+Ql2DrnYIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1t046bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1t046bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706111F00A3D;
	Fri,  4 Sep 2026 06:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502094;
	bh=79Zz5Vc9jPeLlOlIsnb61FL477350gfQ9fAz5sAZWaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1t046blih6le0KVCOqBFaAph8EwBk2awd7eiKNnGGDaWdg1A5LJ7FGrBvtF54stW
	 5Ha3AF3UxZ5dq2cOMRbZOtf2pVDllxj3XI5uJ3Y/A7PARxojbFFoMwttBzWlBuulkX
	 s4v4TvsR2/xa9b02ae5U7ExeNMqDkVlXCCcqqbFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 085/403] nfsd: add missing read barrier to rpc_status_get dumpit seqcount retry
Date: Fri,  4 Sep 2026 06:58:08 +0200
Message-ID: <20260904045736.767862384@linuxfoundation.org>
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
@@ -1635,11 +1635,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
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


