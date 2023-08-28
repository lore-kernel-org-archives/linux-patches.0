Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41293611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7163C433C8;
	Mon, 28 Aug 2023 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219340;
	bh=h2vvPFISyrYUY4jloVnoCLBJbLUgo4nH9mN822hxP1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS+dXhcWn2k1BMiTNODlxvhp2c5B3P3RrfJazN6cmZjhpWTJS5y41elT7kN7SKCEe
	 Et515Gy2vDkIScc95K0eKUyloUg+rBkb/V7TqcK3Bvt6gXuirbNa92TihyThCsYw5A
	 +Shyi/GBZG5tWkYj4nOuyJc/Glna/+28SNEu+sFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 131/158] NFSv4: Fix dropped lock for racing OPEN and delegation return
Date: Mon, 28 Aug 2023 12:13:48 +0200
Message-ID: <20230828101201.873174265@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

commit 1cbc11aaa01f80577b67ae02c73ee781112125fd upstream.

Commmit f5ea16137a3f ("NFSv4: Retry LOCK on OLD_STATEID during delegation
return") attempted to solve this problem by using nfs4's generic async error
handling, but introduced a regression where v4.0 lock recovery would hang.
The additional complexity introduced by overloading that error handling is
not necessary for this case.  This patch expects that commit to be
reverted.

The problem as originally explained in the above commit is:

    There's a small window where a LOCK sent during a delegation return can
    race with another OPEN on client, but the open stateid has not yet been
    updated.  In this case, the client doesn't handle the OLD_STATEID error
    from the server and will lose this lock, emitting:
    "NFS: nfs4_handle_delegation_recall_error: unhandled error -10024".

Fix this by using the old_stateid refresh helpers if the server replies
with OLD_STATEID.

Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6887,8 +6887,15 @@ static void nfs4_lock_done(struct rpc_ta
 		} else if (!nfs4_update_lock_stateid(lsp, &data->res.stateid))
 			goto out_restart;
 		break;
-	case -NFS4ERR_BAD_STATEID:
 	case -NFS4ERR_OLD_STATEID:
+		if (data->arg.new_lock_owner != 0 &&
+			nfs4_refresh_open_old_stateid(&data->arg.open_stateid,
+					lsp->ls_state))
+			goto out_restart;
+		if (nfs4_refresh_lock_old_stateid(&data->arg.lock_stateid, lsp))
+			goto out_restart;
+		fallthrough;
+	case -NFS4ERR_BAD_STATEID:
 	case -NFS4ERR_STALE_STATEID:
 	case -NFS4ERR_EXPIRED:
 		if (data->arg.new_lock_owner != 0) {


