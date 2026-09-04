Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237E83A16AC;
	Fri,  4 Sep 2026 05:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498721; cv=none; b=T3sww0b8jNr8TesyTaN0mIL+65S9LMgExCXmht/f1yvEOnTBWF/hm3x6zungEhL9YR/seE34EEcfrLK7YCcBG58I4nQo3jQRiS9JjlvaMwfVoxg+ndJDuh83Lx6tLBRz1cdhnhVgxFinjLSGKqsdC61sziaOyjuuRVh3RlJt55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498721; c=relaxed/simple;
	bh=eA5zlIIPGCS3hlQFnOgzgiGCVP6tQS5loc/muM0Gtv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/gWZ12opkkxWdVHJA/vWErw8GSbVIx/BXJYrJBjubJGD4kHh7hZE0USe7gEpyUBRGQ8zX02qugH7p7H0wETnqHg4mqS+vBVXXVdWPnUFbPbyLHVE0F4m33HFHiY97qzMukoK+1qUonPcmXhgssguCfoYYXwoPN4/ZOEuME+0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfGkPwtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfGkPwtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7121F00A3D;
	Fri,  4 Sep 2026 05:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498719;
	bh=CZNuWNG+7ta0XoKtXI7zcT4nrNgYeJeW60tvKQaT3Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfGkPwtzZJzQPiHcsiYeasGhNHL90vrt1nZv226y9+08Lg8as05HCBVmVj1+n1JW9
	 BUfhLbxiFFQknUn+8y9PkOwuBs6XBMNe81Ct2+qWK3wQUUQVV3vHAF63adXvM8BRGl
	 6pfZ0fNtJce9Ii6Jmxg3VFMWgCP2P4pn7mjBVg90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 162/713] nfsd: add missing read barrier to rpc_status_get dumpit seqcount retry
Date: Fri,  4 Sep 2026 06:52:10 +0200
Message-ID: <20260904045807.455964922@linuxfoundation.org>
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
@@ -1576,11 +1576,14 @@ int nfsd_nl_rpc_status_get_dumpit(struct
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


