Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9263815B10D;
	Mon, 28 Oct 2024 06:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097808; cv=none; b=Kd/6JE0Cn6HRRvSb6br2RgePz/L2CekoHE8gGANXsshcO3dUJb7YKsFQaQBnWtwxLkv41lXcss24p3EFfSBJKYwmzgOr8F7UxB1aPcT9GeLabe8Qs9ipyMyOr2rq09W7rDg6fWCnxwc8zFMoZ780OTwhAN0KwdaqEZ2qx541ZbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097808; c=relaxed/simple;
	bh=zj1sAU5L81tBqP1Q6YiS84WM4KxJ0s4CeF6t2EhN4J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV4NPzYBzWbddkB7koVJ+eHOy87vMxwtafnG5B8kUvQkPD1cK/RNQHh+K0OySdDpBr8SUGSXhS7Br8Nr9Zwtq2wQlJZf5SGmAvI//bMhJ0bwTuUCsV82fXhn6R4DT854LgiqdAqUajaco4aAgvKcfpbGEEWqFwBh6HJBHPkfH6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcA34oIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcA34oIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FECBC4CEC3;
	Mon, 28 Oct 2024 06:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097808;
	bh=zj1sAU5L81tBqP1Q6YiS84WM4KxJ0s4CeF6t2EhN4J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcA34oIpCAsxROfHtLJS4WFn881WZFKSd4JB4ATm60OyaUzLzUXLzo99wy4Q8+eBB
	 qytxyMli5MCCzRQ62pNpc9ruwi4zpxKNpMXMhghZG+p4WqxOfg0KdhQk3TVTc5FstT
	 WYPzmoj4ivWepI204KENJXV2SVQSGdOxjmHjhIWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/208] posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()
Date: Mon, 28 Oct 2024 07:25:37 +0100
Message-ID: <20241028062310.493769353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8127673bfc45e..05e73d209aa87 100644
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



