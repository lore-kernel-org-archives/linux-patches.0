Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA122D1F40;
	Tue, 31 Mar 2026 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975549; cv=none; b=Hb/FaHAhGZ6BTC4CnkqW/DlHqXevqTEHWlUEVcFUzCE79IASwH3u9EE2Prrh2Wto0cVVhfWDjal1XaypU9tWcPx8CaDzR3zvTNhmUr/IOCZlQhDnAOYq8XRlstvsH8yidEBE2jiCe5NEui24z22j6l5XwOXZOfxWheCGtO8bFec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975549; c=relaxed/simple;
	bh=vGAuRw0rwL5uRJ/sfwM3UMWuQEwR0GDIurYpsGTGUnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8ZdwiNCmgCMTONyQJpUA9WsVUPkhJQZ9fK6E3eVd1NEfhBzXS0egSSTwIK3H0jM1IWtkN8hOiEnVwoZHsY3D1tMPZXXOylhZ67E0Ax/KoHslr44EMSfN8pkDB1KHP0hvVdFU2VYddZqZEvRftb5V4lQuMEKUI6FRtGI93U6xyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxb2gjBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxb2gjBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769E5C19423;
	Tue, 31 Mar 2026 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975549;
	bh=vGAuRw0rwL5uRJ/sfwM3UMWuQEwR0GDIurYpsGTGUnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxb2gjBno1I37yqeT/xCgosS79mpZFXcrUX3jBVlBTYOBqZ9fYIUT2W+3EcYnS8cl
	 azMYgAWi9p3ubfOZvwAXRkkr0D0Ut6itlsw4UUFS/x9Fbo9L4UHX2K4WI9jZfH493m
	 lSRigZaJhoOtiPp3qxsVAOX7GXK4PPEeESC+eVwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 337/342] futex: Require sys_futex_requeue() to have identical flags
Date: Tue, 31 Mar 2026 18:22:50 +0200
Message-ID: <20260331161811.301831720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 19f94b39058681dec64a10ebeb6f23fe7fc3f77a ]

Nicholas reported that his LLM found it was possible to create a UaF
when sys_futex_requeue() is used with different flags. The initial
motivation for allowing different flags was the variable sized futex,
but since that hasn't been merged (yet), simply mandate the flags are
identical, as is the case for the old style sys_futex() requeue
operations.

Fixes: 0f4b5f972216 ("futex: Add sys_futex_requeue()")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/futex/syscalls.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 880c9bf2f3150..99723189c8cf7 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -459,6 +459,14 @@ SYSCALL_DEFINE4(futex_requeue,
 	if (ret)
 		return ret;
 
+	/*
+	 * For now mandate both flags are identical, like the sys_futex()
+	 * interface has. If/when we merge the variable sized futex support,
+	 * that patch can modify this test to allow a difference in size.
+	 */
+	if (futexes[0].w.flags != futexes[1].w.flags)
+		return -EINVAL;
+
 	cmpval = futexes[0].w.val;
 
 	return futex_requeue(u64_to_user_ptr(futexes[0].w.uaddr), futexes[0].w.flags,
-- 
2.53.0



