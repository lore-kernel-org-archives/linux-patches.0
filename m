Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE2A33A015;
	Tue, 26 Aug 2025 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214200; cv=none; b=ZfnZnM84HHHnuHweN3tACcg+u4Ixzrnqa5Vsiq7FjNx73NlPFnfchn8JIf0OcOvuXnso5KDiHaNBXFlR3FlP/uUQUIhT0i/PN1GIGbveVEvInHeFva5PEKkXSmDxXWSIrbJ409VvLabEK3hSl3rGIDplXuPAzhCzNxWIAifQSYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214200; c=relaxed/simple;
	bh=Ri7Yi+owbYkqp4Cq/NfRZuRWWj8kN2T18dVtye6UHb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLW2NQ89MPSF+KmCaIbROILMJWUR9EhJO2VbciXFxHCxQGThIZaGY2/Iu2pYR2o6IRLDOYcfkLil0km88Xyd6wxuAURBgYAd9LmsUa/JE1MNEc5Avzexym+TWg46QJADRuHaa2K/EDBgHbvhDI/gKnS8+0R0cKInhbbFKKFoFkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK6KUWp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK6KUWp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61BCC4CEF1;
	Tue, 26 Aug 2025 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214200;
	bh=Ri7Yi+owbYkqp4Cq/NfRZuRWWj8kN2T18dVtye6UHb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK6KUWp3S6T5Mz17sUDlC051s2tV2qhx03fTZxlOwP+MKJGCDioM1ycouxerCQrlm
	 PYj4+rPdcqe2YTCcLMpHWeLJSdm5gYh2hDa49KSCebH0ZE6DMd45WL2PujHuBPTrsx
	 yf3zmevOKe9MTDYtFYLbIbg2lQbBCS70Jxx3++ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 016/482] nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()
Date: Tue, 26 Aug 2025 13:04:29 +0200
Message-ID: <20250826110931.189000359@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4285,10 +4285,16 @@ nfsd4_setclientid_confirm(struct svc_rqs
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
@@ -4305,10 +4311,14 @@ nfsd4_setclientid_confirm(struct svc_rqs
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


