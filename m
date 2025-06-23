Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ECEB676;
	Mon, 23 Jun 2025 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717705; cv=none; b=IjW+36MMt8SZC9mV+tGzwgHk1tCa1mSJY6x3v2SDE3qXTakDAHcnt6ynoL6jCM/3bwdqi0LOTQ0aHgwt+oPBgz2uE8RKn3a7RrFJ/wIKLYCrIeHSPQt20j2KB4qjV4bnHdyAJgP50jHbnoP34oRE7xuMstcCaBMhaWZVLpk0FnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717705; c=relaxed/simple;
	bh=1bm3qEBb9uBxwFBIYJGg1eM0KKbXf8/t/KjYS4+FSfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnck9H/mvz0H/SACmgj5N+W/4vNL3/VCUrpThsuM4adf1Ma9lVsq+i7TGtUgJ8Af+YUya2laulMMnbvP4s80hbU8sV7cCcp38ZnExeLtemRFlH99iTzbcai8IvZvXK/UjXGACD7EaVYDq0+Q8/ZFSkGDfpwznD89r0VnI3WDxmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xB4uDijp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xB4uDijp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31105C4CEEA;
	Mon, 23 Jun 2025 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717705;
	bh=1bm3qEBb9uBxwFBIYJGg1eM0KKbXf8/t/KjYS4+FSfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xB4uDijp1v/slsJVFhVL9l2YbsX9b3XycmYIPMncPeH+x35+IEOVrcEjiFcii+n4x
	 n72dgDyUss1k50GZgZw/azZXHK7lgGoMcvwU1leo9OYoLq7TNW35nQZaVvs42l1Qu1
	 hSpx3AzMBW7Y9ck/pYeGEwoXqgWw6VPAjco+p7S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 480/508] ptp: allow reading of currently dialed frequency to succeed on free-running clocks
Date: Mon, 23 Jun 2025 15:08:45 +0200
Message-ID: <20250623130656.881806302@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit aa112cbc5f0ac6f3b44d829005bf34005d9fe9bb ]

There is a bug in ptp_clock_adjtime() which makes it refuse the
operation even if we just want to read the current clock dialed
frequency, not modify anything (tx->modes == 0). That should be possible
even if the clock is free-running. For context, the kernel UAPI is the
same for getting and setting the frequency of a POSIX clock.

For example, ptp4l errors out at clock_create() -> clockadj_get_freq()
-> clock_adjtime() time, when it should logically only have failed on
actual adjustments to the clock, aka if the clock was configured as
slave. But in master mode it should work.

This was discovered when examining the issue described in the previous
commit, where ptp_clock_freerun() returned true despite n_vclocks being
zero.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250613174749.406826-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index af66ed48dc006..642c939d4523c 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -104,7 +104,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	struct ptp_clock_info *ops;
 	int err = -EOPNOTSUPP;
 
-	if (ptp_clock_freerun(ptp)) {
+	if (tx->modes & (ADJ_SETOFFSET | ADJ_FREQUENCY | ADJ_OFFSET) &&
+	    ptp_clock_freerun(ptp)) {
 		pr_err("ptp: physical clock is free running\n");
 		return -EBUSY;
 	}
-- 
2.39.5



