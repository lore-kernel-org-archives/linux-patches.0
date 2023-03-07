Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BFBBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D184C433EF;
	Tue,  7 Mar 2023 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212176;
	bh=rAbAtauK0hmbO+K/zGADhjS5szni4drmaDh+sO7qiO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKM2kvXuwBCMPlb2uOm7bWppGOrYjURYWdN239u11Kvag5iG+3jmWHucziSGC3ATw
	 zmZf/gz3arLIJh+2BW1PH5AcGY1aGUik91sdgFV8w538DDY6+yXciEyeFPX/zMkjh9
	 6v5Fu+D/eI54UcvHKpz4yl6IN9w5jnZwQHDMDOss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arjan <8vvbbqzo567a@nospam.xutrox.com>,
	Kevin Brace <kevinbrace@gmx.com>,
	silviazhao <silviazhao-oc@zhaoxin.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/885] x86/perf/zhaoxin: Add stepping check for ZXC
Date: Tue,  7 Mar 2023 17:50:35 +0100
Message-Id: <20230307170006.243575760@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: silviazhao <silviazhao-oc@zhaoxin.com>

[ Upstream commit fd636b6a9bc6034f2e5bb869658898a2b472c037 ]

Some of Nano series processors will lead GP when accessing
PMC fixed counter. Meanwhile, their hardware support for PMC
has not announced externally. So exclude Nano CPUs from ZXC
by checking stepping information. This is an unambiguous way
to differentiate between ZXC and Nano CPUs.

Following are Nano and ZXC FMS information:
Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
ZXC FMS:  Family=6, Model=F, Stepping=E-F OR
          Family=6, Model=0x19, Stepping=0-3

Fixes: 3a4ac121c2ca ("x86/perf: Add hardware performance events support for Zhaoxin CPU.")

Reported-by: Arjan <8vvbbqzo567a@nospam.xutrox.com>
Reported-by: Kevin Brace <kevinbrace@gmx.com>
Signed-off-by: silviazhao <silviazhao-oc@zhaoxin.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212389
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/zhaoxin/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 949d845c922b4..3e9acdaeed1ec 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -541,7 +541,13 @@ __init int zhaoxin_pmu_init(void)
 
 	switch (boot_cpu_data.x86) {
 	case 0x06:
-		if (boot_cpu_data.x86_model == 0x0f || boot_cpu_data.x86_model == 0x19) {
+		/*
+		 * Support Zhaoxin CPU from ZXC series, exclude Nano series through FMS.
+		 * Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
+		 * ZXC FMS: Family=6, Model=F, Stepping=E-F OR Family=6, Model=0x19, Stepping=0-3
+		 */
+		if ((boot_cpu_data.x86_model == 0x0f && boot_cpu_data.x86_stepping >= 0x0e) ||
+			boot_cpu_data.x86_model == 0x19) {
 
 			x86_pmu.max_period = x86_pmu.cntval_mask >> 1;
 
-- 
2.39.2



