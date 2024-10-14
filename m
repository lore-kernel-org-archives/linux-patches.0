Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812531CACE8;
	Mon, 14 Oct 2024 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919862; cv=none; b=HfhVUfFFXeTS/gaqPG3oEE3+iNPeHBJlpyi/4hxkdb9bINR8oc/trHRzS/h2OJ9YubqPrzZ2CDBabpHoeEf1S50SWsLUo/EJyc9iA/TBkXEcQMRctlqBdBXWfcDZbYHjekUz84ht92CTvhOwdEz86Ff87o/cmpzslZnnbZdms2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919862; c=relaxed/simple;
	bh=IUjEBIxP79hQj07Rc2BEhkDGli2s2v4t8Z+lB6aUTfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAGkjTp3RXEM5smQhLzcpW1ybhA3SB1HDhrSnZuycJd8IgglCDDst5QWvZ88B9oEhOZWk6FHkzRislxIsO10mV3iEPHZ2JXMFxo6BE6qtM+OxDMdbfuun9oHHAeghmiTwQBmRx5PueLHoaAaUmklg/TiQVT8MjduYKaec7lBQHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJJa+74l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJJa+74l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A2C4CEC3;
	Mon, 14 Oct 2024 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919862;
	bh=IUjEBIxP79hQj07Rc2BEhkDGli2s2v4t8Z+lB6aUTfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJJa+74l/yMmbkeNYPUgMV6EEJJHpbarVOewIHReJQbMbTE43ntpSICqnyL63WDLS
	 CYwN7tcHEPZ2uQ3SaUerP36RQRuzD+WJsBsJO9kW2D8RJZgr26TElyyGJodLRfVBER
	 /2Mz9QvI3uyeXha7xTEYZ8hho7Q6ZmojTItku0Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 727/798] NFSD: Mark filecache "down" if init fails
Date: Mon, 14 Oct 2024 16:21:21 +0200
Message-ID: <20241014141246.633530292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dc0d0f885aa422f621bc1c2124133eff566b0bc8 ]

NeilBrown says:
> The handling of NFSD_FILE_CACHE_UP is strange.  nfsd_file_cache_init()
> sets it, but doesn't clear it on failure.  So if nfsd_file_cache_init()
> fails for some reason, nfsd_file_cache_shutdown() would still try to
> clean up if it was called.

Reported-by: NeilBrown <neilb@suse.de>
Fixes: c7b824c3d06c ("NFSD: Replace the "init once" mechanism")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 9e81f3a9097e0..c9393c732889a 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -718,7 +718,7 @@ nfsd_file_cache_init(void)
 
 	ret = rhltable_init(&nfsd_file_rhltable, &nfsd_file_rhash_params);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = -ENOMEM;
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -770,6 +770,8 @@ nfsd_file_cache_init(void)
 
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
+	if (ret)
+		clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags);
 	return ret;
 out_notifier:
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
-- 
2.43.0



