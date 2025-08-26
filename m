Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77947FC1D;
	Tue, 26 Aug 2025 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212596; cv=none; b=RUnAqdb5PjS15FVU/ZY8YLfUxUJGsMJ08nzZARwn/rCzcyIqf5tw0M3Yy23pU4vdRYczWtht9MOTAcwfkxP0jXgauZTVJSGCxMztOpwEno5Ir5MTsSlDeB5dE9KfaHZTiTrOVdwItczYjYVb6IEl7Mt/IkjgtzCbvZutNfSJAFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212596; c=relaxed/simple;
	bh=xO6KEbxNGHdGl9ZyKU2mBZpZWbLxCoHdA+NJRKl/2ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgdOQRK6pQW7N69/BylwTmG9f5t+PphxVY5us85POD3/bszZmiciwXIGLGjw0tOrpM/USEjnTH9LzBGHW5AFlLmkCSDu43QAj6almqfozJPBja3s8P25DxvNStmEWdcsNWLq4KNXRhBR/OtPju24brLnX1dTxEfv7AmVRNnZJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKNs8pmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKNs8pmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD51C4CEF1;
	Tue, 26 Aug 2025 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212596;
	bh=xO6KEbxNGHdGl9ZyKU2mBZpZWbLxCoHdA+NJRKl/2ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKNs8pmOkMrRphYmeO08LO57PmKeek+kj4c+Hq/3e/r58IXwGz1d+PtAmprZcbvEh
	 832W7z6Im2lFgQAyZXnMO+IRbWvHCDqB6Cj33Rbf0OFJnHmt1zDcSrqSJvHk0k4Ljo
	 6BCR78MzW0Dnqbmrgm4IICTmeX6cgMoIiHoqXUnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 022/587] nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()
Date: Tue, 26 Aug 2025 13:02:51 +0200
Message-ID: <20250826110953.519814490@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 908e4ead7f757504d8b345452730636e298cbf68 upstream.

Lei Lu recently reported that nfsd4_setclientid_confirm() did not check
the return value from get_client_locked(). a SETCLIENTID_CONFIRM could
race with a confirmed client expiring and fail to get a reference. That
could later lead to a UAF.

Fix this by getting a reference early in the case where there is an
extant confirmed client. If that fails then treat it as if there were no
confirmed client found at all.

In the case where the unconfirmed client is expiring, just fail and
return the result from get_client_locked().

Reported-by: lei lu <llfamsec@gmail.com>
Closes: https://lore.kernel.org/linux-nfs/CAEBF3_b=UvqzNKdnfD_52L05Mqrqui9vZ2eFamgAbV0WG+FNWQ@mail.gmail.com/
Fixes: d20c11d86d8f ("nfsd: Protect session creation and client confirm using client_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4282,10 +4282,16 @@ nfsd4_setclientid_confirm(struct svc_rqs
 	}
 	status = nfs_ok;
 	if (conf) {
-		old = unconf;
-		unhash_client_locked(old);
-		nfsd4_change_callback(conf, &unconf->cl_cb_conn);
-	} else {
+		if (get_client_locked(conf) == nfs_ok) {
+			old = unconf;
+			unhash_client_locked(old);
+			nfsd4_change_callback(conf, &unconf->cl_cb_conn);
+		} else {
+			conf = NULL;
+		}
+	}
+
+	if (!conf) {
 		old = find_confirmed_client_by_name(&unconf->cl_name, nn);
 		if (old) {
 			status = nfserr_clid_inuse;
@@ -4302,10 +4308,14 @@ nfsd4_setclientid_confirm(struct svc_rqs
 			}
 			trace_nfsd_clid_replaced(&old->cl_clientid);
 		}
+		status = get_client_locked(unconf);
+		if (status != nfs_ok) {
+			old = NULL;
+			goto out;
+		}
 		move_to_confirmed(unconf);
 		conf = unconf;
 	}
-	get_client_locked(conf);
 	spin_unlock(&nn->client_lock);
 	if (conf == unconf)
 		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);


