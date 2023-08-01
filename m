Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674B41ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D43C433C7;
	Tue,  1 Aug 2023 09:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883394;
	bh=kM8fx6N1GEmr6bOnHp/WvX0HPiGl+Vp6wtI2MKKmJ2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zqis9hylp3vcYM6DGTXb0aWV4Mfr8Qm5r1lZkSNEQ1ihk9KcSkbo7q5ockLhv/9aw
	 E0ajsOprpIVUB58G8XCfUwKf+fTyxxGH0HBxHfZ0iXsIzHkTkaaINA0Ofvu0sf/Xgw
	 OdlFICXGRUzAT1mxcrf+ZbJGDeWHVGsrKXSgH0Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.4 192/239] nfsd: Remove incorrect check in nfsd4_validate_stateid
Date: Tue,  1 Aug 2023 11:20:56 +0200
Message-ID: <20230801091932.629399809@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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

commit f75546f58a70da5cfdcec5a45ffc377885ccbee8 upstream.

If the client is calling TEST_STATEID, then it is because some event
occurred that requires it to check all the stateids for validity and
call FREE_STATEID on the ones that have been revoked. In this case,
either the stateid exists in the list of stateids associated with that
nfs4_client, in which case it should be tested, or it does not. There
are no additional conditions to be considered.

Reported-by: "Frank Ch. Eigler" <fche@redhat.com>
Fixes: 7df302f75ee2 ("NFSD: TEST_STATEID should not return NFS4ERR_STALE_STATEID")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6341,8 +6341,6 @@ static __be32 nfsd4_validate_stateid(str
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid) ||
 		CLOSE_STATEID(stateid))
 		return status;
-	if (!same_clid(&stateid->si_opaque.so_clid, &cl->cl_clientid))
-		return status;
 	spin_lock(&cl->cl_lock);
 	s = find_stateid_locked(cl, stateid);
 	if (!s)


