Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A733FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300917; cv=none; b=QEGdRCJYbMqGSaMm4F1EeFDShvGuLzYytDRVWi1gGXYfMtSjAEr+7KwwFn/3Rmctd2yFL6Ys3D1f+6mSc/+Gom+5tv0OXxDd8D/49uIuHm8vhy1QGVuIAb9gKI00bA2AASahj+GBU8NrcWr/5YsOhb+NNS2Rk4/hTE83qSqM2hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300917; c=relaxed/simple;
	bh=S8OInPU44O8H08ja7d4spf82h8LMrpkcMHwGprFpQ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAajvKc5rSaJ22xIxzaSWlGAv+pybw1HIhKfJdS7dQCYGR+wtG0yH8egWQYWTPiCnT0r0hdZ8WsvW8HgGO6dvnkktJyIcUys2zVYIH8Qh7jSMtv2yl3p3VPwzg3RrtMUhOLvxfT7ZFD2pYfL3PNMDlO8U3ZumXpEso1EXAbS0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXgCQPBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXgCQPBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE12C19424;
	Sat, 28 Feb 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300917;
	bh=S8OInPU44O8H08ja7d4spf82h8LMrpkcMHwGprFpQ4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXgCQPBlFJGqbzSsxziIPDsvbDJeNKyjBUXkzS/zsnCpzkZmgZoX/UdNz47W3QzJ0
	 FAPynSs8ql5qY/kUyihb72twu26gE/gdCzSIuPlKw4Zax/PS4fltfhd1Yenj8PSlhy
	 qOTNomWuKXFBiqSWLICB+TuuGGNYzLB2nvr0JUVqRJKG5f4G3fU/j5KXaSVrZrSfCY
	 hiqF/1JCStd2xInCn2XCHk8iLy2PwsBjwlvcvQcyd+cJo5MLRDadn3/Ms6mhzNrGG+
	 8mgFOka7NJofVv6ytNqHfMr+8vR9m4OAMpep/ogIZXkmjCpPeELuagYEA6GDmkKTzc
	 OCEwsuQLcvhjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/752] dlm: fix recovery pending middle conversion
Date: Sat, 28 Feb 2026 12:35:44 -0500
Message-ID: <20260228174750.1542406-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 1416bd508c78bdfdb9ae0b4511369e5581f348ea ]

During a workload involving conversions between lock modes PR and CW,
lock recovery can create a "conversion deadlock" state between locks
that have been recovered.  When this occurs, kernel warning messages
are logged, e.g.

  "dlm: WARN: pending deadlock 1e node 0 2 1bf21"

  "dlm: receive_rcom_lock_args 2e middle convert gr 3 rq 2 remote 2 1e"

After this occurs, the deadlocked conversions both appear on the convert
queue of the resource being locked, and the conversion requests do not
complete.

Outside of recovery, conversions that would produce a deadlock are
resolved immediately, and return -EDEADLK.  The locks are not placed
on the convert queue in the deadlocked state.

To fix this problem, an lkb under conversion between PR/CW is rebuilt
during recovery on a new master's granted queue, with the currently
granted mode, rather than being rebuilt on the new master's convert
queue, with the currently granted mode and the newly requested mode.
The in-progress convert is then resent to the new master after
recovery, so the conversion deadlock will be processed outside of
the recovery context and handled as described above.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index be938fdf17d96..c01a291db401b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5014,25 +5014,8 @@ void dlm_receive_buffer(const union dlm_packet *p, int nodeid)
 static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb,
 				   struct dlm_message *ms_local)
 {
-	if (middle_conversion(lkb)) {
-		log_rinfo(ls, "%s %x middle convert in progress", __func__,
-			 lkb->lkb_id);
-
-		/* We sent this lock to the new master. The new master will
-		 * tell us when it's granted.  We no longer need a reply, so
-		 * use a fake reply to put the lkb into the right state.
-		 */
-		hold_lkb(lkb);
-		memset(ms_local, 0, sizeof(struct dlm_message));
-		ms_local->m_type = cpu_to_le32(DLM_MSG_CONVERT_REPLY);
-		ms_local->m_result = cpu_to_le32(to_dlm_errno(-EINPROGRESS));
-		ms_local->m_header.h_nodeid = cpu_to_le32(lkb->lkb_nodeid);
-		_receive_convert_reply(lkb, ms_local, true);
-		unhold_lkb(lkb);
-
-	} else if (lkb->lkb_rqmode >= lkb->lkb_grmode) {
+	if (middle_conversion(lkb) || lkb->lkb_rqmode >= lkb->lkb_grmode)
 		set_bit(DLM_IFL_RESEND_BIT, &lkb->lkb_iflags);
-	}
 
 	/* lkb->lkb_rqmode < lkb->lkb_grmode shouldn't happen since down
 	   conversions are async; there's no reply from the remote master */
-- 
2.51.0

