Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5C32054F8;
	Thu, 12 Dec 2024 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017115; cv=none; b=I2RZuh3IUy6/2EWezj7cfSrbuSphRY+UJfSBozmt7T3Ek2oby/A7Wmd9gcTs60j0HzwHwOOYvh5Vc5lkFw86q05TwvtjKXY8OdDDmZHboB/ucy/V0TbhHLoWBOaShJDFmBFU3Y0ZkUGkAFgOh+0igXkPj247DNyx0NZDwW5LVN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017115; c=relaxed/simple;
	bh=N+pBipm4iyv/dqASkPIEU5gLolWXpPBR+dTq3vmZyaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+GH34wVLlzNYR8t6D/cUPpMCb1pfYavTKAs64rSXStwODWdsfQ2bctOhttMqwYMAo7IwHUgURwq3TDB1WN6tZEMaeuGIfUjO0ilaFd2ai0Vx+Cv7EsWRzk1BUVnuRjdg+OdgsbIv2vzrpedsBkj0EMaF81WWxzeo743MFy2ab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjFxMhqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjFxMhqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715A2C4CECE;
	Thu, 12 Dec 2024 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017113;
	bh=N+pBipm4iyv/dqASkPIEU5gLolWXpPBR+dTq3vmZyaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjFxMhqBs1NAg8G03+IQVA3U06jxUxtEgVm7ffbr6kOMiE5sDAn7bcgcvA26DGEtW
	 rSEHbT+yVcD6baEWV7rbGzXCl8kvfMXBMkbRK8024Us0lWlVDkusJCKc1mqhurGYEq
	 XY406LdStH7KQ1HSnnbzlQektxS2ShszrhshyZ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Attila Fazekas <afazekas@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/466] rtla/timerlat: Make timerlat_top_cpu->*_count unsigned long long
Date: Thu, 12 Dec 2024 15:58:48 +0100
Message-ID: <20241212144320.965549223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 4eba4723c5254ba8251ecb7094a5078d5c300646 ]

Most fields of struct timerlat_top_cpu are unsigned long long, but the
fields {irq,thread,user}_count are int (32-bit signed).

This leads to overflow when tracing on a large number of CPUs for a long
enough time:
$ rtla timerlat top -a20 -c 1-127 -d 12h
...
  0 12:00:00   |          IRQ Timer Latency (us)        |         Thread Timer Latency (us)
CPU COUNT      |      cur       min       avg       max |      cur       min       avg       max
 1 #43200096  |        0         0         1         2 |        3         2         6        12
...
127 #43200096  |        0         0         1         2 |        3         2         5        11
ALL #119144 e4 |                  0         5         4 |                  2        28        16

The average latency should be 0-1 for IRQ and 5-6 for thread, but is
reported as 5 and 28, about 4 to 5 times more, due to the count
overflowing when summed over all CPUs: 43200096 * 127 = 5486412192,
however, 1191444898 (= 5486412192 mod MAX_INT) is reported instead, as
seen on the last line of the output, and the averages are thus ~4.6
times higher than they should be (5486412192 / 1191444898 = ~4.6).

Fix the issue by changing {irq,thread,user}_count fields to unsigned
long long, similarly to other fields in struct timerlat_top_cpu and to
the count variable in timerlat_top_print_sum.

Link: https://lore.kernel.org/20241011121015.2868751-1-tglozar@redhat.com
Reported-by: Attila Fazekas <afazekas@redhat.com>
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_top.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 3b62519a412fc..ac2ff38a57ee5 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -54,9 +54,9 @@ struct timerlat_top_params {
 };
 
 struct timerlat_top_cpu {
-	int			irq_count;
-	int			thread_count;
-	int			user_count;
+	unsigned long long	irq_count;
+	unsigned long long	thread_count;
+	unsigned long long	user_count;
 
 	unsigned long long	cur_irq;
 	unsigned long long	min_irq;
@@ -280,7 +280,7 @@ static void timerlat_top_print(struct osnoise_tool *top, int cpu)
 	/*
 	 * Unless trace is being lost, IRQ counter is always the max.
 	 */
-	trace_seq_printf(s, "%3d #%-9d |", cpu, cpu_data->irq_count);
+	trace_seq_printf(s, "%3d #%-9llu |", cpu, cpu_data->irq_count);
 
 	if (!cpu_data->irq_count) {
 		trace_seq_printf(s, "%s %s %s %s |", no_value, no_value, no_value, no_value);
-- 
2.43.0



