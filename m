Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB55F364038;
	Sat, 12 Sep 2026 09:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206374; cv=none; b=IgJZDyEVOa3AsZuGI+ohaeEWETmGVe6t+6Bluntlk9eAGqbAxR5lzZDTsApp8gucXZrvBwvg1HBhjbrYJKyztb4a+WZvO8xY1Q0EcuWGRuw+oRNynkfZ6CUFQZ2Dulf64zGOYNjSuQj/5IFdJ9nz0WoRF2kLyTnXuQxRA67PwkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206374; c=relaxed/simple;
	bh=DQFIDohsLRyy78COcyl8cIWWPxGboo4hI8P0HYcZqZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSgokIG6tETz9Cf377nJkEIvQaRKbrh51QUA9m2lMl4hBnn1nMWPVLF9BSxdtTq6u5m5v31Y66aWDvJAbBcp/Z4i/HJ9DTe8DchLAZNy/5EazTvskY6srxcT0Ugg6JhiKxarpA7Uagtb/rohY/tTILI0bCn/kHxFE1WnsbXOe/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1WFlGDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1WFlGDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B161F000FF;
	Sat, 12 Sep 2026 09:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206371;
	bh=Gdh+sG1CEidzarAsus20yMAyGZ59tqts4XeQvjfijHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1WFlGDXbbsNCImY+DS+3RwJHAA2I0phOYci091sUFJw/ItFEbPUt6JMgLc/v16nl
	 imWlKgk8zYXi1ZNbsQhT32HSxz44TWRGA+ltjb3uuq7Yag0lFOO6ukXiKEcdPSGsDV
	 m5m//LrYYCoThEqBpIPDOjC6PWaMbYHRbmKsjvvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0195/1518] perf cs-etm: Fix thread leaks on trace queue init failure
Date: Sat, 12 Sep 2026 08:39:24 +0200
Message-ID: <20260912065627.902684981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 520670348311e..66dbead2c03bc 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -645,6 +645,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 					       queue->tid);
 	tidq->decode_thread = machine__findnew_thread(&etm->session->machines.host, -1,
 					       queue->tid);
+	if (!tidq->frontend_thread || !tidq->decode_thread)
+		goto out;
 
 	tidq->packet = zalloc(sizeof(struct cs_etm_packet));
 	if (!tidq->packet)
@@ -679,6 +681,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 	zfree(&tidq->prev_packet);
 	zfree(&tidq->packet);
 out:
+	thread__zput(tidq->frontend_thread);
+	thread__zput(tidq->decode_thread);
 	return rc;
 }
 
-- 
2.53.0



