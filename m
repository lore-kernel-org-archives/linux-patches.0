Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC771343893;
	Sat, 12 Sep 2026 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214780; cv=none; b=YEx2AhX2HD0P0bOlPzPdXCGpfyl8hWgnFbjaVT7W8RGXiu7rm8LuP6luR358vS+x922r7X8DFo/tmKyUMtfNeu4ec2yFEJ34ukc66zDAWr/8Us5+h0iwauq++Su9pgawDfvQ5g8o+xP4rcj6uKE2NioABZaKvEPRjLoOwHHo4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214780; c=relaxed/simple;
	bh=emEWN2r7ikOBdyf3POrT5y9i5j3fzJYmY7we0E0Q0nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOZrCIQV7i+GxDtPS9rRpXT6D2mk/g0hpTYz54G8nznmmRa1dv80gH0i/czZ6dGVwitwxzZtN9Q0powEb82klaFntkXeeDJOv+pYQn0jJzrBPBvldw91BDtPusIk9vnVETLC9HejtYo6dtM3qriEcwYQSztZfbCg0ClaOO3uJs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC5tlkQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC5tlkQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA161F000FF;
	Sat, 12 Sep 2026 12:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214779;
	bh=wK8QnbBgj7eF+ByfF4wlstNMSbYZ1DcIFOprtHMU+Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC5tlkQ6LgTnVqUpk5iDpr5ZrSHZmJ0A1LDJ/6k4E+S+jFdcip4y2gpNrQWP7IYMM
	 J/rfgKy4vK25Xup9sf/O/tAeL4k4EvlF2Kc1r0bq08mj8tN64bpPvQs4yrYl/aF+Bn
	 WwIT2aM73QwQNDiEsVGSeeeyURm0z2kZo23R/0k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0396/1376] perf cs-etm: Fix thread leaks on trace queue init failure
Date: Sat, 12 Sep 2026 08:47:02 +0200
Message-ID: <20260912065616.371367781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 50cd0d54f1f6dd9b3de7c0ad101bd41d06206ace ]

cs_etm__init_traceid_queue() allocates the frontend and decode threads,
if a later allocation fails, the error path does not drop thread
reference that was already acquired.

Release both thread pointers with thread__zput() on the error path, so
does not leak thread references or leave stale pointers behind.

Fixes: 951ccccdc715 ("perf cs-etm: Only track threads instead of PID and TIDs")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 9e3a4a676535a..29f0211324970 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -620,6 +620,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 					       queue->tid);
 	tidq->decode_thread = machine__findnew_thread(&etm->session->machines.host, -1,
 					       queue->tid);
+	if (!tidq->frontend_thread || !tidq->decode_thread)
+		goto out;
 
 	tidq->packet = zalloc(sizeof(struct cs_etm_packet));
 	if (!tidq->packet)
@@ -654,6 +656,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 	zfree(&tidq->prev_packet);
 	zfree(&tidq->packet);
 out:
+	thread__zput(tidq->frontend_thread);
+	thread__zput(tidq->decode_thread);
 	return rc;
 }
 
-- 
2.53.0



