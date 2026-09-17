Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22743AEF2D;
	Thu, 17 Sep 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671599; cv=none; b=rTPpGyzdlnnakhKUaY+atWmdzyF67nDn0rROQGM9xUV9Y0b8byl18XICSSvbSTzQ8nydpRVvediyQKJ7mqObSzLO486yYOTa2EF0XPlj4daAu67PvThQOu7DIJFfClOB92EiZqcCAAWkX5MS5zywIex+vjrgrqzxHcvXsjMkg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671599; c=relaxed/simple;
	bh=83DaHN+14sE4pkQf+R9rf3Gjn53WhGCB0PZfHvcFgKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMhNJqZNwxyCCQq96hawUi5gLCeNDVQlPhnao8UiTgh/zXaWr0nArPqBZoaXCPSW2Q49LPz7MpvVsdlhpRYC/qWhqiEyB6EGN7p81KB+MkBotDkRrHFhvjUWZVA0BCQ1OlgfLHxTPBzXcjUV/SwK6biuPhbXcZqqaX1auLJg0PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXY6DYHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXY6DYHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D8F1F000FF;
	Thu, 17 Sep 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671598;
	bh=axRiTOW9WivqE5r12bq/IT9bwWqhwfO0hLuTcqwZZvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXY6DYHWv9eECfXQ4hmmMTXIKr360DevVxr+W5vM0yBB2RHDNSLZOWMNN5j8NOlOG
	 wsQqOIQ07HdOh0hD2grVnWMOENo1pXnNKZcali61oJ5X2BfvKBlF9E5x2BsT+Vjb+U
	 NYoDuPsLlbRMB7hoOsoAfrH60Im2qIt6pzz4MznA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1029/1102] nfsd: update mtime/ctime on COPY in presence of delegated attributes
Date: Thu, 17 Sep 2026 16:16:12 +0100
Message-ID: <20260917151606.605897419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 4183cf383b6faec17a0882b84cd2d901dba62b16 ]

When delegated attributes are given on open, the file is opened with
NOCMTIME and modifying operations do not update mtime/ctime as to not get
out-of-sync with the client's delegated view. However, for COPY operation,
the server should update its view of mtime/ctime and reflect that in any
GETATTR queries.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

[ Stable adaptation: Linux 6.12 does not contain the Fixes commit or
nfsd_update_cmtime_attr(), so omit the timestamp-update call sites. Keep the
attr_update context needed by d0beaee498e1 ("nfsd: fix stale s2s_cp_stateids
IDR entry for async COPY"), and alias its newer error label to the existing
6.12 cleanup path. ]

Stable-dep-of: d0beaee498e1 ("nfsd: fix stale s2s_cp_stateids IDR entry for async COPY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    8 ++++++--
 fs/nfsd/xdr4.h     |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1870,12 +1870,15 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 			goto out_err;
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
-			goto out_err;
+			goto out_dec_async_copy_err;
 		if (!nfs4_init_copy_state(nn, copy))
-			goto out_err;
+			goto out_dec_async_copy_err;
 		memcpy(&result->cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(result->cb_stateid));
 		dup_copy_fields(copy, async_copy);
+		if ((READ_ONCE(copy->nf_dst->nf_file->f_mode) &
+			       FMODE_NOCMTIME) != 0)
+			async_copy->attr_update = true;
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
 				async_copy, "%s", "copy thread");
 		if (IS_ERR(async_copy->copy_task))
@@ -1894,6 +1897,7 @@ out:
 	trace_nfsd_copy_done(copy, status);
 	release_copy_files(copy);
 	return status;
+out_dec_async_copy_err:
 out_err:
 	if (nfsd4_ssc_is_inter(copy)) {
 		/*
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -736,6 +736,7 @@ struct nfsd4_copy {
 
 	struct nfsd_file        *nf_src;
 	struct nfsd_file        *nf_dst;
+	bool			attr_update;
 
 	copy_stateid_t		cp_stateid;
 


