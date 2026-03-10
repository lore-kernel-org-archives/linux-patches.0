Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5137C388364;
	Tue, 10 Mar 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141941; cv=none; b=MkV47XQIbT/Ut1w1hKvfwUgEoH7akfWh9lKdQXoYVEVtOylrq35B86KXCMcs0r5Drl4R0gIfTxqSnz6h/m8cEscyeS0qSBy4fjYWpovd87O9gb7BsID6efTVk5iYMrT4q6xmF+zYo7QqxcLP294ke3N7mRXDQSbhq78ye6SD0BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141941; c=relaxed/simple;
	bh=KSIyL8tW1ftYIq3gAWH1W4ZN7SNZfecpnULDP/7ajq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMdmSr5Ku0NfECyVFCeXw8WaR62FnlUQtVcTZwxKStg2SKVyCSIFgEPK2Nx27mrx112q53tu0lSYIJNLn3pT/tCmGy0N7xCGKzei0RDBbSYJMy5kv3oQ28zQcWtIVzas+bIeaQ1Y7TWl4SO+TFQ5CsWZmA2jjZ+C8FCJeo9oswc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2qN7NjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2qN7NjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947D7C2BCAF;
	Tue, 10 Mar 2026 11:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141941;
	bh=KSIyL8tW1ftYIq3gAWH1W4ZN7SNZfecpnULDP/7ajq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2qN7NjPxgcF8r9Sn5bU6I/9867ylbIOZFxmJcoOoyWmUyfB5YxhYYkUXxV+I4+xi
	 oQmEKsv0JGhbmqPWygB7elX9lZyyxiTHNnKLG5pjQYbwQKVaI8rV2i/5s1uVOQsd/1
	 h4qxcPKOy3pwb2bZwvs1yY5KEONyueo7UjIOmlcISNwsgcjA9lF0U3ZKR3HSXguluz
	 RRcx9shYQuON5aTJYMZOX6E84qKKjHL0uEuP0oSGD4c8XNZeTenu/zlQfHfffAZ1Yj
	 sAKKwJr773niQ7YflonD+Ea/qdbGiG5pFrSG0rwIFe5HciPVEXrX0vvO9ajSVRqjeK
	 PI6xLytD9COdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Carlier <devnexen@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/314] sched_ext: Fix SCX_EFLAG_INITIALIZED being a no-op flag
Date: Tue, 10 Mar 2026 07:15:24 -0400
Message-ID: <77df6e7427c7838d93eefb258856b00b3d5a713d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 749989b2d90ddc7dd253ad3b11a77cf882721acf ]

SCX_EFLAG_INITIALIZED is the sole member of enum scx_exit_flags with no
explicit value, so the compiler assigns it 0. This makes the bitwise OR
in scx_ops_init() a no-op:

    sch->exit_info->flags |= SCX_EFLAG_INITIALIZED; /* |= 0 */

As a result, BPF schedulers cannot distinguish whether ops.init()
completed successfully by inspecting exit_info->flags.

Assign the value 1LLU << 0 so the flag is actually set.

Fixes: f3aec2adce8d ("sched_ext: Add SCX_EFLAG_INITIALIZED to indicate successful ops.init()")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index 601cfae8cc765..8039a750490f8 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -69,7 +69,7 @@ enum scx_exit_flags {
 	 * info communication. The following flag indicates whether ops.init()
 	 * finished successfully.
 	 */
-	SCX_EFLAG_INITIALIZED,
+	SCX_EFLAG_INITIALIZED   = 1LLU << 0,
 };
 
 /*
-- 
2.51.0

