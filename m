Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A811869;
	Wed, 22 Jun 2022 17:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C53C36AE2;
	Wed, 22 Jun 2022 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1655919874;
	bh=+kC/zzrxsO6n8cq3xnxIXvNTnaexwmD8lJHtOZ0k0OE=;
	h=From:To:Cc:Subject:Date:From;
	b=JIm6M8SVTqwLJWdokvyB9ukWoNBDYjrRlZT9aPXc+g21G99AePhExJcranIXDjeXK
	 9U9ezEqLlY3NU+WV45rtOxw+oWcuD00xjai7EQlA/5xy/45EhUxXTCFkvxCUMOWCUp
	 k2GUzDIzhbrDS1+C8Kfs8RNwmsmpEV13eVBc/Wb0XUyskOI9miNik90LagB4khtBTH
	 JqhqwHMxwUPJsllHAk6QKhxOGlhxEXRha/PdsBRkvxHhWh/4KCS7eenIN2JoVx+yr8
	 ALWaT53kjxDVkg7AkER7y3g9irS6ljMV88zGURx+GbLjxPFOiLFJh1Q3vpn4wUExkD
	 Ycyh7ZeNsCFAw==
From: Nathan Chancellor <nathan@kernel.org>
To: Jon Mason <jdmason@kudzu.us>,
	Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>
Cc: Alexander Fomichev <a.fomichev@yadro.com>,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] ntb_perf: Fix 64-bit division on 32-bit architectures
Date: Wed, 22 Jun 2022 10:43:26 -0700
Message-Id: <20220622174326.1832697-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.0.rc1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling for a 32-bit architecture, such as arm, an error occurs
during modpost:

  ERROR: modpost: "__aeabi_uldivmod" [drivers/ntb/test/ntb_perf.ko] undefined!

The tries member of struct perf_thread is u64 so a 64-bit division
helper is needed. Use div_u64_rem() to get the remainder of the division
so that it can be checked against zero.

Fixes: dc150dfb081f ("ntb_perf: extend with burst latency measurement")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/ntb/test/ntb_perf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
index 23e154bd41b9..4e05c7aa070d 100644
--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -1118,6 +1118,7 @@ static int perf_run_latency(struct perf_thread *pthr)
 	void __iomem *flt_dst, *bnd_dst;
 	void *flt_src;
 	u64 stop_at;
+	u32 rem;
 	int ret;
 
 	pthr->tries = 0;
@@ -1146,7 +1147,8 @@ static int perf_run_latency(struct perf_thread *pthr)
 		}
 
 		/* Avoid processor soft lock-ups */
-		if (!(pthr->tries % RESCHEDULE_RATIO))
+		div_u64_rem(pthr->tries, RESCHEDULE_RATIO, &rem);
+		if (!rem)
 			schedule();
 	}
 

base-commit: 0c4b285d9636cc850f55151fa6a250dd131e5192
-- 
2.37.0.rc1

