Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A2242D6A;
	Tue, 26 Aug 2025 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214419; cv=none; b=JPXqM2CQ0LHRFlRpcKHRj/8eBfOW7RVi3h0gLXOrnbj7GMGhnQg68AyVmCOapM8ULARswkEZx+0WdnSod7fF2KZfuTNc0S1yTRcWYH4Ap4SesL+I2jjBuhTEelTuMiBmCAAqSbN2+QVTvIPQktTbm+90Jk7YclXLsQg/c7LTCYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214419; c=relaxed/simple;
	bh=Ss1edDAxKL8RL7MoeZDeeRWIOhDMmOKdOq3eXcL1C2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEcVX1p8ELBvE8PlUtC+N6vM7FbwpOT+ZoM0Vxk+zo4a53ptfP1yKJL1gzMYwmB3LC/vvadMt/22XGMFiI00hKyqoHWXdxQBpz/vEVIkEX9AXyiiZAXca4ucJIQv7Yk0LUiyyaQOGqJK45Z4r3U3kv3xRkKSGiAU0sznr/6Jf34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcQlF8ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcQlF8ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF785C4CEF1;
	Tue, 26 Aug 2025 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214419;
	bh=Ss1edDAxKL8RL7MoeZDeeRWIOhDMmOKdOq3eXcL1C2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcQlF8ES7LJ4gOdRbrxO8okFfhSg6UYDd6Ec1IvNrEZYOI6QYxgH5G52+2mod/F3N
	 rmIXQd3oR4E5XyRbUXy5uezmw1A1PIgT9DwdU+C08uznNYDxr0w8cKC6RrSnnl467D
	 lNuC9kBL9RfuOtxBh+g6O6X8CDdVNS8l2bIuAa34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/482] s390/stp: Remove udelay from stp_sync_clock()
Date: Tue, 26 Aug 2025 13:06:24 +0200
Message-ID: <20250826110934.054966401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index 6b7b6d5e3632..add2862e835b 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -574,7 +574,7 @@ static int stp_sync_clock(void *data)
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



