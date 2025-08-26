Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0435E4C1;
	Tue, 26 Aug 2025 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218985; cv=none; b=JPRuQ7fD806V60ve9Y/XF1Db+KfbHsBzDR3w5WD6Kd0XdqFFm+sDTaD/PJNR87WbnztEFRjKKH6T0wg5CQEETveUj+on2Agj35IKfStuMrRry7LBh5ACG0J/+9WpYeMuR20KnwuO+t7MABb35ljfhtFV2VftXzeHl/9PT0FqjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218985; c=relaxed/simple;
	bh=mwJjQXd7cSxj1sq2/PtnO3t7N5+xSt2s/Wgw4dCuH/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKIZlG/p3Vxf3mphKec7KUeRKC60QoYRM3lw9rPy4iS3ZGKr191eQlx/HEVdWN7nvCtx/OwLiYY4Fx7U9K5LbbN9+5y+93vxC8S6O8P9rhhMLrY1uLhKuSTivspFuM9YewpA4vnU4xlTfDAPd6/HGitR3TKux2rI/ffUNeOOYWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOhYF4gH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOhYF4gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A53C113CF;
	Tue, 26 Aug 2025 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218985;
	bh=mwJjQXd7cSxj1sq2/PtnO3t7N5+xSt2s/Wgw4dCuH/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOhYF4gHtyGfwGqgpSXHdQlgvItO/graTEYnAVR5BPgyxNPyK6n2PwI8RAFzW42Sk
	 crzLu5QTHrawEVRjunUtPY6uX85TA1sN+DY5KZBAGmw9+aYtPFUhPDC4PeIBr3So8b
	 jVEjCLMLl0O4xnhnGcgrnNdN7R26pqEub7Xb8wnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/403] s390/time: Use monotonic clock in get_cycles()
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110912.591711204@linuxfoundation.org>
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
index 99a7e028232d..8ab537d0d6f8 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -172,13 +172,6 @@ static inline unsigned long long get_tod_clock_fast(void)
 	return get_tod_clock();
 #endif
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
 unsigned long long monotonic_clock(void);
@@ -202,6 +195,12 @@ static inline unsigned long long get_tod_clock_monotonic(void)
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



