Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D161F33A036;
	Mon, 18 Aug 2025 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525420; cv=none; b=pom3Ev9/Y5Dqf1Rh5DdvSXeqNBTT/RnnB5VPr6wNPuhr7P61x8YFDVeX8zqHv2gh2hCyGySduU83GmGM7QTcV0l5XUG0QUMNt+gRm+d2OvU42J3ATOHRqvG4vb+xcfDodyIHjb+wX7HydOLLrQIpF2caTPY5V/yY+uvETzUL3PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525420; c=relaxed/simple;
	bh=lVR71w832dJSOaf5qEsg9uH1LbBZ5OB8IwIlbjkbYj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUJ1lnbkQ4nK8JheGLdykQQ6IGs1a9DfiC4gf96CMg61+ifnXn8ssPCSPNUPLqWZrLvUjLqUGg2cr5SgZm2aOxDCfntpvPUqfbzpjbRor8g3wAVarygMefaoGLNflp4+4oRCcCESUddRP0kLDO853Ud5M87RHwQfmWucvP/VbgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq7KYOf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq7KYOf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5F2C113D0;
	Mon, 18 Aug 2025 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525420;
	bh=lVR71w832dJSOaf5qEsg9uH1LbBZ5OB8IwIlbjkbYj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iq7KYOf/xqat0T/vUAJfXWYIk1WreseebRPRbb9lvLoiKwNtdU/ofET+Km4f+8IBn
	 NcHU6q2Lqd7LaMWhQgGZedD4o5t7MuthijELxP/UW4qB5rgh7bX/S7sg6tvA7kdMOG
	 iQU13zwD6Pb7TSGetnnRE8NxyfFuWe2kT+HTeObc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 257/570] s390/stp: Remove udelay from stp_sync_clock()
Date: Mon, 18 Aug 2025 14:44:04 +0200
Message-ID: <20250818124515.721663212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit b367017cdac21781a74eff4e208d3d38e1f38d3f ]

When an stp sync check is handled on a system with multiple
cpus each cpu gets a machine check but only the first one
actually handles the sync operation. All other CPUs spin
waiting for the first one to finish with a short udelay().
But udelay can't be used here as the first CPU modifies tod_clock_base
before performing the sync op. During this timeframe
get_tod_clock_monotonic() might return a non-monotonic time.

The time spent waiting should be very short and udelay is a busy loop
anyways, therefore simply remove the udelay.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index fed17d407a44..cb7ed55e24d2 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -580,7 +580,7 @@ static int stp_sync_clock(void *data)
 		atomic_dec(&sync->cpus);
 		/* Wait for in_sync to be set. */
 		while (READ_ONCE(sync->in_sync) == 0)
-			__udelay(1);
+			;
 	}
 	if (sync->in_sync != 1)
 		/* Didn't work. Clear per-cpu in sync bit again. */
-- 
2.39.5



