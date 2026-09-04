Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B703D3D6664;
	Fri,  4 Sep 2026 05:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498828; cv=none; b=PfXfV26BIPJcBQiRBkrMk2bndRYAes2BZ+rSkW7orYxP02UIa1zKemVKIQWLBPJbECVGV5q4iGFsi5SHj8rBPu569OevpiB4Eg4+AbvN8fyrcSLFSv4E+P0V0E3OtKaNT9qnvl840ZA0wegVNN1VCJdR6+lsfyHLaIwq7rqmw4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498828; c=relaxed/simple;
	bh=97i1A9TRrjOPZ60UHR+bga5fN4xL55a66OlW8EL40lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyt3bLQvOY10bIEk1Tj1vfUJPPmDRyKMHwqdf8ECiy5Agy5UjxIZWupsKDtLT7fNwo+qtmzXzAZRXcLzzW+jbiVtOcgI7z/coysaKMbemFQkRdLjVJ+W45TtxhZrg9xce52M3ZuTjQ3kIG0ja68TkZ8tmwr1EsuY0Jb/HmuRTyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4VUws2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4VUws2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9731F00A3D;
	Fri,  4 Sep 2026 05:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498826;
	bh=K4aALWCbWyMn4F/TvBo8kT1yR4ZaIcSuPEacM4b5AgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4VUws2dtLLQnbvbbSs+0O7m/aTYVi/SjQMRP6ikzZdBBx6cNz19wBGbwXcO8bmrO
	 da8n6JMUWlzutJTZPTlnRc+TLky8U8Yri735GSiIwmmtHRP6xIYZ2b1TaKz0QwMV40
	 nG7hfInUmrsOIEVTgTRkmjpmnp4+2ZbrtjkTmfa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 200/713] nfsd: move nfsd_debugfs_init() after nfsd4_init_slabs() in init_nfsd()
Date: Fri,  4 Sep 2026 06:52:48 +0200
Message-ID: <20260904045808.294560152@linuxfoundation.org>
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

commit 2c390c8a1764d67095fe444401861fac4c049362 upstream.

nfsd_debugfs_init() runs before nfsd4_init_slabs() in init_nfsd().
If the slab allocation fails, the bare "return retval" bypasses
nfsd_debugfs_exit(), leaving orphan debugfs files with stale fops
pointers into the freed module text.

Move nfsd_debugfs_init() to after the slab init succeeds, so the
early return has no debugfs state to clean up.

Since debugfs is now the more recently initialized of the two, also
update the unwind paths to match reverse-initialization (LIFO) order:
run nfsd_debugfs_exit() before nfsd4_free_slabs() in both the
init_nfsd() error path and exit_nfsd(). The nfsd debugfs files only
reference module-global state and have no dependency on the slab
caches, so that reordering is a cleanup with no functional change.

Fixes: 9fe5ea760e64 ("NFSD: Add /sys/kernel/debug/nfsd")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-17-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2592,11 +2592,12 @@ static int __init init_nfsd(void)
 {
 	int retval;
 
-	nfsd_debugfs_init();
-
 	retval = nfsd4_init_slabs();
 	if (retval)
 		return retval;
+
+	nfsd_debugfs_init();
+
 	retval = nfsd4_init_pnfs();
 	if (retval)
 		goto out_free_slabs;
@@ -2641,8 +2642,8 @@ out_free_lockd:
 out_free_pnfs:
 	nfsd4_exit_pnfs();
 out_free_slabs:
-	nfsd4_free_slabs();
 	nfsd_debugfs_exit();
+	nfsd4_free_slabs();
 	return retval;
 }
 
@@ -2657,9 +2658,9 @@ static void __exit exit_nfsd(void)
 	unregister_pernet_subsys(&nfsd_net_ops);
 	nfsd_drc_slab_free();
 	nfsd_lockd_shutdown();
-	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
 	nfsd_debugfs_exit();
+	nfsd4_free_slabs();
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");


