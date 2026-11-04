Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831630;
	b=L4sJ6PGAGSLx93h3g98WayvdV29nYYWGSleo2dOufLsY84+BezeKFjfg4McCfBc5VJR1
	 aey/Y2tTo13gZA2mkwdE15PIv39VQV4E1uYmH49PwCGJGm6mzq1v3rM9CeT3+IPijrfR1
	 nZNSPgeZ34L36RyoYRtSWmCi3E5MgJTra97H3C4C+IWKhw51OB9jpZhX+YG44BRaF8rQC
	 jTowEw0S5is05Iiqr86nxBtBj5G1lFip6usGsLzCXQcwaXYR0dk/cmEzyojzO+BqAJFUm
	 sVrX62wKLSui/pniVbPyT9Hr76eJDe5qXl3HLyfZoLHPhEZ20n5FbxS20O0Cl0NckJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D1mMzaYZYiuYB650DEgoRbV2J8b6mLwbFi5K3cvoALs=;
	b=e6UosQ0xPa87XjgA1WzUNTcAPaZyYqlZX6xFww76S8iWhxFFJwz8+AHOB3leuE4ey5kp
	 IdDMhifmIDx2Za99L4sgD93o1f0BFKXThgC8Evc0gXJu8Ho5SJcA6JoWcywbs8Ph2O+e3
	 cQhpA8C9SpintQ8qi5V/MvqrDAKQ860+bR484QMdgKhA94jANmpu/PukuXs/GFGGfKmIq
	 r9ZO8NW5w1fmcjY8VSu42dU+ig5BsFLZ0uJW81kY/Ms9A+S0hoS16+ugD9ISzeUv1PG2G
	 6B2N7jR5NeK0T1fDfrotcqo0S45D0HwCZQ+cM4UxgM5DQgR/0Nq9HgGiGZ3aDopDqBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMUesq0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EE6606AC2A;
	Wed,  4 Nov 2026 22:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMUesq0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111E01F000C1;
	Wed,  4 Nov 2026 22:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831630;
	bh=D1mMzaYZYiuYB650DEgoRbV2J8b6mLwbFi5K3cvoALs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMUesq0ABXDmq6Ab5NDEzwJz5NjM/bXcZdA4YS1Wg0m97cHHXkTqUn2Rw0dni2+Fy
	 n72Kc+kjcM8Y/9rd5O0eNdm5y17c7DiBo3MTJZOKcI94vQtD+5TGqoepSYzvIQgZzH
	 txSp9mMx4U7cZ0tC8xAe3QqggR8PyuNGp9w/tRnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0821/1005] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Wed,  4 Nov 2026 16:09:14 -0500
Message-ID: <20261104211106.338744496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

For leases, oplock_break() increments breaking_cnt before calling
oplock_break_pending(), and returns early when the pending check
reports nothing to break: the level is already at or below the
requested level and, for a lease, the state is not HANDLE|READ
caching.  Neither early return decrements the counter, and
wait_lease_breaking(), the only place that force-clears it, sits
below those returns, so breaking_cnt stays elevated for the life of
the open.

A stuck breaking_cnt makes same_client_has_lease() skip lease
upgrades forever, and every subsequent same-client CREATE on that
lease is answered with SMB2_LEASE_FLAG_BREAK_IN_PROGRESS, so the
client never resumes caching.

The ordering dates back to the original SMB3 server code, but the
early return became routinely reachable for leases already broken to
NONE when smb_break_all_levII_oplock() stopped filtering out
non-level-II leases in 17699905a381, "ksmbd: fix lease break and ack
state handling".

Move the increment below the pending check so the early returns
cannot strand the counter.  This is the minimal equivalent of the
reorder that mainline made in b0148dc5625d, "ksmbd: serialize oplock
close with pending break ownership".

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 7d78d4ae43acb..90cd8c962f785 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1012,10 +1012,15 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
 
-		atomic_inc(&brk_opinfo->breaking_cnt);
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
+		/*
+		 * Increment breaking_cnt only after the pending check
+		 * above: its early returns would otherwise strand the
+		 * counter, as wait_lease_breaking() is never reached.
+		 */
+		atomic_inc(&brk_opinfo->breaking_cnt);
 
 		if (brk_opinfo->open_trunc) {
 			/*
-- 
2.53.0



