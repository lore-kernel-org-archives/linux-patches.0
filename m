Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8527E112;
	Mon,  8 Apr 2024 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584191; cv=none; b=d17sqIsbiXzvro7tkVti9PhCaY/jq65Duk3aT19HRPZZSajx/V2ejQ6J2FTvGtVNroM98mm4sa6wuJZ/GrPD6IUoytiEI/FcQtK7jBfATR/qr8kSmKrFrOQKtmfaRYTSxPef7gmotpjCccg/EHJCmAKmbkdeFhJRN7/Nu6Cmwp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584191; c=relaxed/simple;
	bh=QtPAFOpK7BUroYXCc9gL8h9U8NirJfF/SLL34VG+YmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkc8ZAragnTlpkwLIPyqsBoOwjwtHeyMMmgiXFiX1SV1yswCAnJzEKu+E04QmmPGQ15kP8ZoFW6/Gwj3S4rbR5WNpePYuHQV9eecNU4awfEOtAxWInngvKbQES9qzWSmIP+3IV+LAjz6Lv7HzdyalBux8hTHynR4K+G9sottQqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oK7RUNcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oK7RUNcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66599C433C7;
	Mon,  8 Apr 2024 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584191;
	bh=QtPAFOpK7BUroYXCc9gL8h9U8NirJfF/SLL34VG+YmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oK7RUNcAI3TfpSjTlzouzX+FQrHGAEh2P3Tgyz2o3zMNULRWylJ7YGWTSKtfxcxrs
	 Lmat0chgr7/IchQhbGYeaJ6fCFsrcwp3lOW7sPblLXv1M8Kagy1apfx1OtXeW3bxDR
	 1TyCxN2e7VA0eL41yWm9T+8iRyy3O2+keDQ22h94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 355/690] NFSD: Zero counters when the filecache is re-initialized
Date: Mon,  8 Apr 2024 14:53:41 +0200
Message-ID: <20240408125412.457917988@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 8b330f78040cbe16cf8029df70391b2a491f17e2 ]

If nfsd_file_cache_init() is called after a shutdown, be sure the
stat counters are reset.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b9941d4ef20d6..60c51a4d8e0d7 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -823,6 +823,8 @@ nfsd_file_cache_shutdown_net(struct net *net)
 void
 nfsd_file_cache_shutdown(void)
 {
+	int i;
+
 	set_bit(NFSD_FILE_SHUTDOWN, &nfsd_file_lru_flags);
 
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
@@ -846,6 +848,15 @@ nfsd_file_cache_shutdown(void)
 	nfsd_file_hashtbl = NULL;
 	destroy_workqueue(nfsd_filecache_wq);
 	nfsd_filecache_wq = NULL;
+
+	for_each_possible_cpu(i) {
+		per_cpu(nfsd_file_cache_hits, i) = 0;
+		per_cpu(nfsd_file_acquisitions, i) = 0;
+		per_cpu(nfsd_file_releases, i) = 0;
+		per_cpu(nfsd_file_total_age, i) = 0;
+		per_cpu(nfsd_file_pages_flushed, i) = 0;
+		per_cpu(nfsd_file_evictions, i) = 0;
+	}
 }
 
 static bool
-- 
2.43.0



