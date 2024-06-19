Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89274D9EA;
	Wed, 19 Jun 2024 13:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803397; cv=none; b=PIXZo2jrDCLJSM6r81iefKMNnFjwlsPW1rfSguxvnW7pJbjnHTyETE3NhIhsjIbGvpNoeLT69PxDhpyR5FkC3AbuSR8n67b6fiL/2NJMV2hy/cv5DCj4mT5fLP5Idy4G5BVIaFhICKDW7WvWp8g0/vGDzdSWnE530ay+y35JYlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803397; c=relaxed/simple;
	bh=bqyhkVxcf+J8JxCLepZtJohsDite4ftatIkILGp69i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tekYAupzTHY6Khh3AQLYmTGTtGgrmM7OnnHC5wYCQzAPG7Vsz3gIOBH5ML6hXGP0mBQ/Ke/d6mDu4zLwegqb3ZTzbmjtm2vhcCV0KyhOk7c9XVaedZhDuBPOmaj6TytwncznACqn61mCYWMelUYpbCm4sFo2t2/3+gF7eYESawg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdtZ19pB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdtZ19pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E3FC2BBFC;
	Wed, 19 Jun 2024 13:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803397;
	bh=bqyhkVxcf+J8JxCLepZtJohsDite4ftatIkILGp69i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdtZ19pB6b5YBY+lQ6dj+HUOSTP9rucPg0JFPrZHJa0+oL3pAY/vyzePfezlHh8c8
	 hCeriU6Y78JFzeaNUpY22Q4vuHG6eNzSiqambJE86l5EqLmn0TGGOK6UrMNluaBgbz
	 xvUznaTNpqDkjMvuC6WU/oghtaSIobvhdba5+hzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.9 254/281] rtla/timerlat: Simplify "no value" printing on top
Date: Wed, 19 Jun 2024 14:56:53 +0200
Message-ID: <20240619125619.752100656@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit 5f0769331a965675cdfec97c09f3f6e875d7c246 upstream.

Instead of printing three times the same output, print it only once,
reducing lines and being sure that all no values have the same length.

It also fixes an extra '\n' when running the with kernel threads, like
here:

     =============== %< ==============
                                      Timer Latency

   0 00:00:01   |          IRQ Timer Latency (us)        |         Thread Timer Latency (us)
 CPU COUNT      |      cur       min       avg       max |      cur       min       avg       max
   2 #0         |        -         -         -         - |      161       161       161       161
   3 #0         |        -         -         -         - |      161       161       161       161
   8 #1         |       54        54        54        54 |        -         -         -         -'\n'

 ---------------|----------------------------------------|---------------------------------------
 ALL #1      e0 |                 54        54        54 |                161       161       161
     =============== %< ==============

This '\n' should have been removed with the user-space support that
added another '\n' if not running with kernel threads.

Link: https://lkml.kernel.org/r/0a4d8085e7cd706733a5dc10a81ca38b82bd4992.1713968967.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Juri Lelli <juri.lelli@redhat.com>
Fixes: cdca4f4e5e8e ("rtla/timerlat_top: Add timerlat user-space support")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_top.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -212,6 +212,8 @@ static void timerlat_top_header(struct o
 	trace_seq_printf(s, "\n");
 }
 
+static const char *no_value = "        -";
+
 /*
  * timerlat_top_print - prints the output of a given CPU
  */
@@ -239,10 +241,7 @@ static void timerlat_top_print(struct os
 	trace_seq_printf(s, "%3d #%-9d |", cpu, cpu_data->irq_count);
 
 	if (!cpu_data->irq_count) {
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - |");
+		trace_seq_printf(s, "%s %s %s %s |", no_value, no_value, no_value, no_value);
 	} else {
 		trace_seq_printf(s, "%9llu ", cpu_data->cur_irq / params->output_divisor);
 		trace_seq_printf(s, "%9llu ", cpu_data->min_irq / params->output_divisor);
@@ -251,10 +250,7 @@ static void timerlat_top_print(struct os
 	}
 
 	if (!cpu_data->thread_count) {
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        -\n");
+		trace_seq_printf(s, "%s %s %s %s", no_value, no_value, no_value, no_value);
 	} else {
 		trace_seq_printf(s, "%9llu ", cpu_data->cur_thread / divisor);
 		trace_seq_printf(s, "%9llu ", cpu_data->min_thread / divisor);
@@ -271,10 +267,7 @@ static void timerlat_top_print(struct os
 	trace_seq_printf(s, " |");
 
 	if (!cpu_data->user_count) {
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        - ");
-		trace_seq_printf(s, "        -\n");
+		trace_seq_printf(s, "%s %s %s %s\n", no_value, no_value, no_value, no_value);
 	} else {
 		trace_seq_printf(s, "%9llu ", cpu_data->cur_user / divisor);
 		trace_seq_printf(s, "%9llu ", cpu_data->min_user / divisor);


