Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E999F212B0A;
	Thu, 12 Dec 2024 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018351; cv=none; b=GOHr9i8a8BikVlJg3P7fO7wnIdQ0UizVYvrIGsYHhoYJPAgcl8Ds5+TO0L4Q+k3NidPE+iMwajm8tmFdmuMCZpTbdCKWhvgK6nRjDXUNoxqpN09NXotdTMyD4kJ5i3wgE/P2Sqtfm/uQKXNBpwp/svuQ15eN+O7d59nQ7gZfvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018351; c=relaxed/simple;
	bh=MqiQDKvbDBNyxkY0yoScSiHNjQKdjasTe/0RhiX6yTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFS3Z68IismjKKuAzZ/mcyVJTYnAboSvsHrXFJqIVzPNYuHnLXMX+wb7DWZZ19Wsw8byOCIKJJEXCbZWWuXMpmp6jma8e7vX0Ighl2ZAW4GyHxpXykJ8tw2icb2LMJIzuPtunRLIs9Nw5Al2wEz1Hba5lSbW/6EO9nP9bKP7AZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUVkrHcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUVkrHcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64DDC4CECE;
	Thu, 12 Dec 2024 15:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018350;
	bh=MqiQDKvbDBNyxkY0yoScSiHNjQKdjasTe/0RhiX6yTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUVkrHcpzdfhZtXpbLi4a7jcDDfDloR1MM1dG2bbiLL75l9wA958UzXOYnQvnhajL
	 A9TIx9YGjRtsPibg/y1yu12KcfvzPbisqZZX9pZ5+8Ug7p7W4FHxoSh2ofcKsnnjMZ
	 3t+h+1WJzPu9hMOsrk23kY7olrm01LH0wUNYOJIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Attila Fazekas <afazekas@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/356] rtla/timerlat: Make timerlat_top_cpu->*_count unsigned long long
Date: Thu, 12 Dec 2024 15:59:48 +0100
Message-ID: <20241212144255.218103889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a84f43857de14..0915092057f85 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -49,9 +49,9 @@ struct timerlat_top_params {
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
@@ -237,7 +237,7 @@ static void timerlat_top_print(struct osnoise_tool *top, int cpu)
 	/*
 	 * Unless trace is being lost, IRQ counter is always the max.
 	 */
-	trace_seq_printf(s, "%3d #%-9d |", cpu, cpu_data->irq_count);
+	trace_seq_printf(s, "%3d #%-9llu |", cpu, cpu_data->irq_count);
 
 	if (!cpu_data->irq_count) {
 		trace_seq_printf(s, "%s %s %s %s |", no_value, no_value, no_value, no_value);
-- 
2.43.0



