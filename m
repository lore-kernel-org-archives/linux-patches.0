Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612644CCDC7;
	Fri,  4 Sep 2026 05:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500658; cv=none; b=HKeFM6KSWkNzQ4QO25Je1FgtancPEVh23MAn2XmpBzDGLZhHOBtQgKX1y3po6cA7nHkf+EK5u2fjTA9Y+VIlDIMbN/AIdTn1F3oWbivIQaScIvipaMlDzjDWMFB/vhgJKWsaDdMfTtDHdDhbFyDUyCiSrliEm6+jAYgT3cRydCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500658; c=relaxed/simple;
	bh=tEmW41YqAMYNzXvkitDDfiK0vSAFCmUnQ4Uo2o7Zrok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDC1hpCf94cKHWh+/gUD2lFy36bmXDfo2G1Amy0rgC0w8feWUz7eWyCi75aN/35LwIAdCLZ3SdK3UaNqfKxvAG5Jw2lEW4D+rAkm2skU0GyvpnYmx8fNax7cEIO+W0MF7VNeiP7LyOyv5ddiEGLve7IRoMgNou6xI7HUvnrRC+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m17FCCO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m17FCCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E21F00A3D;
	Fri,  4 Sep 2026 05:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500657;
	bh=Wx3udhcjKM5HI4aKe4rFDFkvWhT1YxmEWPNuRwHD21M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1m17FCCOuSImDTEHGKRXwY2Ypxvkny2xksH1ln/fGM1R+9e0AkzWYJ3+rbbCv0jXR
	 TGQNCaLz5aKql+2m1PxuOt9xNPoSvRVmy81WSpPbt9DiAnt/o+5xvY5RKbPukZTMWA
	 Yr7L4ahltZti3xv4+gkpBTakRN/OT33YVpiFxjCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 135/552] nfsd: fix refcount leak in nfsd_file_lru_add on insertion failure
Date: Fri,  4 Sep 2026 06:54:52 +0200
Message-ID: <20260904045751.465558689@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 30c2df3005c99819e117402dc492db4a2a696c2f upstream.

nfsd_file_lru_add() unconditionally increments nf_ref before attempting
to insert the nfsd_file into the LRU via list_lru_add_obj(). If the
insertion fails (the item is already linked), the incremented reference
is never released, permanently inflating the refcount.

The LRU shrinker callback (nfsd_file_lru_cb) uses refcount_dec_if_one()
to reclaim entries, which requires nf_ref == 1. An inflated refcount
therefore blocks eviction of the affected file cache entry for the
lifetime of the nfsd instance.

While this failure path is currently unreachable -- the sole caller in
nfsd_file_do_acquire() operates on freshly-allocated objects that cannot
already be on the LRU -- it represents a latent bug that would become
exploitable if a future change adds another call site or alters the
PENDING protocol.

Fix this by:
 - Adding a compensating refcount_dec() on the failure path. Bare
   refcount_dec (rather than nfsd_file_put) is correct here because
   the caller in nfsd_file_do_acquire still holds its own construction
   reference, so the count goes from 2 back to 1 without risk of
   reaching zero.
 - Changing WARN_ON(1) to WARN_ON_ONCE(1) to prevent log flooding if
   this path is ever hit repeatedly.
 - Returning early on failure to skip the unnecessary call to
   nfsd_file_schedule_laundrette(), since no entry was added to the LRU.

Fixes: 56221b42d717 ("nfsd: filecache: don't repeatedly add/remove files on the lru list")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-6-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -327,8 +327,11 @@ static void nfsd_file_lru_add(struct nfs
 	refcount_inc(&nf->nf_ref);
 	if (list_lru_add_obj(&nfsd_file_lru, &nf->nf_lru))
 		trace_nfsd_file_lru_add(nf);
-	else
-		WARN_ON(1);
+	else {
+		refcount_dec(&nf->nf_ref);
+		WARN_ON_ONCE(1);
+		return;
+	}
 	nfsd_file_schedule_laundrette();
 }
 


