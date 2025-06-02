Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7E02C324D;
	Mon,  2 Jun 2025 14:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873921; cv=none; b=dnLckJQ3Ungp5ph5UrIhF612G0CotxbZEzrKPm6e0pVM055SvKXJkRmAQPS2EY6Qze1IHmL8G6lAo2xcF3iy3jCqyTWxaVQ5UxisTBOup5c94Jmla6oRDho+E6x5bB9yIlWsnVuy+HKM6yiYoajGsDqcsAfonoG+bMXVqjNAWsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873921; c=relaxed/simple;
	bh=bAJUL/piny45Zhirga8VUavEnS0+YiGz7fERk4Bp4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFMzjDWt+Od+aoXHqWx2YsxXLYqrW5H2FUcIsSnAnXTjpT48Sec/FN8rxCTYge0y7ftQOQdw66OgxNvoyeKiPZ50dFUqDYPybCZUvUzcZ4cxr86/eyf3WpPS9VMVW7zX+yE0AbhcPZyK/QV+Utx4/C9v298mEJaLLntAZhcwgmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXWTwReD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXWTwReD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF55C4CEEB;
	Mon,  2 Jun 2025 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873921;
	bh=bAJUL/piny45Zhirga8VUavEnS0+YiGz7fERk4Bp4cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXWTwReDfNi9oaA1gbQrJBJI9amrZMyQ2zJLybQfxotImCJiauR1D7qAsDRO+Daxu
	 fFF8ERgtUyz99lKO+7dgYuIUwrAonwWkBYofc+UNAhLggmQhYxjlQracmw7dXLkZsd
	 wJ8pTFTGFWRBYJhjq6o6PtLw1xiVDYNMu67VJE+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/444] perf/amd/ibs: Fix perf_ibs_op.cnt_mask for CurCnt
Date: Mon,  2 Jun 2025 15:46:01 +0200
Message-ID: <20250602134353.005013361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit 46dcf85566170d4528b842bf83ffc350d71771fa ]

IBS Op uses two counters: MaxCnt and CurCnt. MaxCnt is programmed with
the desired sample period. IBS hw generates sample when CurCnt reaches
to MaxCnt. The size of these counter used to be 20 bits but later they
were extended to 27 bits. The 7 bit extension is indicated by CPUID
Fn8000_001B_EAX[6 / OpCntExt].

perf_ibs->cnt_mask variable contains bit masks for MaxCnt and CurCnt.
But IBS driver does not set upper 7 bits of CurCnt in cnt_mask even
when OpCntExt CPUID bit is set. Fix this.

IBS driver uses cnt_mask[CurCnt] bits only while disabling an event.
Fortunately, CurCnt bits are not read from MSR while re-enabling the
event, instead MaxCnt is programmed with desired period and CurCnt is
set to 0. Hence, we did not see any issues so far.

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/r/20250115054438.1021-5-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c         | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index f483874fa20f1..85731f121feb5 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1219,7 +1219,8 @@ static __init int perf_ibs_op_init(void)
 	if (ibs_caps & IBS_CAPS_OPCNTEXT) {
 		perf_ibs_op.max_period  |= IBS_OP_MAX_CNT_EXT_MASK;
 		perf_ibs_op.config_mask	|= IBS_OP_MAX_CNT_EXT_MASK;
-		perf_ibs_op.cnt_mask    |= IBS_OP_MAX_CNT_EXT_MASK;
+		perf_ibs_op.cnt_mask    |= (IBS_OP_MAX_CNT_EXT_MASK |
+					    IBS_OP_CUR_CNT_EXT_MASK);
 	}
 
 	if (ibs_caps & IBS_CAPS_ZEN4)
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 384e8a7db4827..ba2a3935dc624 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -501,6 +501,7 @@ struct pebs_xmm {
  */
 #define IBS_OP_CUR_CNT		(0xFFF80ULL<<32)
 #define IBS_OP_CUR_CNT_RAND	(0x0007FULL<<32)
+#define IBS_OP_CUR_CNT_EXT_MASK	(0x7FULL<<52)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
 #define IBS_OP_VAL		(1ULL<<18)
 #define IBS_OP_ENABLE		(1ULL<<17)
-- 
2.39.5



