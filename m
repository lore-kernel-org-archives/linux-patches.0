Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D351A23BE;
	Tue, 26 Aug 2025 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212904; cv=none; b=hhQdkHCxwvvkNSS3J3P43Xir5cr46K8yqIJSrrTHR0iuc5qtD1ju9NbHSqZ9bWO2cN7Rfg2Mtdp4Ef4QeQEWKAo5vH7xKbquLU58pwvfrCEeNfjScogyctTZrZFns8zpFtXmkElMJwIUc6tTWQNkXVPjD/nrbd/w8miyrEC/Csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212904; c=relaxed/simple;
	bh=mGgpwntjMm2tbqvmXwuc9aNe43sVpfkpNnJJppVav/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfwlgzR6ER0uPVTlpOP8FcnY3y78sncHrYb6q08ZwwJborNUx/vKBr+lPTmA+TQUN7KneELaQ5U0+AzjnEJyWaZbiG4/fsk0U24V3vVlGYgQ3LqEtTvGfSU63l+7ehZFP4ZU2RxgCUQceREP8un2ZFCAuA1pZF4ML0Ye5cQc0es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULhvv9yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULhvv9yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF24C4CEF1;
	Tue, 26 Aug 2025 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212904;
	bh=mGgpwntjMm2tbqvmXwuc9aNe43sVpfkpNnJJppVav/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULhvv9yLXPCuyouR98XYy/8VccaUnMts04bFSEcTttKg0k0oksw143OjHewVvjKoI
	 8qo5gL6xAL5eDtDI4utH1gt+USHIITbqmDKr/MijR5XK7ihs3Uqbn4+EncPBEj0fkC
	 WSL4C/8GtUaABQ6u02COSpzs8E62cvf+2x18rYJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/587] s390/time: Use monotonic clock in get_cycles()
Date: Tue, 26 Aug 2025 13:04:55 +0200
Message-ID: <20250826110956.666442676@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 09e7e29d2b49ba84bcefb3dc1657726d2de5bb24 ]

Otherwise the code might not work correctly when the clock
is changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/timex.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 4d646659a5f5..f7a44af12c2f 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -192,13 +192,6 @@ static inline unsigned long get_tod_clock_fast(void)
 	asm volatile("stckf %0" : "=Q" (clk) : : "cc");
 	return clk;
 }
-
-static inline cycles_t get_cycles(void)
-{
-	return (cycles_t) get_tod_clock() >> 2;
-}
-#define get_cycles get_cycles
-
 int get_phys_clock(unsigned long *clock);
 void init_cpu_timer(void);
 
@@ -226,6 +219,12 @@ static inline unsigned long get_tod_clock_monotonic(void)
 	return tod;
 }
 
+static inline cycles_t get_cycles(void)
+{
+	return (cycles_t)get_tod_clock_monotonic() >> 2;
+}
+#define get_cycles get_cycles
+
 /**
  * tod_to_ns - convert a TOD format value to nanoseconds
  * @todval: to be converted TOD format value
-- 
2.39.5



