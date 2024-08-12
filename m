Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ADC18455B;
	Mon, 12 Aug 2024 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478875; cv=none; b=QyM74WhBzueOmF/bqHUk1U615ZPgBi8PXG37AOWotC0PIa3gZUaB59ktmYWDUeFutyISRn2rC7SvSIkZW0uTPO/ZohGDmd5wz1Md6lT3JxWT32uvrapks/MZ3frA01EiCnJ2jBYylVNwtrW1e53mkv0NXxkuQj3Z5KQqQ3a1mKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478875; c=relaxed/simple;
	bh=k0Qj48Y43vMGDRuuU7OrBCexUiutfncYMf/mO+7qSLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIuha3whTerk0dtO/KLvci/pbI/c9O95XKLWzb8n1dac2S6txAz1wmCNvtIjYh70jy5jKrq+OjzAna7BqeVNN0kcBzZLeWMz46rtFgknN2lUeMevuPSFgOhStGIm9r01EZ12KsLuqlGeCoucopsfUZFi53tX38FFjwH7cMY+ep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wrcn6ip9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wrcn6ip9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D52C32782;
	Mon, 12 Aug 2024 16:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478875;
	bh=k0Qj48Y43vMGDRuuU7OrBCexUiutfncYMf/mO+7qSLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wrcn6ip91V84idrzlQBV+56rAMufeB3kZ0JuW9OcbQQvnuZb8imuDdpxDO8SZ5SCC
	 0J/+l7OkFadN0Ss+ZbsXA1bY64U1AowB4HPg6/kB7pZGquPAuaZ0vWo3de/o0rmbzA
	 ewO9asUj4yQ9umk0bfmCUJAD8C9B58M4AGs1zwCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zucheng <zhengzucheng@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 056/150] sched/cputime: Fix mul_u64_u64_div_u64() precision for cputime
Date: Mon, 12 Aug 2024 18:02:17 +0200
Message-ID: <20240812160127.335031324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Zucheng <zhengzucheng@huawei.com>

commit 77baa5bafcbe1b2a15ef9c37232c21279c95481c upstream.

In extreme test scenarios:
the 14th field utime in /proc/xx/stat is greater than sum_exec_runtime,
utime = 18446744073709518790 ns, rtime = 135989749728000 ns

In cputime_adjust() process, stime is greater than rtime due to
mul_u64_u64_div_u64() precision problem.
before call mul_u64_u64_div_u64(),
stime = 175136586720000, rtime = 135989749728000, utime = 1416780000.
after call mul_u64_u64_div_u64(),
stime = 135989949653530

unsigned reversion occurs because rtime is less than stime.
utime = rtime - stime = 135989749728000 - 135989949653530
		      = -199925530
		      = (u64)18446744073709518790

Trigger condition:
  1). User task run in kernel mode most of time
  2). ARM64 architecture
  3). TICK_CPU_ACCOUNTING=y
      CONFIG_VIRT_CPU_ACCOUNTING_NATIVE is not set

Fix mul_u64_u64_div_u64() conversion precision by reset stime to rtime

Fixes: 3dc167ba5729 ("sched/cputime: Improve cputime_adjust()")
Signed-off-by: Zheng Zucheng <zhengzucheng@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20240726023235.217771-1-zhengzucheng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cputime.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -591,6 +591,12 @@ void cputime_adjust(struct task_cputime
 	}
 
 	stime = mul_u64_u64_div_u64(stime, rtime, stime + utime);
+	/*
+	 * Because mul_u64_u64_div_u64() can approximate on some
+	 * achitectures; enforce the constraint that: a*b/(b+c) <= a.
+	 */
+	if (unlikely(stime > rtime))
+		stime = rtime;
 
 update:
 	/*


