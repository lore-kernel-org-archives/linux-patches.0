Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920571E87B;
	Mon, 23 Jun 2025 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716323; cv=none; b=ez8WWIg67VwhZWIDpO0BPXPbqivBZ3DPO/UmGD+sXMTVOSsQMeSUlXnrRnNwpSI0C19Y5VyXOhQu8AQU1hhJHyFQ9TJ9rVtRqORqV/HOC8XhDtr+bcDl1ALca0FVnvxTyB6wwD2Ag0Z9kRDAz5cFx+cGScGJHojSMzhjkmmrcj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716323; c=relaxed/simple;
	bh=ukR+0rd78kN3xN803KQtwjpEC+JQ0wCFftZP6hHdwE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq6MrmHADdL8Gyrq9oPaacWQ0A/kmWV3SZ1cMu3bcGU9zdq8okNnAEEnmvwtD/f8NGEPFP5jG5nqm9iMdp5S0YJ67NQI3JolgFTrNr86lCkYwRiTBSPAOY1dlAIMTtxWLypvW683q/86BNgGImi6Nl4SG7kHV169tl+FwehrD1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7gV2a1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7gV2a1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BCFC4CEEA;
	Mon, 23 Jun 2025 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716323;
	bh=ukR+0rd78kN3xN803KQtwjpEC+JQ0wCFftZP6hHdwE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7gV2a1Y0yKA5ioYA5rsNKEyIrVbNq19iPSdhOvKojdg0Y4OM9FuZnwOrd4KSfR1Q
	 FdxwpGnEQo1Pq6ya5aC041in3QWsVPtD6dPxE1Z5GZF8+yCIRZ6Q+b08aoXy9Xr0YU
	 YRoOaZncWXVt27/rhPbv845FpTzO0xhGFX5oQfhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/290] ptp: allow reading of currently dialed frequency to succeed on free-running clocks
Date: Mon, 23 Jun 2025 15:08:37 +0200
Message-ID: <20250623130634.621783511@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b7e8b7ebcef5..b7fc260ed43bc 100644
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



