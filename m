Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561361DF73C;
	Wed,  6 Nov 2024 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895724; cv=none; b=e4Cn+KSD5h6EkW/jOiU5Wl0YjHWJl2XHeJT7teEFCvO39mSaMxsGQkX9pup3oEPfRqV+PAkhZ9/bSi9+IroYippRGWKXq1ldpaMADiCuYGtQMn56vWYh0SPOp2xFDgMGxto0NAz/k4yUO0kvZLD6lLldar5dCi54JHSoP2OJ/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895724; c=relaxed/simple;
	bh=05gSxXv3GUaZsdVN19SWpNELepyB0djIA2hQbRlzAxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/zJFm4gYSH3flnIypPu2U+YupzENVt51MSCrmckB720moTUJ3DJqm1Fl9iVSdnQzVZFu62UWX2ih9XO92yAw8VOONPp5fXIQudLJh7pztl3yvu83oFp6po/iba9EUy4dN+0OQQAxF3p2rkNNU8kkoSJEuWh1eCkZKISkMqNzZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMHzeHgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMHzeHgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1BDC4CECD;
	Wed,  6 Nov 2024 12:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895724;
	bh=05gSxXv3GUaZsdVN19SWpNELepyB0djIA2hQbRlzAxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMHzeHgu74k8nhaiPRS/gw1QChuKScIN6DX+Ic5Mr+8Yn78vYgd2D4VC8hUkY9mU4
	 qF0Qjwd9lbzt9Il36qlPOHk+EanbYe5CQJHXvwb1F5dTSg8OECcCxhrgxRKi8yUozO
	 E1a9K+jNTfs+IE0FVlVhAqLdkGnzC2llsVh5q+jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 314/350] posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()
Date: Wed,  6 Nov 2024 13:04:02 +0100
Message-ID: <20241106120328.523314225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index cda319c7529e5..c1e5feff8185d 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -303,6 +303,9 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
 	struct posix_clock_desc cd;
 	int err;
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	err = get_clock_desc(id, &cd);
 	if (err)
 		return err;
@@ -312,9 +315,6 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
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



