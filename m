Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C4315532E;
	Tue, 18 Jun 2024 12:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715425; cv=none; b=EFC8+dcp+Sqj/SBKV1ULvCBzWRKAYskM7JYYX4dyodjPaDJEy8/buKVGn2J/g2cphostey1/dv0sMaGoehY9N0wARtfIZ147VU3CYm1xiP/PwZeZAP9OPVZmTctKI2ASuzFy/OHbrxdxk/HH4wjB5N7CoctXXVdyF4tCSi/n5ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715425; c=relaxed/simple;
	bh=Q+jESuVldU8j67z2UWnfQZPwpFZRrwaeeh7dbCFUDPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ6Sic0+LcBnlfra1+M5ZS1D2xUrV6jDKKXwcJt6cLHnj4cgb6RKV7MXH/eBPl9VEYmpBflt/+Oe8gObWi2IQFA4Vw8edQqwso5BvJK2MW4wYS7vmz0BcTAOsUopb7NMMv3xDYDEJw+/WIEKBClpSten9ZERMjFnrOzdUwJ70qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzL6++0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzL6++0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C96FC3277B;
	Tue, 18 Jun 2024 12:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715425;
	bh=Q+jESuVldU8j67z2UWnfQZPwpFZRrwaeeh7dbCFUDPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzL6++0G7URQ/l7I3rvtX0azTDoxuJz99zq+SkfNJazrb53ufG7x38eDQ8/i9GuMV
	 dPqEhHn0Q724GSHNBp04nr1W3h5xT1om0cXCUhtCsEHet19upNNNHBAZArt029tZIq
	 d7BQJrqKfR2dPOeCLJFZsGmXW/zMnoQuNa4YsHrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/770] NFSD: Add tracepoints for EXCHANGEID edge cases
Date: Tue, 18 Jun 2024 14:32:10 +0200
Message-ID: <20240618123417.959653349@linuxfoundation.org>
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

[ Upstream commit e8f80c5545ec5794644b48537449e48b009d608d ]

Some of the most common cases are traced. Enough infrastructure is
now in place that more can be added later, as needed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 12 +++++++++---
 fs/nfsd/trace.h     |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 31310dbe9c1e2..adf476cbf36c3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3200,6 +3200,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			}
 			/* case 6 */
 			exid->flags |= EXCHGID4_FLAG_CONFIRMED_R;
+			trace_nfsd_clid_confirmed_r(conf);
 			goto out_copy;
 		}
 		if (!creds_match) { /* case 3 */
@@ -3212,6 +3213,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		}
 		if (verfs_match) { /* case 2 */
 			conf->cl_exchange_flags |= EXCHGID4_FLAG_CONFIRMED_R;
+			trace_nfsd_clid_confirmed_r(conf);
 			goto out_copy;
 		}
 		/* case 5, client reboot */
@@ -3225,11 +3227,13 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		goto out;
 	}
 
-	unconf  = find_unconfirmed_client_by_name(&exid->clname, nn);
+	unconf = find_unconfirmed_client_by_name(&exid->clname, nn);
 	if (unconf) /* case 4, possible retry or client restart */
 		unhash_client_locked(unconf);
 
-	/* case 1 (normal case) */
+	/* case 1, new owner ID */
+	trace_nfsd_clid_fresh(new);
+
 out_new:
 	if (conf) {
 		status = mark_client_expired_locked(conf);
@@ -3259,8 +3263,10 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 out_nolock:
 	if (new)
 		expire_client(new);
-	if (unconf)
+	if (unconf) {
+		trace_nfsd_clid_expire_unconf(&unconf->cl_clientid);
 		expire_client(unconf);
+	}
 	return status;
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index aa42d31cdfac1..de461c82dbf40 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -636,6 +636,7 @@ DEFINE_EVENT(nfsd_clid_class, nfsd_clid_##name, \
 	TP_ARGS(clp))
 
 DEFINE_CLID_EVENT(fresh);
+DEFINE_CLID_EVENT(confirmed_r);
 
 /*
  * from fs/nfsd/filecache.h
-- 
2.43.0



