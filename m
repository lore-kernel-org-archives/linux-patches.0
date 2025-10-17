Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580B832C92B;
	Fri, 17 Oct 2025 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715094; cv=none; b=kNWo8Z3wZo9YHM6L/6hfWFYQ4AsJaN9FcIrQRounuMmAsIjT9MMRmXlBWda6aOGyO6eRYV+H7aqdo7PnbHAOUlYK6XVjvkQRHXibfSo/X/CVYKaAyWXwW9EBm8jTvWKRlU52RrJiAIiVbjoLxs61gPb5KT4nuAsdWjt7ZzL43nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715094; c=relaxed/simple;
	bh=zBH4E2FhGmWm9AiZktmXlvox8tyodQxwsCaOffAlC9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwfmqnswhdNHtNiXTV/H3mOKKxKEUQLDTfXjIEbdS5tx7yod0iirnZevYeKwtsOticNoX3ljvR6GAB7FHmISKCI/Opev8H4KeanUw3OAfoPeoNp+s1JsaTADxcONoGYDseL7E+SiUEYbpEufkNv1cPPeTgL/aS9XZqvDstNncqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ht1004ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ht1004ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D458C4CEFE;
	Fri, 17 Oct 2025 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715092;
	bh=zBH4E2FhGmWm9AiZktmXlvox8tyodQxwsCaOffAlC9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ht1004hakhpETTKH/1UwKnXW+ErrMpXWJEBLsP1lJ54Fr9cg4P7jQWcWNuv4PonHj
	 9kWeXW3sCi7S58CpGL3anVjeZKl6ePUVVATbr+VLo0QRuFFLOfM524sg2SpWOefPJ0
	 aEXmNNrnx9O4Oz448GjyFxGKxPqfPOf+lcibABLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 062/371] nfsd: fix timestamp updates in CB_GETATTR
Date: Fri, 17 Oct 2025 16:50:37 +0200
Message-ID: <20251017145204.043866901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b40b1ba37ad5b6099c426765c4bc327c08b390b9 ]

When updating the local timestamps from CB_GETATTR, the updated values
are not being properly vetted.

Compare the update times vs. the saved times in the delegation rather
than the current times in the inode. Also, ensure that the ctime is
properly vetted vs. its original value.

Fixes: 6ae30d6eb26b ("nfsd: add support for delegated timestamps")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f2fd0cbe256b9..205ee8cc6fa2b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -9175,20 +9175,19 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
 	int ret;
 
 	if (deleg_attrs_deleg(dp->dl_type)) {
-		struct timespec64 atime = inode_get_atime(inode);
-		struct timespec64 mtime = inode_get_mtime(inode);
 		struct timespec64 now = current_time(inode);
 
 		attrs.ia_atime = ncf->ncf_cb_atime;
 		attrs.ia_mtime = ncf->ncf_cb_mtime;
 
-		if (nfsd4_vet_deleg_time(&attrs.ia_atime, &atime, &now))
+		if (nfsd4_vet_deleg_time(&attrs.ia_atime, &dp->dl_atime, &now))
 			attrs.ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
 
-		if (nfsd4_vet_deleg_time(&attrs.ia_mtime, &mtime, &now)) {
-			attrs.ia_valid |= ATTR_CTIME | ATTR_CTIME_SET |
-					  ATTR_MTIME | ATTR_MTIME_SET;
+		if (nfsd4_vet_deleg_time(&attrs.ia_mtime, &dp->dl_mtime, &now)) {
+			attrs.ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
 			attrs.ia_ctime = attrs.ia_mtime;
+			if (nfsd4_vet_deleg_time(&attrs.ia_ctime, &dp->dl_ctime, &now))
+				attrs.ia_valid |= ATTR_CTIME | ATTR_CTIME_SET;
 		}
 	} else {
 		attrs.ia_valid |= ATTR_MTIME | ATTR_CTIME;
-- 
2.51.0



