Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1709E1095F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E646C433C0;
	Mon, 19 Jun 2023 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170851;
	bh=ap3jkD9bWHq32RU4HgblFqK2uQUDLFh8qSg39w0GXXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3HHivDw+l3iCzQUAxlTvAImOjgPdVAa5DBusyiI9sXkdF1nO/AdaE1mZ/LTTAttV
	 apYLTcfP7OOAdSSqxbWVMqSkZ5HOKt6ZRHBw6Gyo0Nqi50s8O9I3wWi+gEtJ7B387s
	 cxwCAlDL4QAeOouAzyFQ97C+uEVgyZ53TyxtPCTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yi <yijun@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.3 058/187] LoongArch: Fix perf event id calculation
Date: Mon, 19 Jun 2023 12:27:56 +0200
Message-ID: <20230619102200.484482821@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit 962369120d750cbc9c4dc492f32b4304669ff6aa upstream.

LoongArch PMCFG has 10bit event id rather than 8 bit, so fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Jun Yi <yijun@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/perf_event.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kernel/perf_event.c
+++ b/arch/loongarch/kernel/perf_event.c
@@ -271,7 +271,7 @@ static void loongarch_pmu_enable_event(s
 	WARN_ON(idx < 0 || idx >= loongarch_pmu.num_counters);
 
 	/* Make sure interrupt enabled. */
-	cpuc->saved_ctrl[idx] = M_PERFCTL_EVENT(evt->event_base & 0xff) |
+	cpuc->saved_ctrl[idx] = M_PERFCTL_EVENT(evt->event_base) |
 		(evt->config_base & M_PERFCTL_CONFIG_MASK) | CSR_PERFCTRL_IE;
 
 	cpu = (event->cpu >= 0) ? event->cpu : smp_processor_id();
@@ -594,7 +594,7 @@ static struct pmu pmu = {
 
 static unsigned int loongarch_pmu_perf_event_encode(const struct loongarch_perf_event *pev)
 {
-	return (pev->event_id & 0xff);
+	return M_PERFCTL_EVENT(pev->event_id);
 }
 
 static const struct loongarch_perf_event *loongarch_pmu_map_general_event(int idx)
@@ -849,7 +849,7 @@ static void resume_local_counters(void)
 
 static const struct loongarch_perf_event *loongarch_pmu_map_raw_event(u64 config)
 {
-	raw_event.event_id = config & 0xff;
+	raw_event.event_id = M_PERFCTL_EVENT(config);
 
 	return &raw_event;
 }


