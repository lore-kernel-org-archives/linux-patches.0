Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B84469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFADC433C7;
	Mon, 28 Aug 2023 10:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218736;
	bh=IaUMHpt3STjEniGv0NZgVtKmvqRxLytiHE3Pqxhx0Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw1u5/iXlDRxH6KYfP7xx95bV+lPhnoXlqTOcYEUAgoDW7OfA/M0n/rUDu4Z0bzNP
	 o+b7LXthvbOl+Fn4HBA2clT/GzdcxJcuiUgU2iGi7yBbsHJAEcjro+HN1wUPXdO8kB
	 0XhGPPZi93UrrbD/5ieuk5/m3izLbAu42rX8znE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.1 066/122] NFSv4: Fix dropped lock for racing OPEN and delegation return
Date: Mon, 28 Aug 2023 12:13:01 +0200
Message-ID: <20230828101158.628492370@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7170,8 +7170,15 @@ static void nfs4_lock_done(struct rpc_ta
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


