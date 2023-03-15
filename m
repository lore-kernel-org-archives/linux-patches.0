Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DA04431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10537C433EF;
	Wed, 15 Mar 2023 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883787;
	bh=ZjpqbBZPb4gO4ILImJWvBuJUXCoGUifSuqGlkqqc4Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3GRuE1cJZuqIfTZBb0RxRr+jM6yuT5tDQn9CjOeiLYuGMGyndU1tvjXObV2Yn8Lq
	 DgNv7BcTsldyLMXCrnHxHgEc29wI/WkYuoOzvCPY6oQ58I6cajpX1NjFqkQoIp2bo3
	 Q6MvgjGtQX7wJR1c+3Z60518u2jwGOt56xzkbrwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan McLure <rmclure@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/143] powerpc/kcsan: Exclude udelay to prevent recursive instrumentation
Date: Wed, 15 Mar 2023 13:13:37 +0100
Message-Id: <20230315115744.540206988@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rohan McLure <rmclure@linux.ibm.com>

[ Upstream commit 2a7ce82dc46c591c9244057d89a6591c9639b9b9 ]

In order for KCSAN to increase its likelihood of observing a data race,
it sets a watchpoint on memory accesses and stalls, allowing for
detection of conflicting accesses by other kernel threads or interrupts.

Stalls are implemented by injecting a call to udelay in instrumented code.
To prevent recursive instrumentation, exclude udelay from being instrumented.

Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230206021801.105268-3-rmclure@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f157552d79b38..285159e65a3ba 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -374,7 +374,7 @@ void vtime_flush(struct task_struct *tsk)
 #define calc_cputime_factors()
 #endif
 
-void __delay(unsigned long loops)
+void __no_kcsan __delay(unsigned long loops)
 {
 	unsigned long start;
 
@@ -395,7 +395,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-void udelay(unsigned long usecs)
+void __no_kcsan udelay(unsigned long usecs)
 {
 	__delay(tb_ticks_per_usec * usecs);
 }
-- 
2.39.2



