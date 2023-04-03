Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C76FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58405C433D2;
	Mon,  3 Apr 2023 14:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532239;
	bh=IEk2Eltw+FzXBUfpcwCSJG/KGI0ke/ppbi16yVYrGHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2J28r4eXSOtBeqB1AZE6xIurymSQJ1doCzkw/5IdNELHqUcbFTWhnywP1gbWaUmh
	 XSVZIfIxazMsFMmkDJSVuUXqPCuldVx5WOOXOBElFxW4m3Na7r4ZlvWdqHSmmrvwj5
	 Y/ufcPMaJf8+dzzL69DlWprkPK3LPKT0docsMJ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.10 156/173] NFSv4: Fix hangs when recovering open state after a server reboot
Date: Mon,  3 Apr 2023 16:09:31 +0200
Message-Id: <20230403140419.491549835@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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
@@ -1975,8 +1975,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1985,7 +1984,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);


