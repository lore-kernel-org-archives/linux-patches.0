Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03F31B10B;
	Sat, 12 Sep 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222887; cv=none; b=kfcVkRwnTveYbUmyLKbAWgnd5YtvWL0uFj0vBi/DUESMPYrr712yO+vfBl8IvgPrzzn3O9ixsD2M7xEhrDwIaxTHFYT4Q3MWsEESMK2JGZEKykcFnl82pmREYb0upLAqKpYWqRq9g5xWGMr0V2xCPEzqg8PtOYO0qY3+10RR4gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222887; c=relaxed/simple;
	bh=kjhjqeGHCbLWUZKQRjFMDnspq6I5gxKuBSKdcZ6d3sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCkagOUU/1H8MFd2E7T/EYPK1glD0G7eR9wVZXCDZ5nOh81RaJXulZKVruU0rQgttJXkXTeQj7EoorLsG3WnvkGdIHwBAGi+MgtlYgKxJ0U4vwoldtwTTXpYvZ5gqckxGhLJGIanWJ6Yn8s+k3IVq3oP26+PNZ2NCEfTrM9TDDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIBOtB2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIBOtB2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C79A1F000FF;
	Sat, 12 Sep 2026 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222885;
	bh=lsDOIbvEDvhprGqSmNC9RMs96+Pw+EDAK58jS5O1a+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIBOtB2Vye0tFbD7PmHEpUKTgH68wC5ryknGh7GlWxDHvBywL6RwzYXJbavJvToRD
	 DtxdxyzJsskXykZbTsrzZsAlH/N0YWF9+2ktQ9m9L9fbpAISzyb/SFGTv7qLAmjlkK
	 bzNQY8nxYG6g09HzoO2kxKtNx+aBOAtAhnc04ePc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0634/1424] perf cs-etm: Fix thread leaks on trace queue init failure
Date: Sat, 12 Sep 2026 08:51:06 +0200
Message-ID: <20260912065621.486986347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8dc12759ee62f..de99a53376bfb 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -501,6 +501,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 					       queue->tid);
 	tidq->decode_thread = machine__findnew_thread(&etm->session->machines.host, -1,
 					       queue->tid);
+	if (!tidq->frontend_thread || !tidq->decode_thread)
+		goto out;
 
 	tidq->packet = zalloc(sizeof(struct cs_etm_packet));
 	if (!tidq->packet)
@@ -535,6 +537,8 @@ static int cs_etm__init_traceid_queue(struct cs_etm_queue *etmq,
 	zfree(&tidq->prev_packet);
 	zfree(&tidq->packet);
 out:
+	thread__zput(tidq->frontend_thread);
+	thread__zput(tidq->decode_thread);
 	return rc;
 }
 
-- 
2.53.0



