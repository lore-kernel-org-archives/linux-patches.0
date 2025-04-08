Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8065E219301;
	Tue,  8 Apr 2025 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112267; cv=none; b=Wd91mAdlIvsEIAJHU9yfSpil4e14hr70gsFnEQDc4AqK6+fCJQ5r/qpUMy2fQukdQKhkJjVEzuO1C4cJGiHx+uTdyYbC9hc5v4O/kh3jgk4rogSUc+FWaNCDa9K5NIU+cuoTOHUAFndPhMyGb3w8YvsA19KjzYyMXdstF9dqHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112267; c=relaxed/simple;
	bh=ZqitNxwKg1aJ9R0j1a7GLLQnFN/+2HDb45AV/NELkLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSzEFtD/79wZ1z77uam33q5B0GTkrI1ztSZd6jCB949RZHkCSijKIkeSZUD7tmE5lPdvgezNM7KJ2A6nOreQenarufiB6h5+IO1J9MZElwirs95ybKr2IhMTDY4H7TEXF/GSGKHBw3ywesRyVrclbZtCeHGHJsk0+m734xhKZyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYnyTh9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYnyTh9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FCEC4CEE5;
	Tue,  8 Apr 2025 11:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112267;
	bh=ZqitNxwKg1aJ9R0j1a7GLLQnFN/+2HDb45AV/NELkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYnyTh9AjmUVRMa9YgWArHZFfWUIEFC29ID9ZQa/+JP4DVbr+XezHUDJAb9L/BJfR
	 mffCnZqAJOw1HKTzKW8ha19cFGBPRwXwgfPdTrXux5dP47aVTay2O6qdHi1VGLHueX
	 n4V7EJzNt865fR+m7CtgTmsZp8kwsCci7pCbS1zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.14 727/731] NFSD: Add a Kconfig setting to enable delegated timestamps
Date: Tue,  8 Apr 2025 12:50:24 +0200
Message-ID: <20250408104931.184231104@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 26a80762153ba0dc98258b5e6d2e9741178c5114 upstream.

After three tries, we still see test failures with delegated
timestamps. Disable them by default, but leave the implementation
intact so that development can continue.

Cc: stable@vger.kernel.org # v6.14
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/Kconfig     |   12 +++++++++++-
 fs/nfsd/nfs4state.c |   16 ++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -172,6 +172,16 @@ config NFSD_LEGACY_CLIENT_TRACKING
 	  recoverydir, or spawn a process directly using a usermodehelper
 	  upcall.
 
-	  These legacy client tracking methods have proven to be probelmatic
+	  These legacy client tracking methods have proven to be problematic
 	  and will be removed in the future. Say Y here if you need support
 	  for them in the interim.
+
+config NFSD_V4_DELEG_TIMESTAMPS
+	bool "Support delegated timestamps"
+	depends on NFSD_V4
+	default n
+	help
+	  NFSD implements delegated timestamps according to
+	  draft-ietf-nfsv4-delstid-08 "Extending the Opening of Files". This
+	  is currently an experimental feature and is therefore left disabled
+	  by default.
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5958,11 +5958,23 @@ nfsd4_verify_setuid_write(struct nfsd4_o
 	return 0;
 }
 
+#ifdef CONFIG_NFSD_V4_DELEG_TIMESTAMPS
+static bool nfsd4_want_deleg_timestamps(const struct nfsd4_open *open)
+{
+	return open->op_deleg_want & OPEN4_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS;
+}
+#else /* CONFIG_NFSD_V4_DELEG_TIMESTAMPS */
+static bool nfsd4_want_deleg_timestamps(const struct nfsd4_open *open)
+{
+	return false;
+}
+#endif /* CONFIG NFSD_V4_DELEG_TIMESTAMPS */
+
 static struct nfs4_delegation *
 nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 		    struct svc_fh *parent)
 {
-	bool deleg_ts = open->op_deleg_want & OPEN4_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS;
+	bool deleg_ts = nfsd4_want_deleg_timestamps(open);
 	struct nfs4_client *clp = stp->st_stid.sc_client;
 	struct nfs4_file *fp = stp->st_stid.sc_file;
 	struct nfs4_clnt_odstate *odstate = stp->st_clnt_odstate;
@@ -6161,8 +6173,8 @@ static void
 nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
 		     struct svc_fh *currentfh)
 {
-	bool deleg_ts = open->op_deleg_want & OPEN4_SHARE_ACCESS_WANT_DELEG_TIMESTAMPS;
 	struct nfs4_openowner *oo = openowner(stp->st_stateowner);
+	bool deleg_ts = nfsd4_want_deleg_timestamps(open);
 	struct nfs4_client *clp = stp->st_stid.sc_client;
 	struct svc_fh *parent = NULL;
 	struct nfs4_delegation *dp;


