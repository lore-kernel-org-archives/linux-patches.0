Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED6248BCB;
	Wed, 15 Jan 2025 10:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938106; cv=none; b=Msp32C4Bn8Lgr1j2gTvEU0JJdiR6xv5mn02Nz0TQ5N7jwRzuJ6/ud07BUUK9/+FqLINaCjoZpF5Wu/9x31+kCANsBRgALacQZ6wPBCTqiSHuyYnslLj5bwZ3iBiXFQSN0wqsB6kC2FTAvujnnmygpzoMbbt0aagVN5mfVSTGYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938106; c=relaxed/simple;
	bh=17kX/6zlvNpM/Voa/QGBHvTcR/C8+882C9Gkn/AMQJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi/MzX1eaU+EQf7uyQjtwehw6YBUFktYNgdRNdEBPWv2Dfg47+c4N1JkxUgmJPKshnUWvQraAbWIoCkuCsof4Zfkcn/ft8sN6AYdIvz7fjDQTX9N7DdCD0Uil/Dn26Ptk/LrsQ4MUezNc41tKWZBgKGgV4hLsmNxw+lKM6sVYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjdFLh5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjdFLh5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C51FC4CEDF;
	Wed, 15 Jan 2025 10:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938106;
	bh=17kX/6zlvNpM/Voa/QGBHvTcR/C8+882C9Gkn/AMQJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjdFLh5kV04A/rZDUzHWxDj7NBB3SPv7W40Hdhu5XbXdpxYeu8p8+RcuNTDvlwbNJ
	 HTz+WYdy8jUqKgoCAXwykYVuHk20+re7041/1GfpOEq/cpYORG5D3h5ObEYAWbpj5C
	 xGrtOxm6wg54qZ/wnREsbucyLmQzbFyc6wS1qnRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/189] drivers/perf: riscv: Return error for default case
Date: Wed, 15 Jan 2025 11:36:20 +0100
Message-ID: <20250115103609.692850467@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit 2c206cdede567f53035c622e846678a996f39d69 ]

If the upper two bits has an invalid valid (0x1), the event mapping
is not reliable as it returns an uninitialized variable.

Return appropriate value for the default case.

Fixes: f0c9363db2dd ("perf/riscv-sbi: Add platform specific firmware event handling")

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20241212-pmu_event_fixes_v2-v2-2-813e8a4f5962@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 3473ba02abf3..da3651d32906 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -507,7 +507,7 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 {
 	u32 type = event->attr.type;
 	u64 config = event->attr.config;
-	int ret;
+	int ret = -ENOENT;
 
 	/*
 	 * Ensure we are finished checking standard hardware events for
@@ -551,10 +551,11 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 			ret = SBI_PMU_EVENT_TYPE_FW << 16 | RISCV_PLAT_FW_EVENT;
 			*econfig = config & RISCV_PMU_PLAT_FW_EVENT_MASK;
 			break;
+		default:
+			break;
 		}
 		break;
 	default:
-		ret = -ENOENT;
 		break;
 	}
 
-- 
2.39.5



