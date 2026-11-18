Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035254;
	b=kncBZJfK5lX5wKcylnBlccPHqIo7m4v2skr78k3pJ/PYtUk7OxODo6CG+h03N9BVim49
	 HcE/LObCLaqKFYKf/aPbs+RSrhKi4ZJF0z8+jdo23hXEm2T8Jea2dirJcrXITRppTICrI
	 SYPDlZGtRA7YcAgvzifdDHjBOljQ3KescPnqlLbuQLngDXIiBMUQ8xq8SX4Yw/TF6Jqml
	 iwzIg2Vh0Spy169YcYLhWxX4WZA0jVox9Z7732hrvdgTJAaozvRqm6kVw2i4wGZuYssHJ
	 UA3/VB8z0+TZ6G6Pa5In+br4uyGdN6hM3ia8owjM7IXzowxH9pSgP+XS3Ji0wsCK1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85gBbppKJdGtDW7vjO/+a3EqhSKRjOlgtRBLMkOnxds=;
	b=wCYgY4k7WUTHBaj1ZyNLc6S6Y0vU/fmRRlKuQsT4CvRXTieVsdgeQwOYXffRIXVDuCte
	 mP180lAk1J3ADAyhZ06mlbrNXUDNBj3OtsJUm1I/09ibTn4r4ShkuSgW0JYdkUp/2dB/P
	 lCKiXdSZjiFoM7d6bYTqTcz9hZO5j6k3KwAGSslH9OKABg2USPHVGNkPbC99qmzOT9Ix0
	 BdZrRTW/B7hRk5An2ps+pOqrhMQx/oN11B5SVd+nRfsC+1+ZKFJiU0cLYM/ONQ5q7u1xt
	 SG6D5isNwC6SsS/CwqDgiJ+dRWjSoz6lGU2cFpRReZt//EtHbcvjorC4qx76qxULlxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Q4gWAHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF251606A32A;
	Wed, 18 Nov 2026 20:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Q4gWAHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A8E1F000C4;
	Wed, 18 Nov 2026 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035254;
	bh=85gBbppKJdGtDW7vjO/+a3EqhSKRjOlgtRBLMkOnxds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Q4gWAHk2LlyD7Dr9blHKjn9PL+HohCW0ZlFrSux0xzx7NBwZVUl28JSSsd1IyVSM
	 Ns5LJ4+kuzOB+DNeoI6WvgZTDw8cUO1h+uOvzHKukZRpuIrf1Vw0yLoZiV6nUSOyPF
	 BKGRA0MgdpkgnRWhKpNhyXAH2z3mJUFyVI8X8FAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0661/3318] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Wed, 18 Nov 2026 15:21:23 +0100
Message-ID: <20261118150337.896625517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d3cb9fe94bbe..c087fd5d3d301 100644
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



