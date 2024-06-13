Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B388B143C52;
	Thu, 13 Jun 2024 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280535; cv=none; b=C5FLPIzbJx8hWy4Usxb0SfIxpidCNVLkS7fhJTgxiy1XRbL77TP81xSIR+zbw0CRLqvUwhG7zrFsgg4H8UPrV5nbnUQ3XWWuNjLyW1LC3ofuaiL6Q81XVcFUtSSIB6AbITv8GpE0z1gejEtBM6/sQ5iQ6ze1Kobz8XmNT4l/bMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280535; c=relaxed/simple;
	bh=Mke7C7a7uMmWPFtgWo58HXCTQ2l1+Qif5CGvUkD8V9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trhkn7UT2MSsQWzVNYjB2boTNJ3ohMUrud+ZASClNxMYxi6jZJTjbzQFUBUKANFiqdHNdeZ3Ab1+CBusC6u4XECSneTq5rziabv7c0VAzEXEJuPPDVzGmoELM86/QgwC+Yfy5b/PbExHwleOh4dzuzk/oevVVOTxrKPWfA6E9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRvz551h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRvz551h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC0CC2BBFC;
	Thu, 13 Jun 2024 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280535;
	bh=Mke7C7a7uMmWPFtgWo58HXCTQ2l1+Qif5CGvUkD8V9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRvz551hEX5K2y0Pi2W4+xAu3NfD5bLbAaZOxL95I9wS+U8tcToZDxS6iBErfZYx+
	 PZaXsQJUJqZ6B9SCMtA7iybxQqVrNL91FUVN//2RbqhmNmblf8waIokyYaB6zlduGh
	 ay/ygSyTPzoBHXPjZcWBO70v0cySIrfPc6igljAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveria <bristot@kernel.org>,
	John Kacur <jkacur@redhat.com>
Subject: [PATCH 6.6 087/137] rtla/timerlat: Fix histogram report when a cpu count is 0
Date: Thu, 13 Jun 2024 13:34:27 +0200
Message-ID: <20240613113226.672397045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: John Kacur <jkacur@redhat.com>

commit 01b05fc0e5f3aec443a9a8ffa0022cbca2fd3608 upstream.

On short runs it is possible to get no samples on a cpu, like this:

  # rtla timerlat hist -u -T50

  Index   IRQ-001   Thr-001   Usr-001   IRQ-002   Thr-002   Usr-002
  2             1         0         0         0         0         0
  33            0         1         0         0         0         0
  36            0         0         1         0         0         0
  49            0         0         0         1         0         0
  52            0         0         0         0         1         0
  over:         0         0         0         0         0         0
  count:        1         1         1         1         1         0
  min:          2        33        36        49        52 18446744073709551615
  avg:          2        33        36        49        52         -
  max:          2        33        36        49        52         0
  rtla timerlat hit stop tracing
    IRQ handler delay:		(exit from idle)	    48.21 us (91.09 %)
    IRQ latency:						    49.11 us
    Timerlat IRQ duration:				     2.17 us (4.09 %)
    Blocking thread:					     1.01 us (1.90 %)
  	               swapper/2:0        		     1.01 us
  ------------------------------------------------------------------------
    Thread latency:					    52.93 us (100%)

  Max timerlat IRQ latency from idle: 49.11 us in cpu 2

Note, the value 18446744073709551615 is the same as ~0.

Fix this by reporting no results for the min, avg and max if the count
is 0.

Link: https://lkml.kernel.org/r/20240510190318.44295-1-jkacur@redhat.com

Cc: stable@vger.kernel.org
Fixes: 1eeb6328e8b3 ("rtla/timerlat: Add timerlat hist mode")
Suggested-by: Daniel Bristot de Oliveria <bristot@kernel.org>
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/timerlat_hist.c |   68 ++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 22 deletions(-)

--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -323,17 +323,29 @@ timerlat_print_summary(struct timerlat_h
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_irq);
-
-		if (!params->no_thread)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_thread);
-
-		if (params->user_hist)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].min_user);
+		if (!params->no_irq) {
+			if (data->hist[cpu].irq_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_irq);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
+
+		if (!params->no_thread) {
+			if (data->hist[cpu].thread_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_thread);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
+
+		if (params->user_hist) {
+			if (data->hist[cpu].user_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].min_user);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 	}
 	trace_seq_printf(trace->seq, "\n");
 
@@ -383,17 +395,29 @@ timerlat_print_summary(struct timerlat_h
 		if (!data->hist[cpu].irq_count && !data->hist[cpu].thread_count)
 			continue;
 
-		if (!params->no_irq)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_irq);
-
-		if (!params->no_thread)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_thread);
-
-		if (params->user_hist)
-			trace_seq_printf(trace->seq, "%9llu ",
-					data->hist[cpu].max_user);
+		if (!params->no_irq) {
+			if (data->hist[cpu].irq_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						 data->hist[cpu].max_irq);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
+
+		if (!params->no_thread) {
+			if (data->hist[cpu].thread_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].max_thread);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
+
+		if (params->user_hist) {
+			if (data->hist[cpu].user_count)
+				trace_seq_printf(trace->seq, "%9llu ",
+						data->hist[cpu].max_user);
+			else
+				trace_seq_printf(trace->seq, "        - ");
+		}
 	}
 	trace_seq_printf(trace->seq, "\n");
 	trace_seq_do_printf(trace->seq);


