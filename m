Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8391832A3FA;
	Mon, 18 Aug 2025 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523557; cv=none; b=RQACU8C/wWQjQ6O2qo7kXgWOPGpSh653nTUpq6SDIhL7EG8NxtUdkx7GzXIDk5UnNG9Pz0337q5Fo5KitUYjOeymlKECChGG4dxItZ95AXg8nzLVXEpp6oT2o1U5oMtZ+gArO9Vks5RZ+LF7GXwdaDZ5ETPFcTpVboSJOyxld+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523557; c=relaxed/simple;
	bh=WmPOM6Bn9HYhpLuUdfvNEw8Q215xf2u7IcNkTwlkZxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhX/N2nEZ7ZpUmpOkxwiC4d5GOqamf3WbD0IimAmEGAlI8jM4UyMUR8L+4rbu9VjN2m/afuHCyEnBQJaj5QpRSPVcmhTMOpo7I21cLpMuLl8OB3ZkGX7mNiYkuvY9F+b23ZJ7R/LIVlGTDjiQPnz36UnfGWjA0C5FBfusjtmuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nR5UgN+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nR5UgN+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97707C4CEEB;
	Mon, 18 Aug 2025 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523557;
	bh=WmPOM6Bn9HYhpLuUdfvNEw8Q215xf2u7IcNkTwlkZxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nR5UgN+0LZOEysL1vFBV3D8lP9xUWsLlPvxdpzsFC2L6iWYOHcGB4sWLT2Vb87JWT
	 IRZA995S/RU6nGbfPwpQFFKMzPjJhfpdDu3ZoHrTubLH5VUijTMX7QKFbeCUmfNVah
	 c/R9SCTlEumxNJUHK+BtJtFVM+pY9OTFO6DGX5oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 207/515] s390/time: Use monotonic clock in get_cycles()
Date: Mon, 18 Aug 2025 14:43:13 +0200
Message-ID: <20250818124506.334166182@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index bed8d0b5a282..59dfb8780f62 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -196,13 +196,6 @@ static inline unsigned long get_tod_clock_fast(void)
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
 
@@ -230,6 +223,12 @@ static inline unsigned long get_tod_clock_monotonic(void)
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



