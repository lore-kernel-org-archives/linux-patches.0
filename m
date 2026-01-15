Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460CB3BFE59;
	Thu, 15 Jan 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497155; cv=none; b=g46I+28UUOu1U/47lGJY9gjy450Hok+TDrL/BL61VBSmURvakyZYTd9KIoGPBaM7fkJFtOr+vrifgCiCksCCZhCgEJBQ9OqAYWtlxG3lKzzROF7CCaPsGw3/dMYbj1htmniNTl4gdbBuQ9GV97QDq3VfanPXMWb9lY1HmZwo+WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497155; c=relaxed/simple;
	bh=S9iQU8MfUEn5OL6q9og0coBwset3QvSS5amZ9bLM5js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nISR05TriwDk6AQXWzCTvNbx45KQxZqTGQmPylsTutaUoMT93LB+oLuHDO0pnBy7VxTQGX7TkZr/HxO/Tup1S4MK1wgzBu+ZwkQCvyB+5KzG/xJ6MeGkIK7Gm5zvdZgOx0scrS2YdkqHVoPx/ZcetwC9reaT8U0b37E7waKKMNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMRiQUEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMRiQUEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D60C2BCB2;
	Thu, 15 Jan 2026 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497155;
	bh=S9iQU8MfUEn5OL6q9og0coBwset3QvSS5amZ9bLM5js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMRiQUEnrnTL9yypS/IP1ILjSX7iRrFQk6OzLpL+c52JtMR2GV45TWBZJVxiIJvqt
	 2YjQ1zg9QqTjCoF6oJr1GqMMQB//biEQgfma5nGdxDylSPaHoSSSxKtO125um9qx+u
	 Vy8591flAvq3rzik5qeGTz5r7e7J73Xllsx0W/Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/72] NFSv4: ensure the open stateid seqid doesnt go backwards
Date: Thu, 15 Jan 2026 17:48:32 +0100
Message-ID: <20260115164144.301129043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4ae2ce56af4a..8258bce82e5bc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1700,8 +1700,17 @@ static void nfs_set_open_stateid_locked(struct nfs4_state *state,
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
index c8a57cfde64b4..0fc1b4a6eab90 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -1248,6 +1248,7 @@ DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_setattr);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_delegreturn);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update_wait);
+DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update_skip);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_close_stateid_update_wait);
 
 DECLARE_EVENT_CLASS(nfs4_getattr_event,
-- 
2.51.0



