Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A97BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF52FC433D2;
	Tue,  7 Mar 2023 17:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210291;
	bh=LEy2NUR4IdIAeTTVC+T0c/xKK8EYO/cdcUB77P4ccG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTWLuva1aC9qHALl6fgHtKtRHTtHFYqMSsL3/sv2R4wFfDV+A0SqlDqDsi+0xAltJ
	 wjLhya0blTc6F6XWjSHjivYlEl8qW2SRwHG9rY7Jt7f+RNdJBcl9KW3937iFsLFBHQ
	 VuScbXTk5lwz8HvvMiayw2uA/d2sHfX69+tXengY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Ziegler <br015@umbiko.net>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0465/1001] tools/tracing/rtla: osnoise_hist: use total duration for average calculation
Date: Tue,  7 Mar 2023 17:53:57 +0100
Message-Id: <20230307170041.578175560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Ziegler <br015@umbiko.net>

[ Upstream commit fe137a4fe0e77eb95396cfc5c3dd7df404421aa4 ]

Sampled durations must be weighted by observed quantity, to arrive at a correct
average duration value.

Perform calculation of total duration by summing (duration * count).

Link: https://lkml.kernel.org/r/20230103103400.275566-2-br015@umbiko.net

Fixes: 829a6c0b5698 ("rtla/osnoise: Add the hist mode")

Signed-off-by: Andreas Ziegler <br015@umbiko.net>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/osnoise_hist.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 5d7ea479ac89f..fe34452fc4ec0 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -121,6 +121,7 @@ static void osnoise_hist_update_multiple(struct osnoise_tool *tool, int cpu,
 {
 	struct osnoise_hist_params *params = tool->params;
 	struct osnoise_hist_data *data = tool->data;
+	unsigned long long total_duration;
 	int entries = data->entries;
 	int bucket;
 	int *hist;
@@ -131,10 +132,12 @@ static void osnoise_hist_update_multiple(struct osnoise_tool *tool, int cpu,
 	if (data->bucket_size)
 		bucket = duration / data->bucket_size;
 
+	total_duration = duration * count;
+
 	hist = data->hist[cpu].samples;
 	data->hist[cpu].count += count;
 	update_min(&data->hist[cpu].min_sample, &duration);
-	update_sum(&data->hist[cpu].sum_sample, &duration);
+	update_sum(&data->hist[cpu].sum_sample, &total_duration);
 	update_max(&data->hist[cpu].max_sample, &duration);
 
 	if (bucket < entries)
-- 
2.39.2



