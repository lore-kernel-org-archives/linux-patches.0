Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A6C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F98C433D2;
	Mon,  8 May 2023 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544943;
	bh=OJiXpfaE/bCVzy/stUX5mJG47hKMj0wAjSzLVzXwqvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0xbYvuF18gp0ZfmfNE75ldY9U2y/XEU3l4wIMqeDMSmBYAdytlOgAbdcpVVV8ITo
	 coPBwyJPl5sBbDwMZVvOfLUiMtQFZ9dOA//HgolbFD1FWDRuWYRUr49d4bb88dwB+/
	 8tK6NgnKahm7IGFdKQDi6HHBFH30BqNFTAEDTGlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 572/694] rtla/timerlat: Fix "Previous IRQ" auto analysis line
Date: Mon,  8 May 2023 11:46:47 +0200
Message-Id: <20230508094453.423906128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 82253a271aae9271fcf0aaa5e0ecc6dd38fb872b ]

The "Previous IRQ interference" line is misaligned and without
a \n, breaking the tool's output:

 ## CPU 12 hit stop tracing, analyzing it ##
  Previous IRQ interference:			up to      2.22 us  IRQ handler delay:		                	    18.06 us (0.00 %)
  IRQ latency:						    18.52 us
  Timerlat IRQ duration:				     4.41 us (0.00 %)
  Blocking thread:					   216.93 us (0.03 %)

Fix the output:

 ## CPU 7 hit stop tracing, analyzing it ##
  Previous IRQ interference:			 up to       8.93 us
  IRQ handler delay:		                	     0.98 us (0.00 %)
  IRQ latency:						     2.95 us
  Timerlat IRQ duration:				    11.26 us (0.03 %)

Link: https://lore.kernel.org/linux-trace-devel/8b5819077f15ccf24745c9bf3205451e16ee32d9.1679685525.git.bristot@kernel.org

Fixes: 27e348b221f6 ("rtla/timerlat: Add auto-analysis core")
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_aa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/timerlat_aa.c b/tools/tracing/rtla/src/timerlat_aa.c
index ec4e0f4b0e6cd..1843fff66da5b 100644
--- a/tools/tracing/rtla/src/timerlat_aa.c
+++ b/tools/tracing/rtla/src/timerlat_aa.c
@@ -548,7 +548,7 @@ static void timerlat_thread_analysis(struct timerlat_aa_data *taa_data, int cpu,
 	exp_irq_ts = taa_data->timer_irq_start_time - taa_data->timer_irq_start_delay;
 
 	if (exp_irq_ts < taa_data->prev_irq_timstamp + taa_data->prev_irq_duration)
-		printf("  Previous IRQ interference:	\t	up to %9.2f us",
+		printf("  Previous IRQ interference:	\t\t up to  %9.2f us\n",
 			ns_to_usf(taa_data->prev_irq_duration));
 
 	/*
-- 
2.39.2



