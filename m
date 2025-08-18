Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C39E1F462D;
	Mon, 18 Aug 2025 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522049; cv=none; b=bB3zJnFQicRZO00AAj6ubWHX1YPRU/bUrEKaCpcExKRgnsqHlojMoVg6bR8pN4Byp9kcjc6boeTSZqMej3xLkPErZhNj/5/+ernU8f8bOxiM93fb66CK6R5zHF8zBr4jESOTp1aX8thrOcptMQL1zuUkgD4TB1EJHFJTvdjvQM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522049; c=relaxed/simple;
	bh=qwRRG0qiHKiurCshkYh5BLNVXJ1Jh9ycZnDtBxUdXTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDp8F2ITvnZf6W9vnqO8zNDaHm/3mC34Syx1Bl/oOTNgX1NbB135aC/4IAJiLZC2w7rU/+svpn+ml0JHSJCQ+p+8RxmvzfjZILenL8DQe1s2o5KeB+IuHuxRwVDQF/jmtNdoTrThVqwmceCZMPv+zAy27UubLYgWIY5cqfr5GBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUBZijmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUBZijmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D2EC4CEEB;
	Mon, 18 Aug 2025 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522049;
	bh=qwRRG0qiHKiurCshkYh5BLNVXJ1Jh9ycZnDtBxUdXTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUBZijmKLUe7i2pyA8ZZ9nGwGdHalzIOfjSlxV85T3KT/sAyRLzYOdXaAD1MOED/A
	 R+vjkX7C8GTTzBlAlmvFDdfj0HD50Uf06xCTkubBrbSOL4t+tgH98qecV26LGZEgUt
	 f8AWmxm4cLI8llv09hnmsOpjwXzJlDj82OWEHFxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/444] s390/stp: Remove udelay from stp_sync_clock()
Date: Mon, 18 Aug 2025 14:43:46 +0200
Message-ID: <20250818124456.361148584@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b713effe0579..96fc41f26d7e 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -579,7 +579,7 @@ static int stp_sync_clock(void *data)
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



