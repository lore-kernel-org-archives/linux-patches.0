Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301053570B0;
	Tue, 26 Aug 2025 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219027; cv=none; b=UmR6ghSSYeyC79ImJJTmX6opzsGYwVYtHqzfpPg7V+88uPJYsFSXupbc0MBiAkKTZ4aVCVlf83ahzy+3upNuZOP4cPaPbmida+yKwcDaS6ODGwOgqZ8LIWvj+rNmN7t/W+FTrIBgBh/KwL4E2M/4VXmbvE42EjnyNIlaw2oz9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219027; c=relaxed/simple;
	bh=QC2zZuDuUaVWS/62hnhlN5ROYWtEA4kND+6XoC16maA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCOWw+x6QCmJp1X7GKNv2H5SI9pcusQicffdX32ryfaO3hnrvxPvtMHYtGTpbbZpQD/D7NsxYqLjX548heGDMNQm5p21LRu8zJf57Rd6t6iPwjEoDYJaJAP0D876vbPAC17K0JJSYUwk5sYh2XZ5eZ1iaosff9C4U3deLcNMbxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsWQchTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsWQchTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD52C4CEF1;
	Tue, 26 Aug 2025 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219026;
	bh=QC2zZuDuUaVWS/62hnhlN5ROYWtEA4kND+6XoC16maA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsWQchTGTvcz4dRfbE/R3Yq0YPdYqjaO1oDECCBK5Nl5Ezv7iXUdwlOAk2A+WcMZL
	 CEF1gXEL8VxPjPEc6uFrGykneBtuwU+FDPVb7vH5keMjTlOKQ6r5r4jGQ1wI3E7+Bs
	 MZqzj7XwyLlabu7IJLPJBY1hioP4wmi9tlxqnjcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 217/403] s390/stp: Remove udelay from stp_sync_clock()
Date: Tue, 26 Aug 2025 13:09:03 +0200
Message-ID: <20250826110912.833225600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 11c32b228f51..0e1925104fcf 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -642,7 +642,7 @@ static int stp_sync_clock(void *data)
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



