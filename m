Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300261D5CD4;
	Tue, 26 Aug 2025 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217858; cv=none; b=cmliePxVxsTlSLVLucYChq6ULVxvbcoChjj5CzQ/udPx4SVMZn2gHpyg7Gc6cONnRSsqcMVEsTKgGpU5uWzRX2pfrROCdcfLLzEUHi4NojUbXY2vYB3uYnWdO9mBDqPGAGP72EdMM6FPRgLZ++TufaD+QKzJcFMHuPyOX3Hlrl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217858; c=relaxed/simple;
	bh=094Qk2RVKGX8O/xi4aMSqL8FPVk2aa+OLvWdL9Mj4yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuOyPJA7Vy0mhr4ZzSvMdngz6VUshOjN4r7VtbVa9fbm1Ds4Vj0hojljIHrjOflaDhzDou52D86vo4PBDty/M3aNqht3PAMxYnfHPVnv6MvBt8/yDEtNIihPr+rTEXBuQ6GTYxeC5aH1sBAv8pvc16UDORHYZp/JqjJYyYNwQQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXta/0Qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXta/0Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A121BC4CEF1;
	Tue, 26 Aug 2025 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217858;
	bh=094Qk2RVKGX8O/xi4aMSqL8FPVk2aa+OLvWdL9Mj4yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXta/0QoEtRnxCbfy01vaVX/apNZQKW0cwhEwYLWE2fMkTUyCdaUSWTHP9jMyw0ny
	 MQhb7GF5spdiythPSbdqPKBYBNG8FbgChFqEWXI8Jg5IAWfXxfxjLXjdaIIeO0VQ1P
	 50sQjNrctVHDJiMOzJfixWWFqyo6CJeTwZnF9tPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/523] s390/stp: Remove udelay from stp_sync_clock()
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826110931.088267571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b6517453fa23..cd79e9cd785f 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -587,7 +587,7 @@ static int stp_sync_clock(void *data)
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



