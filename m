Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A9379955;
	Mon,  8 Apr 2024 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584577; cv=none; b=MvobhJpJE5hJvHyP4dPoqu/QR2/p42lXZRNIlMDQMcdlH3pb/iLPTqcKmlivN91WhkGqYRu9i0u/QGXI5LEZiz2VbnVXsZTZiphFIK00iZOBz1VSsqOPF49Wwu+HQ7gwx+eVRdYX6YKjNYjn1nm65GHOWf7pMuTQor0nxvja9fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584577; c=relaxed/simple;
	bh=4ME4xsKJbYACVYICYrJ9I6fZwc+PDBoSoEWCHvGtTys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8k0OW9Xc1Y1jVu0GSe7ErA3dS5Jc/zmMs1CSny1VPD6owqVm/gaHXDM1UQBXz+o1IynpoFat30ksSZf77Pe5vgfmy+Outi68ThxWZgB3BbFU3XIAqqwCI8+V+vMyAY8EKVJ7973dKlJfxjAbBxB3R6+bECG8v74MwsW7BQjdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGfy0xJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGfy0xJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FC4C433F1;
	Mon,  8 Apr 2024 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584576;
	bh=4ME4xsKJbYACVYICYrJ9I6fZwc+PDBoSoEWCHvGtTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGfy0xJAAgcTdThRCicMWeukHUvXN9z+J1dy2zMDuFHZ4AdxAdbE0arofs4zPiOU6
	 msi32B6JbtiTd/UZ/sdx/o1297njkqJ0sqnic51CGM1pr0jy2QSHyhIFh3A2Y7L0PK
	 0ag+mD/S9gOmeRf+h3OzW4lUwHRPSeZtTSex8oeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 455/690] nfsd: extra checks when freeing delegation stateids
Date: Mon,  8 Apr 2024 14:55:21 +0200
Message-ID: <20240408125416.115661254@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 895ddf5ed4c54ea9e3533606d7a8b4e4f27f95ef ]

We've had some reports of problems in the refcounting for delegation
stateids that we've yet to track down. Add some extra checks to ensure
that we've removed the object from various lists before freeing it.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2127067
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 61978ad43a0f7..d19629de2af5d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1071,7 +1071,12 @@ static struct nfs4_ol_stateid * nfs4_alloc_open_stateid(struct nfs4_client *clp)
 
 static void nfs4_free_deleg(struct nfs4_stid *stid)
 {
-	WARN_ON(!list_empty(&stid->sc_cp_list));
+	struct nfs4_delegation *dp = delegstateid(stid);
+
+	WARN_ON_ONCE(!list_empty(&stid->sc_cp_list));
+	WARN_ON_ONCE(!list_empty(&dp->dl_perfile));
+	WARN_ON_ONCE(!list_empty(&dp->dl_perclnt));
+	WARN_ON_ONCE(!list_empty(&dp->dl_recall_lru));
 	kmem_cache_free(deleg_slab, stid);
 	atomic_long_dec(&num_delegations);
 }
-- 
2.43.0



