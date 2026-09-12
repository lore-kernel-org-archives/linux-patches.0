Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E3B3176EE;
	Sat, 12 Sep 2026 19:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240920; cv=none; b=AoZafqHQfvzzgvzwhYXvaIp388Ol/0eLZRFF8OTgSMvHyIVvFOaCVKdDclsq+xUlaeWKA9rzCUwHbzb9oRT7tsux7SGokTrGnPl6XFR5DntwBEkj7dETBwrEQY3sAcdwnq/2gwHPj004Ov3Wc6faxpGBUl0T8G++WBvFQDlboW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240920; c=relaxed/simple;
	bh=rozs8VuE34npauLV+Q9QGyO1DeefGuHKw5PnfqId3b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9vKSssr6U2i0PvN25feOonrWeIF1FcTtFTctY97cr99ZT13t+2yuc6XPVMsmLTFhoK1N3NB1+BRyPn1eMiQqun2h9E9WzWRSzobwMrQCXiSszjvZNz1KqII+LqyFrB/8znEjudrfH6ar2bAkKNps60b5T0CJJ+u1CAX9VfY9Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zt2UlL26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt2UlL26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56A21F00898;
	Sat, 12 Sep 2026 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240914;
	bh=0yWIL2o1KIFSgeBnn7NHWL+/gk1odPx2Q/BKafuLOG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zt2UlL26VYdravZFYAn3XaOnthhubD/bDsKTwS1iJG8oM+sCyZfmXaUpDgrtLUFzY
	 t6Y2GomHJ+nGyfhquWgKW4/1ilRxxV+5lOD7+9QOqzkhRUymqCmxbw3dd/9OMzUkNb
	 MRhCGO503LnLQeqxLth+NoiGsIVlPA1VF/DQuGK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 029/798] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065517.628444133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit d0728723c80dcb3432effd67c7e919b596004b1d upstream.

nfsd_prune_bucket_locked() evicts an entry before checking
the freed count against @max. The check uses "++freed > max",
which does not break until freed exceeds max, resulting in
max + 1 evictions. Use ">=" so the limit stated in the
function comment is honored.

Fixes: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717001232.438792-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -283,7 +283,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


