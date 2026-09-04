Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE47235CB7C;
	Fri,  4 Sep 2026 05:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500567; cv=none; b=lqXJLsYH/Unv/J0nWCW9YbwwxQ92xYmRUwM+zknJ39d3tW4v/uZHkEonmFiZdPBwqGbO1yxlj88yYKJNeOsQH7pzRH/M5AWOAj3ypazfUAh0eigsAxz1CzwHthi85kjBKkPVSF4jjEleAZAl/eZZV4iRUjnRV5IajcRGO+gIjbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500567; c=relaxed/simple;
	bh=rwekhnGv/NbRz8CPMUUZR6ZiQ1omMrnzqCB9BouCCAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWFYzaKtMFupSWyj6YZB94xuEdv11vWHzfyiVCUMg8G1oaS2q6xnFz/TqXoj9scRRGMnJghC3crDt13wiMnl99X3BROpanUXhQI68/CkJUqm9l07X0Q+u65988OvOKq6CdkuZLh/wB+NgJuI6hFsoe7nNwckt8Z7LN5/kgKn9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsuQmiEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsuQmiEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225E81F00A3D;
	Fri,  4 Sep 2026 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500566;
	bh=L5pLEzzlFn+vubiZJ8eadxHwByk1bcast1YckYTrLXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsuQmiECaU4oeMiMmkCTj3tn3eCtOB/yQfn180UJYXZznuniPY3G1bAWM7kRNfVNn
	 +7c6kk+JNjbyYjuBXMboZf7QDj4FxP498TkoAvgLGksWZTzbWErgQipDp7NzcoaxkG
	 OUte9v+tc8EjSsVnpRQxtqiCg1fHz0fQenNeUMeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 101/552] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Fri,  4 Sep 2026 06:54:18 +0200
Message-ID: <20260904045750.195504495@linuxfoundation.org>
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
@@ -275,7 +275,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


