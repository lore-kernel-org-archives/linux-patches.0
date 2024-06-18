Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1156C158A12;
	Tue, 18 Jun 2024 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716115; cv=none; b=O/QYsl7hVwKewkedXP/Qy8yYP5AIi7ol8FpuZPOdv7hNMWhEEVXyfpJGagRdEojaxc7PS30J0189p+2V5uvbUBw7RE1Qqj4foiFLCN4EhsLG8/CinQR5yzmv406leIdGz+lMj+LSD5WABJYsr65TvfjSPtMhhl49Pi0jZVpE4z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716115; c=relaxed/simple;
	bh=3KquAU/ogf0bqXPWf770P0r2ZbnyQnQqLFbQKyl+JxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Phkp/OGSaA6tiWjUeYKDhuHzwCUXccaJ0nGgVpmnIufNK1zsjrGWj0g7RQNmx7xEqN056hmhV2vHiUhUSYA0wMLR+9kuuthntfcBcOMUDJbl9Y77E/Fog+BIppKZQkLX38a3+erEDey3Gp1WZ46Lnxft3R2D9rZYd0BbtnNQ5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGsCZUxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGsCZUxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85699C3277B;
	Tue, 18 Jun 2024 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716114;
	bh=3KquAU/ogf0bqXPWf770P0r2ZbnyQnQqLFbQKyl+JxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGsCZUxroULuKDu7uul+j6LTMMdo06YTjAfHNpJTLexAacadqDQ1k4rm0mrD2tMKs
	 +rO3hEbjOzgpMF8YE/+GMxt5IWgCfmZmLWAXhhFlPM21iUnxjGTHMYhPfRHDVWUP9v
	 Fqyz5r7vafpst26SdRztFKOPTZWfwT9eFcbJW17w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 537/770] NFSD: Fix potential use-after-free in nfsd_file_put()
Date: Tue, 18 Jun 2024 14:36:30 +0200
Message-ID: <20240618123428.037114947@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b6c71c66b0ad8f2b59d9bc08c7a5079b110bec01 ]

nfsd_file_put_noref() can free @nf, so don't dereference @nf
immediately upon return from nfsd_file_put_noref().

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 999397926ab3 ("nfsd: Clean up nfsd_file_put()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 11c096b447401..fc0fcb3321537 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -308,11 +308,12 @@ nfsd_file_put(struct nfsd_file *nf)
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
-	} else {
+	} else if (nf->nf_file) {
 		nfsd_file_put_noref(nf);
-		if (nf->nf_file)
-			nfsd_file_schedule_laundrette();
-	}
+		nfsd_file_schedule_laundrette();
+	} else
+		nfsd_file_put_noref(nf);
+
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
 }
-- 
2.43.0



