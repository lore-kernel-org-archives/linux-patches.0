Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6164C21A95D;
	Thu, 15 Jan 2026 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500009; cv=none; b=E/jYxc+NhoJGZizzYOlIyHBDQAq0qV3BLEcFlzXx99fXeheN4gcq9moJ4kuOz/BtP9vIlKYC1BXDjjZQ9sPyS8GRC6Apwt2MNKsiVikvE0g//2tExsBVE8tKYcJHY/GiKCj70IulPn8tBl5EmLJjkNJY1kp9e/CMURaZk1jwt6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500009; c=relaxed/simple;
	bh=wZQZE+PqWbd0WgFnCdqH54cPrBhSSWPrEnjwnnxmwew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF2fGjhi9+sgikPksSVmG35yhIM+HUy4tcCqi/bCfofHm9AuGuHI9VCaThgkCXZ0+DBlz9DeKSmYemIA4TBTCnVzSaN+TZ9qTx+i2uj/7EPVHFYl/ZyXF5oULwYZ16vWG1+3nq05I9T4vyy8vTYD5+reZzKmIl4Wa105WUR48II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHMxLWks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHMxLWks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1755C116D0;
	Thu, 15 Jan 2026 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500009;
	bh=wZQZE+PqWbd0WgFnCdqH54cPrBhSSWPrEnjwnnxmwew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHMxLWksY8bdieMjeyZDoMYKYiUA6Npw1iS+P6KzQMnZZX+QY6758unb64g3fU7u/
	 oC89n0+Nm2HeEErcKQiZ6EohiGuysozPeD4pOs3Q3KXAxd1FPYJb7LryrBGPl4zuDD
	 KeIUiN2T7S3QuNoPaeQ4cJKHIo+nRAKCH+Te0Ggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/451] NFSv4: ensure the open stateid seqid doesnt go backwards
Date: Thu, 15 Jan 2026 17:50:28 +0100
Message-ID: <20260115164246.387487412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 2e47c3cc64b44b0b06cd68c2801db92ff143f2b2 ]

We have observed an NFSv4 client receiving a LOCK reply with a status of
NFS4ERR_OLD_STATEID and subsequently retrying the LOCK request with an
earlier seqid value in the stateid.  As this was for a new lockowner,
that would imply that nfs_set_open_stateid_locked() had updated the open
stateid seqid with an earlier value.

Looking at nfs_set_open_stateid_locked(), if the incoming seqid is out
of sequence, the task will sleep on the state->waitq for up to 5
seconds.  If the task waits for the full 5 seconds, then after finishing
the wait it'll update the open stateid seqid with whatever value the
incoming seqid has.  If there are multiple waiters in this scenario,
then the last one to perform said update may not be the one with the
highest seqid.

Add a check to ensure that the seqid can only be incremented, and add a
tracepoint to indicate when old seqids are skipped.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c  | 13 +++++++++++--
 fs/nfs/nfs4trace.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e3070982a909a..170e9eaf536af 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1688,8 +1688,17 @@ static void nfs_set_open_stateid_locked(struct nfs4_state *state,
 		if (nfs_stateid_is_sequential(state, stateid))
 			break;
 
-		if (status)
-			break;
+		if (status) {
+			if (nfs4_stateid_match_other(stateid, &state->open_stateid) &&
+			    !nfs4_stateid_is_newer(stateid, &state->open_stateid)) {
+				trace_nfs4_open_stateid_update_skip(state->inode,
+								    stateid, status);
+				return;
+			} else {
+				break;
+			}
+		}
+
 		/* Rely on seqids for serialisation with NFSv4.0 */
 		if (!nfs4_has_session(NFS_SERVER(state->inode)->nfs_client))
 			break;
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index d862df9761e77..3d538cb60593d 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -1513,6 +1513,7 @@ DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_setattr);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_delegreturn);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update_wait);
+DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update_skip);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_close_stateid_update_wait);
 
 DECLARE_EVENT_CLASS(nfs4_getattr_event,
-- 
2.51.0



