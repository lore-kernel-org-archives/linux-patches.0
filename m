Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A6D34DCC1;
	Tue, 26 Aug 2025 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219346; cv=none; b=NAC3cbQ+JDlbotXzsWX878YTjk3jCPpI3KXGa8iqIH3H9bW2/lrf7bTZDn1Wz44gOk8x4HoO0KOuL13EtvBQBfiD+tLH9+QBTYBmcTwk6in6GhpbEmSLEUh1DWu29/H8BSzITMG4Ysb/37QlWT90um1CX2TL3V9TH0gQcKfy6UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219346; c=relaxed/simple;
	bh=wILl2yiJcdxppjF5VBvaBvZj4Mbqjwe7UbOwomXqAWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeTubL1UVJ/b+QAfFlBwsSVyzQDtAztMRp2s46WgnnGuvsDXozieTVy07wTxIn8edohBCbXPtpcdpDE4La8nbIjIhWfcoPwSCktOYtpYwAaypGSPS67Fdwu31pTdsj6jr8SuTmC6rGaV6ERFp+iA+v5Hbyxwu0yiUsFuW++7dWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQNrQ9xD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQNrQ9xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD59C4CEF1;
	Tue, 26 Aug 2025 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219346;
	bh=wILl2yiJcdxppjF5VBvaBvZj4Mbqjwe7UbOwomXqAWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQNrQ9xDBUCqKm5R1C5EkSoXDzHRDTJ/CgozKzSOYdLkjRojjm2/PJFuquxjfpo3d
	 GvoGp1HkUEaYfmoEqgDtSarLxbCVJD0pGNqM8mwmwlZlzh+iBfCl0dsquMr8QN7PZu
	 e9ag6dBhPXDOv1Kw+iNeqsGOtPnSG8Ujmdmg2laA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 346/403] nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()
Date: Tue, 26 Aug 2025 13:11:12 +0200
Message-ID: <20250826110916.424420671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 908e4ead7f757504d8b345452730636e298cbf68 ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3956,10 +3956,16 @@ nfsd4_setclientid_confirm(struct svc_rqs
 	}
 	status = nfs_ok;
 	if (conf) { /* case 1: callback update */
-		old = unconf;
-		unhash_client_locked(old);
-		nfsd4_change_callback(conf, &unconf->cl_cb_conn);
-	} else { /* case 3: normal case; new or rebooted client */
+		if (get_client_locked(conf) == nfs_ok) {
+			old = unconf;
+			unhash_client_locked(old);
+			nfsd4_change_callback(conf, &unconf->cl_cb_conn);
+		} else {
+			conf = NULL;
+		}
+	}
+
+	if (!conf) { /* case 3: normal case; new or rebooted client */
 		old = find_confirmed_client_by_name(&unconf->cl_name, nn);
 		if (old) {
 			status = nfserr_clid_inuse;
@@ -3975,10 +3981,14 @@ nfsd4_setclientid_confirm(struct svc_rqs
 				goto out;
 			}
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
 	nfsd4_probe_callback(conf);
 	spin_lock(&nn->client_lock);


