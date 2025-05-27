Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51225C6EC;
	Tue, 27 May 2025 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368092; cv=none; b=dsxWMwSMPyQFHGQigv48p9KG0VkrH4bQNq67KP0qYGwGVfFnGkfeYPhrO7LJi1aTbQ5E/X61juF8fOEG72Jt0HM7MUxBVqcfh0t/M/7lUf7i+yh0GsQLMQtnXwC5xxGxqDZwtUvAZxDH5ln6ieVz826OtciYa9m3bMoyJKP3pBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368092; c=relaxed/simple;
	bh=itM712wFHWms3F4ZixJOZHHyYZmlbXnK0b57Gj+UJ8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0n6of2j1fEERMeNnp2RNP2rGSyRpTAw600s/1ekbSbCumTfc7NftiFTm6o9VA0M1fQwj378osTjz3XNHayESLyn4xiVsIeL9E8bWugAOW0yq8gJxur+O5QP/4iGnLRyZt5/jkX3a3hrkNh0p67iZYK2YttqmfODsJ+iDX1G0fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMQsv0hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMQsv0hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFAEC4CEE9;
	Tue, 27 May 2025 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368091;
	bh=itM712wFHWms3F4ZixJOZHHyYZmlbXnK0b57Gj+UJ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMQsv0hskBncVGjPol5AMpj2Z3ldAUIqmKW5GLKM2oXCVHeVoMH7UaoMRttJquMev
	 51IGO1owPBmEVObXhBjEUVmrB1IQ4yWhxUSQiFkV6Dvq6Hn3kTWvd0/wT4Txt/sF9G
	 GRZctNl25ovaIlPNgYX6wZ1A9QTbRCuwAsfT4TLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 595/783] perf/amd/ibs: Fix perf_ibs_op.cnt_mask for CurCnt
Date: Tue, 27 May 2025 18:26:32 +0200
Message-ID: <20250527162537.361632040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e36c9c63c97cc..5d975c39701cb 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1318,7 +1318,8 @@ static __init int perf_ibs_op_init(void)
 	if (ibs_caps & IBS_CAPS_OPCNTEXT) {
 		perf_ibs_op.max_period  |= IBS_OP_MAX_CNT_EXT_MASK;
 		perf_ibs_op.config_mask	|= IBS_OP_MAX_CNT_EXT_MASK;
-		perf_ibs_op.cnt_mask    |= IBS_OP_MAX_CNT_EXT_MASK;
+		perf_ibs_op.cnt_mask    |= (IBS_OP_MAX_CNT_EXT_MASK |
+					    IBS_OP_CUR_CNT_EXT_MASK);
 	}
 
 	if (ibs_caps & IBS_CAPS_ZEN4)
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 0ba8d20f2d1d5..d37c1c32e74b9 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -536,6 +536,7 @@ struct pebs_xmm {
  */
 #define IBS_OP_CUR_CNT		(0xFFF80ULL<<32)
 #define IBS_OP_CUR_CNT_RAND	(0x0007FULL<<32)
+#define IBS_OP_CUR_CNT_EXT_MASK	(0x7FULL<<52)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
 #define IBS_OP_VAL		(1ULL<<18)
 #define IBS_OP_ENABLE		(1ULL<<17)
-- 
2.39.5



