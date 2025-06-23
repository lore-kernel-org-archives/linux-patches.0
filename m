Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ECC223316;
	Mon, 23 Jun 2025 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716762; cv=none; b=bN9GOI50ngfffNvLHRKN/UXZc7r3aaDnzPh8VSMEYdv5DAGd/0YNlAfD0wPE+dRGA8YQ1NAoZnPM4OFXgzEwRY/K4Oc5bYhOjZyOKiIj9eRmutVEaAoNb5IfzuZ8duyqJB4GQkC1j5Wcj07RWGZWlOwpQSyHpF8iZBFnbfMG7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716762; c=relaxed/simple;
	bh=zdqPEvyw5pcXmzrb2E37lHiT0jN5LMBL+QD766+tf+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ37IIsULQGUBr9rXfIxOrt3j9w73eEEod9pe5zvc2ttuE85DFb1gFlcLrNLasKTKM2nW5d2lSg1/YpB4tT86MbssyauZiaL1+04GXzE+0h2Mr6mOcI/8g6DUmX+rm5wTpAB55txpUJTlbm6w589XZowAIC1IvPxfDsawbZEA5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMfXo4Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMfXo4Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5BCC4CEEA;
	Mon, 23 Jun 2025 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716761;
	bh=zdqPEvyw5pcXmzrb2E37lHiT0jN5LMBL+QD766+tf+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMfXo4PnnlFPwrmwZIfgW781egyJjT2cHgnOB4/+M76rU3TymHzjeFXqg9VQ5ZzFj
	 S6x7J0iLYAsmBuw/H0Cdz5W6Lsdv5uf0cglMteR3LUHl21w/qjo2iDKnkkj4wX5Naa
	 oWZUvfZ9awJUXTIQFFj78TgQFPZnSg7wQ4soOF6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 536/592] ptp: allow reading of currently dialed frequency to succeed on free-running clocks
Date: Mon, 23 Jun 2025 15:08:14 +0200
Message-ID: <20250623130713.184938125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 35a5994bf64f6..36f57d7b4a667 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -121,7 +121,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
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



