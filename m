Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6952C612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5FBC433D2;
	Mon,  3 Apr 2023 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531769;
	bh=FPkH9PXy3xWR9So2Q2UJzXlHT9aVVobiwfb7/kLq0bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaB2/ULixPV0lnPPWu/7XyPLcilQqVA27qTYSpfZVLcXbzCAB2D9yxvEURYDJ4wwX
	 sjca7qT2E4XqpmcWv5rFRkWYBa2BDXLKFf9h86yoD5KxST9W1HxC3Ta9bivRSZDqqr
	 8VsSFkePBPgk4WT1ws+2Dv7ZDykLogTXTpetjoac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.4 094/104] NFSv4: Fix hangs when recovering open state after a server reboot
Date: Mon,  3 Apr 2023 16:09:26 +0200
Message-Id: <20230403140407.856701069@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 6165a16a5ad9b237bb3131cff4d3c601ccb8f9a3 upstream.

When we're using a cached open stateid or a delegation in order to avoid
sending a CLAIM_PREVIOUS open RPC call to the server, we don't have a
new open stateid to present to update_open_stateid().
Instead rely on nfs4_try_open_cached(), just as if we were doing a
normal open.

Fixes: d2bfda2e7aa0 ("NFSv4: don't reprocess cached open CLAIM_PREVIOUS")
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1934,8 +1934,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1944,7 +1943,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);


