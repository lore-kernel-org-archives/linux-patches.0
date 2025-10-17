Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B38B2F12A5;
	Fri, 17 Oct 2025 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714951; cv=none; b=qdfNSKXyDx5ccginof/Y7FCHQhL+Fg88CrVCi/s2e2BSTWeoTbtBkOq21OluW/C7lhTgp8fOW4LpDxmvRWYGu37My9A4xf66GPoX0jNdFVIauMrHVkSNxy3aXwyZkwGdV+H7sys2xloQQVobMaPoKkLrNalOdfha6xrqSIeY1S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714951; c=relaxed/simple;
	bh=oSEGq3qMdf21pQUAwSKzj48o/aOmZftmsE2JKRtGzdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwnd/Rl85k4Ds1ywS1oxQkas+QU6dJxWbs1WZUgS2R7mKzs3gnd3xPe4dUJkvMM8IYw5SVHdiQWZDm7NlHqFsQVGz8pVrqbFiAPs+tWqrdonv1fkdOkw4mm3QfZyC7eRmSFTRDpapRCcX8wtskTjklT4shJ75mU7chDwXyS0dGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZCtP+H5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZCtP+H5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068CFC4CEE7;
	Fri, 17 Oct 2025 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714951;
	bh=oSEGq3qMdf21pQUAwSKzj48o/aOmZftmsE2JKRtGzdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZCtP+H5TveMmZyMTXSUrhNeCUey8TfkoXOZaZYprdK/9dcM46C7WgZFZMc6T6rht
	 OuOinIWs2IvxiF3felo3Soh6h5Oa1a1/kWIJAbav2bj27UqSLQjFm3espnfAaN5SxX
	 XaUFx0l29v8EihPVXQ2ntz52m8blWoZWfsaaWWfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Zsoldos <tamas.zsoldos@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/371] perf session: Fix handling when buffer exceeds 2 GiB
Date: Fri, 17 Oct 2025 16:50:20 +0200
Message-ID: <20251017145203.430963055@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit c17dda8013495d8132c976cbf349be9949d0fbd1 ]

If a user specifies an AUX buffer larger than 2 GiB, the returned size
may exceed 0x80000000. Since the err variable is defined as a signed
32-bit integer, such a value overflows and becomes negative.

As a result, the perf record command reports an error:

  0x146e8 [0x30]: failed to process type: 71 [Unknown error 183711232]

Change the type of the err variable to a signed 64-bit integer to
accommodate large buffer sizes correctly.

Fixes: d5652d865ea734a1 ("perf session: Add ability to skip 4GiB or more")
Reported-by: Tamas Zsoldos <tamas.zsoldos@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250808-perf_fix_big_buffer_size-v1-1-45f45444a9a4@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 26ae078278cd6..09af486c83e4f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1402,7 +1402,7 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	const struct perf_tool *tool = session->tool;
 	struct perf_sample sample;
 	int fd = perf_data__fd(session->data);
-	int err;
+	s64 err;
 
 	perf_sample__init(&sample, /*all=*/true);
 	if ((event->header.type != PERF_RECORD_COMPRESSED &&
-- 
2.51.0



