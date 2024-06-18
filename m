Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3258013C83B;
	Tue, 18 Jun 2024 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716326; cv=none; b=VcLuZoOFjUiU00S/b2kqJGaYrZcVfPdvaxOMdIELpHpnmbFRKIlNz3Nsjo+zmQvtvUaEOMUd5bqJNj9vBK9Gtrdtqd+5sDrsTx/DJD6g50vytnCX8/e0YklXkITQ2r8k+Pd+c/1nEiw67ZsnxheSI9j7Gpsufocl3bslLqkoJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716326; c=relaxed/simple;
	bh=z7esFJ38Htqifbmtx0SaCAxeSvgMDz/xmzicl2SMclQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3vrMdtB6xhVM4H1sDJS2VJspDmMbMkzXgH0lrz7PbQzs3Bs7mcPjAkHsc4yK/9OsTWj2IvecsQkBdrlrjpzkTEi6RVCp+i7iF2wldPZswWhwppH0popciPddMJIVHYo2tMYOgQkBujG5s9Pl1xNgVTBZ+mM5AUKliUzJPWyvM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVnuClVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVnuClVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19F1C3277B;
	Tue, 18 Jun 2024 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716326;
	bh=z7esFJ38Htqifbmtx0SaCAxeSvgMDz/xmzicl2SMclQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVnuClVxEbD9aZRMQcc8GESiJR+vol5aWS9Iu53OMZJtdnT4AO6/k5aR/BhFgPKuN
	 +gTK+Zv/8ejvCmFIL7KaLKF8g1hjhXGC3VXM4pVm9pXQGD9e56aHeU50/ZSkhe05nV
	 1EGXzELmlt+LoaClT+lyI7xVDwVlWakvNjXnej24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 608/770] NFSD: Add nfsd4_send_cb_offload()
Date: Tue, 18 Jun 2024 14:37:41 +0200
Message-ID: <20240618123430.756765621@linuxfoundation.org>
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

[ Upstream commit e72f9bc006c08841c46d27747a4debc747a8fe13 ]

Refactor for legibility.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dbc507c9aa11b..332fd1d0b188d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1753,6 +1753,27 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
+static void nfsd4_send_cb_offload(struct nfsd4_copy *copy)
+{
+	struct nfsd4_copy *cb_copy;
+
+	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
+	if (!cb_copy)
+		return;
+
+	refcount_set(&cb_copy->refcount, 1);
+	memcpy(&cb_copy->cp_res, &copy->cp_res, sizeof(copy->cp_res));
+	cb_copy->cp_clp = copy->cp_clp;
+	cb_copy->nfserr = copy->nfserr;
+	memcpy(&cb_copy->fh, &copy->fh, sizeof(copy->fh));
+
+	nfsd4_init_cb(&cb_copy->cp_cb, cb_copy->cp_clp,
+			&nfsd4_cb_offload_ops, NFSPROC4_CLNT_CB_OFFLOAD);
+	trace_nfsd_cb_offload(copy->cp_clp, &copy->cp_res.cb_stateid,
+			      &copy->fh, copy->cp_count, copy->nfserr);
+	nfsd4_run_cb(&cb_copy->cp_cb);
+}
+
 /**
  * nfsd4_do_async_copy - kthread function for background server-side COPY
  * @data: arguments for COPY operation
@@ -1763,7 +1784,6 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 static int nfsd4_do_async_copy(void *data)
 {
 	struct nfsd4_copy *copy = (struct nfsd4_copy *)data;
-	struct nfsd4_copy *cb_copy;
 
 	if (nfsd4_ssc_is_inter(copy)) {
 		struct file *filp;
@@ -1785,20 +1805,7 @@ static int nfsd4_do_async_copy(void *data)
 	}
 
 do_callback:
-	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
-	if (!cb_copy)
-		goto out;
-	refcount_set(&cb_copy->refcount, 1);
-	memcpy(&cb_copy->cp_res, &copy->cp_res, sizeof(copy->cp_res));
-	cb_copy->cp_clp = copy->cp_clp;
-	cb_copy->nfserr = copy->nfserr;
-	memcpy(&cb_copy->fh, &copy->fh, sizeof(copy->fh));
-	nfsd4_init_cb(&cb_copy->cp_cb, cb_copy->cp_clp,
-			&nfsd4_cb_offload_ops, NFSPROC4_CLNT_CB_OFFLOAD);
-	trace_nfsd_cb_offload(copy->cp_clp, &copy->cp_res.cb_stateid,
-			      &copy->fh, copy->cp_count, copy->nfserr);
-	nfsd4_run_cb(&cb_copy->cp_cb);
-out:
+	nfsd4_send_cb_offload(copy);
 	cleanup_async_copy(copy);
 	return 0;
 }
-- 
2.43.0



