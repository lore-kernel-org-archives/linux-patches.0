Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00D36A342;
	Mon,  8 Apr 2024 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584248; cv=none; b=hDxsvTh9zlUmV7gyJjgQfv66TLCWaKbv/9T4qB8VQVb+DRR3Gk7cmwNdZqt6uBgpyRmeS/yfw1SKBbv1lSB2K9fnOdzV317nwfEnXUIK27ZrLf805LlWXczMbTOpxrGM7AY6oRFtaGxNKgfimdjdpv6dg5JCYLiLWgeYv4T88no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584248; c=relaxed/simple;
	bh=mxq/uzf61xKjh9Q1Kk/57+yrDk5R6H7mUdDBVltwoyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3Qp69RQ2NlE/t8YjPQxeu0BSdJH7Dy4QSoI1a77lmmkwpGdYpi4qUKg2O/fVRFqvUojcC9/RypeNpLRu7Uz/aEyqTzSFz5nHyxNQBodUHCzWQJIflKndLMTCirYTkZccMA0w1v1mg0Q0gpbogflDfpNAldn6F3f5R2KPrzWWHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgAYHEm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgAYHEm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA8AC433F1;
	Mon,  8 Apr 2024 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584247;
	bh=mxq/uzf61xKjh9Q1Kk/57+yrDk5R6H7mUdDBVltwoyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgAYHEm3rMD/qlTkZ7YnoiDHEIj4RUCNxMh+2fW7WswsM9+Zyet9pWpNqRrOmRRhR
	 znGG+kp8PFfGv5ZgOl3BAzQlLePCAFU/rfVVdKkjK8t0QpaRIgTaogYa1m14C2BDkN
	 V3RSvkt10KChQpiIm0cRTaH3SERhHcGcqeXWtDao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 346/690] NFSD: Report filecache LRU size
Date: Mon,  8 Apr 2024 14:53:32 +0200
Message-ID: <20240408125412.126219024@linuxfoundation.org>
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

[ Upstream commit 0fd244c115f0321fc5e34ad2291f2a572508e3f7 ]

Surface the NFSD filecache's LRU list length to help field
troubleshooters monitor filecache issues.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1d3d13b78be0e..377d8211200ff 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1047,7 +1047,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned int i, count = 0, longest = 0;
-	unsigned long hits = 0;
+	unsigned long lru = 0, hits = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1060,6 +1060,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 			count += nfsd_file_hashtbl[i].nfb_count;
 			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
 		}
+		lru = list_lru_count(&nfsd_file_lru);
 	}
 	mutex_unlock(&nfsd_mutex);
 
@@ -1068,6 +1069,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "total entries: %u\n", count);
 	seq_printf(m, "longest chain: %u\n", longest);
+	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	return 0;
 }
-- 
2.43.0



