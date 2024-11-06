Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B40B1E0B84;
	Wed,  6 Nov 2024 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898965; cv=none; b=jfcJQSUi3kGy1VOBcuU+tUqAmn/zk9+wzc4nIQwpjs+mJNFoN67iJcePL7OXoN3CaZ6jqwRyv+VwKfntXHvx10bUG1rbgbGR3H9T9Yaz6bn3g67kgMgVHt/SBE4OKwLW2EDMhT+vU/HJ03b769cKvFHDA4rugwItE8/cRAJ/VIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898965; c=relaxed/simple;
	bh=beOdNSYE6bxNlfFmrWUcK83qEIGRPE1in+xtcjyxKsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1cNfJUnXXHJy291KSOnSG+QGcKXccWHJyr9KRFd27KaNNCvo/oraCm24UZnujkq9sksd2BrpUYtV0eg3+qhWxvfpQSoBumbXPIlHJHwzTSvhnOjAGw0fPFFpabOfP2qS/pfJ+MUILGBwingWqF6tPDeiGQbE5o5ATWQq8+7FHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6b9j8DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6b9j8DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C6C4CECD;
	Wed,  6 Nov 2024 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898964;
	bh=beOdNSYE6bxNlfFmrWUcK83qEIGRPE1in+xtcjyxKsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6b9j8DGp/+lU3x38Vo1lbACQ0RmAythNq/W6mPOnULlei3Jl3Ul4L6vApaCnIsD5
	 e4I9rILcnmI2MtfQP/Y2XaO8/auo/dEYQBQanD+m+npLpvQMc58JbwIFGupHXTldlG
	 PaBlImLkQOwn6rk0EzeqXK6gPn0abvRRLtC0GJqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 414/462] posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()
Date: Wed,  6 Nov 2024 13:05:07 +0100
Message-ID: <20241106120341.742427961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 6e62807c7fbb3c758d233018caf94dfea9c65dbd ]

If get_clock_desc() succeeds, it calls fget() for the clockid's fd,
and get the clk->rwsem read lock, so the error path should release
the lock to make the lock balance and fput the clockid's fd to make
the refcount balance and release the fd related resource.

However the below commit left the error path locked behind resulting in
unbalanced locking. Check timespec64_valid_strict() before
get_clock_desc() to fix it, because the "ts" is not changed
after that.

Fixes: d8794ac20a29 ("posix-clock: Fix missing timespec64 check in pc_clock_settime()")
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
[pabeni@redhat.com: fixed commit message typo]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 369bb5caa8e3a..d123478a32c43 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -290,6 +290,9 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
 	struct posix_clock_desc cd;
 	int err;
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	err = get_clock_desc(id, &cd);
 	if (err)
 		return err;
@@ -299,9 +302,6 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
 		goto out;
 	}
 
-	if (!timespec64_valid_strict(ts))
-		return -EINVAL;
-
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else
-- 
2.43.0



