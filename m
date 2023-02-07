Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7053212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FEC433EF;
	Tue,  7 Feb 2023 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774974;
	bh=RQvz+kH4LSpL35lxAqi+Bd7/BNj1sjnMI557/UDZ4Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHTIpK5dpCaZ3rjocGMD8MxmHCeK1z2wFS8oelN5IvS5QuaLIpbyXz7KEF78cdAd3
	 ArQh2lisRi0H+8D7ibiPK/waWysbvw1Z19WhMp09NnhA9Uvkydq3UQnIVk0o8u1+zE
	 TeGipCBHnbkliySvN9aGcnPmjxi319rfzrHCTkao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yair Podemsky <ypodemsk@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/208] x86/aperfmperf: Erase stale arch_freq_scale values when disabling frequency invariance readings
Date: Tue,  7 Feb 2023 13:55:50 +0100
Message-Id: <20230207125638.726535914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yair Podemsky <ypodemsk@redhat.com>

[ Upstream commit 5f5cc9ed992cbab6361f198966f0edba5fc52688 ]

Once disable_freq_invariance_work is called the scale_freq_tick function
will not compute or update the arch_freq_scale values.
However the scheduler will still read these values and use them.
The result is that the scheduler might perform unfair decisions based on stale
values.

This patch adds the step of setting the arch_freq_scale values for all
cpus to the default (max) value SCHED_CAPACITY_SCALE, Once all cpus
have the same arch_freq_scale value the scaling is meaningless.

Signed-off-by: Yair Podemsky <ypodemsk@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230110160206.75912-1-ypodemsk@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/aperfmperf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 1f60a2b27936..fdbb5f07448f 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -330,7 +330,16 @@ static void __init bp_init_freq_invariance(void)
 
 static void disable_freq_invariance_workfn(struct work_struct *work)
 {
+	int cpu;
+
 	static_branch_disable(&arch_scale_freq_key);
+
+	/*
+	 * Set arch_freq_scale to a default value on all cpus
+	 * This negates the effect of scaling
+	 */
+	for_each_possible_cpu(cpu)
+		per_cpu(arch_freq_scale, cpu) = SCHED_CAPACITY_SCALE;
 }
 
 static DECLARE_WORK(disable_freq_invariance_work,
-- 
2.39.0



