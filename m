Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1898416CD0C;
	Tue, 18 Jun 2024 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715334; cv=none; b=csHMQAPBWTKTNeuCdeMihetZkBffOd6c/bLtn2adIzbgVHtg+qfukZEHrRbUb1KPfv7a2Y7vvxdh8FIEdStO9f30n+3/yoiplSv7dwBaRWgpvu8mtePIWdnAOojWPmtK646+z1Y87KQCUWHeb8cK+dDfjEgoPBHVYPfcWKgnHjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715334; c=relaxed/simple;
	bh=8QHEceim3KCOKJMrT0s9qL+fiurxBfTDWGjUHcbOMbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/3zfDFzT7Y+WJaFLysq+DZvjRcH/MrI3MaHhm9WUj9nfKt8jvWF64E1aW3sbVzXkilcm6YHO4UeeO0pjscxoQiCGbL4vUcMMfVA1ZFD7fTEWbltnZLQwmMUyk6qV7hmNGL3Altm+x93C+MOjprFWzdavWNOf6otfT72Vdo6DrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yxl/y4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yxl/y4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C05C3277B;
	Tue, 18 Jun 2024 12:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715334;
	bh=8QHEceim3KCOKJMrT0s9qL+fiurxBfTDWGjUHcbOMbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Yxl/y4WSlHVCYB9TKrWCMTkUAk+Ow08RUYgvogIiOXH1qEx+dAYk1R+MwtWqLOvB
	 xeJpHPZzdBqITO/OAwxM6e6n0E/pjg5GsD/KUQiFD0ClexyJa9vd5c+4DpsNUj/CZM
	 fpGF5vsekVDe3m8R/0Y1uKTJIUYKd3fHVzjR4zyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/770] NFSD: Add nfsd_clid_confirmed tracepoint
Date: Tue, 18 Jun 2024 14:32:05 +0200
Message-ID: <20240618123417.770126638@linuxfoundation.org>
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

[ Upstream commit 7e3b32ace6094aadfa2e1e54ca4c6bbfd07646af ]

This replaces a dprintk call site in order to get greater visibility
on when client IDs are confirmed or re-used. Simple example:

            nfsd-995   [000]   126.622975: nfsd_compound:        xid=0x3a34e2b1 opcnt=1
            nfsd-995   [000]   126.623005: nfsd_cb_args:         addr=192.168.2.51:45901 client 60958e3b:9213ef0e prog=1073741824 ident=1
            nfsd-995   [000]   126.623007: nfsd_compound_status: op=1/1 OP_SETCLIENTID status=0
            nfsd-996   [001]   126.623142: nfsd_compound:        xid=0x3b34e2b1 opcnt=1
  >>>>      nfsd-996   [001]   126.623146: nfsd_clid_confirmed:  client 60958e3b:9213ef0e
            nfsd-996   [001]   126.623148: nfsd_cb_probe:        addr=192.168.2.51:45901 client 60958e3b:9213ef0e state=UNKNOWN
            nfsd-996   [001]   126.623154: nfsd_compound_status: op=1/1 OP_SETCLIENTID_CONFIRM status=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 +++++-----
 fs/nfsd/trace.h     |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8169625fdd233..b10593079e380 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2838,14 +2838,14 @@ move_to_confirmed(struct nfs4_client *clp)
 
 	lockdep_assert_held(&nn->client_lock);
 
-	dprintk("NFSD: move_to_confirm nfs4_client %p\n", clp);
 	list_move(&clp->cl_idhash, &nn->conf_id_hashtbl[idhashval]);
 	rb_erase(&clp->cl_namenode, &nn->unconf_name_tree);
 	add_clp_to_name_tree(clp, &nn->conf_name_tree);
-	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags) &&
-	    clp->cl_nfsd_dentry &&
-	    clp->cl_nfsd_info_dentry)
-		fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
+	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags)) {
+		trace_nfsd_clid_confirmed(&clp->cl_clientid);
+		if (clp->cl_nfsd_dentry && clp->cl_nfsd_info_dentry)
+			fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
+	}
 	renew_client_locked(clp);
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 2fac89e29f515..2c0f0057f60c9 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -511,6 +511,7 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 	TP_PROTO(const clientid_t *clid), \
 	TP_ARGS(clid))
 
+DEFINE_CLIENTID_EVENT(confirmed);
 DEFINE_CLIENTID_EVENT(expired);
 DEFINE_CLIENTID_EVENT(purged);
 DEFINE_CLIENTID_EVENT(renew);
-- 
2.43.0



