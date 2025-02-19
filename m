Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172C0155753;
	Wed, 19 Feb 2025 08:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953907; cv=none; b=WnxorWmXvwLoe+V7m6XOn+eEgDIUjG9YP7L8At4w6OM+HxjMk0ufsOxS1gAWJB4UYdqqG+WYG7i2MW/cKChwcJfMZ6b0GkdlyVUJ7VO6aQz2qhzDMXt+TWaF7Edmp0XWpXD6/5k+/QDrlp7LqEhmrvn12zo1KJMmnTnUjxSjRjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953907; c=relaxed/simple;
	bh=euYLHGeXouYqAKgFbfk7m+3h7ZSFqXW57JHsoSWYpz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiulF0pWSj1CCdHx1UDxWSNBvFPetpoJ6a11QlfRL1xi84ctr63Z9v8kJOulHZgke5m7MvGN1Cuxi1TxTxp9nzeOwE3asFDwsEt45Z77X2l+HyuDUhaq7iPiAMatABDICTXOCOyH5PToj/983YN4+vsckoIUTsw09FsKqAib+js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZD5N+V2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD5N+V2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C98C4CED1;
	Wed, 19 Feb 2025 08:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953907;
	bh=euYLHGeXouYqAKgFbfk7m+3h7ZSFqXW57JHsoSWYpz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD5N+V2ACzoO/h2mgk+je3xEkpfVJ4UxqHMHw/piL+d3CZ+XWdklwxNZsbLzf7mAs
	 pQKzs1EutevUhoeuwGrb7u2DeWAqlg48MFWerdGHYIuo5L0A2kFY+QhiYswGbD+JKA
	 Q6mBfn359j+SHhd5Od5UmuV1pYg75zbj4yXGMtqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 004/274] NFSD: fix hang in nfsd4_shutdown_callback
Date: Wed, 19 Feb 2025 09:24:18 +0100
Message-ID: <20250219082609.709037282@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

commit 036ac2778f7b28885814c6fbc07e156ad1624d03 upstream.

If nfs4_client is in courtesy state then there is no point to send
the callback. This causes nfsd4_shutdown_callback to hang since
cl_cb_inflight is not 0. This hang lasts about 15 minutes until TCP
notifies NFSD that the connection was dropped.

This patch modifies nfsd4_run_cb_work to skip the RPC call if
nfs4_client is in courtesy state.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Fixes: 66af25799940 ("NFSD: add courteous server support for thread with only delegation")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1547,8 +1547,11 @@ nfsd4_run_cb_work(struct work_struct *wo
 		nfsd4_process_cb_update(cb);
 
 	clnt = clp->cl_cb_client;
-	if (!clnt) {
-		/* Callback channel broken, or client killed; give up: */
+	if (!clnt || clp->cl_state == NFSD4_COURTESY) {
+		/*
+		 * Callback channel broken, client killed or
+		 * nfs4_client in courtesy state; give up.
+		 */
 		nfsd41_destroy_cb(cb);
 		return;
 	}


