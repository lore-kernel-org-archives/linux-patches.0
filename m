Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54AA3546FA;
	Sat, 12 Sep 2026 17:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232680; cv=none; b=flLGcBLMwTJtEUh4KyFEDHAtGygwfdZhr0+sBgiOyxBgbzDV+dQ3nQZzOmm9UejDpkJS+hI8AnBNOTZ6EW/mxBg8IEcx0rB56jQdfZe+ao1aUtiRPwOt8dY+PVbcygJYoWtX7yng8fE3OuAZppNV9DdRHQOJbsMeu7jvSQ8E7J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232680; c=relaxed/simple;
	bh=XvThDZMyj78pQZePWADzInwibBHzh+r/AcWgQA/mYZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNwLAw3BhytopZdAa3BNlFGK0NWy/GM02wcKuc4AZ5zVn02CsggoWeId8LKLBTXJ6xaGPN6svu0rqhwSiyc9dkK7Zb3oaOuGVoCedM4Uro0bhBZ0GA4ANXU1KFluCwgMI1LGpEJ92dxR/8HhDEOWH5PnWQLES8OGDl6nt2XiIzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEAOoH9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEAOoH9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5F1F000FF;
	Sat, 12 Sep 2026 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232678;
	bh=uqmD8YuAmjFjj01hjtcosAAYkj+P/2fiGN0QfSPKuew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEAOoH9XJRr9/yqh6VuCZzCthC8gtDOoq/UbUPNFZhYWl+iiovqoEMhDJj2u057vD
	 XIKRx+bqA+xgvnUFJDl+GlBqj/ykgbaKYgRfGscwG4s3NkUfsDIEQmuqWdaPWNVoXy
	 RnVOieAroHpgsY/js6fKJ543gC/IdLPwJfnGHga0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 032/935] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065527.575321099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


