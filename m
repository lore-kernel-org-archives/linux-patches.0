Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB271742;
	Mon,  8 Apr 2024 13:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583646; cv=none; b=HR4sJFwmezN4PWRVN2OR+5NXX7+dnl7ZaTgGhQV/NIZObVblu1BpwhBVd70z3epitHLJjD3QOjgyl2lz94/IyCoj24S7r4inDaFtRSsrWLGUG8vrw19Ut1yRnu8KTBs6Z1yVNwkjC8mcp+MmJF0RPtQt7Wq1eljzWBP3k4KDynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583646; c=relaxed/simple;
	bh=WdIRwSPAYv3PKHKCIGP3YH7ocrnL9kxx3woX/UOhi94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGshF2ljrwpegGOzWy7wp94Zxc9MTleXu208kmzKP54cZNKk9UVnBfxfTucbp30ZTJZaznb1o6YR7egSwP6XgWdrRQ5m87KSqb8Yvnd0yhwFKNvVosaavK7uLt8XpllRZ0NUimOtinGaLPdvjlLt/cWL/2REhHs2u8h11VR0AbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTp05a1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTp05a1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2212C433C7;
	Mon,  8 Apr 2024 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583646;
	bh=WdIRwSPAYv3PKHKCIGP3YH7ocrnL9kxx3woX/UOhi94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTp05a1aUuwXUGTXUV94zAQOB9PvfDyzWJnT6GdsmF2g/J+Ia8aCZ92nTCdyfIbeL
	 X5LfORsAS/HVY+/JDB/xB6doggr0zEA4/BpnkVFEf27wrJ5amkdsjACYRv30uXLrk6
	 xaFG/uLCpYTBXiYZ+Lclv+WPmVXlp+YAX6Ivoqmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 270/690] NFSD: Streamline the rare "found" case
Date: Mon,  8 Apr 2024 14:52:16 +0200
Message-ID: <20240408125409.408204212@linuxfoundation.org>
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

[ Upstream commit add1511c38166cf1036765f8c4aa939f0275a799 ]

Move a rarely called function call site out of the hot path.

This is an exceptionally small improvement because the compiler
inlines most of the functions that nfsd_cache_lookup() calls.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfscache.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 1523d2e3dae97..7da88bdc0d6c3 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -448,11 +448,8 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 	b = nfsd_cache_bucket_find(rqstp->rq_xid, nn);
 	spin_lock(&b->cache_lock);
 	found = nfsd_cache_insert(b, rp, nn);
-	if (found != rp) {
-		nfsd_reply_cache_free_locked(NULL, rp, nn);
-		rp = found;
+	if (found != rp)
 		goto found_entry;
-	}
 
 	nfsd_stats_rc_misses_inc();
 	rqstp->rq_cacherep = rp;
@@ -470,8 +467,10 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 
 found_entry:
 	/* We found a matching entry which is either in progress or done. */
+	nfsd_reply_cache_free_locked(NULL, rp, nn);
 	nfsd_stats_rc_hits_inc();
 	rtn = RC_DROPIT;
+	rp = found;
 
 	/* Request being processed */
 	if (rp->c_state == RC_INPROG)
-- 
2.43.0



