Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9E13090D5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300905; cv=none; b=hK81ci2UDXFy2v0ZO6RhdH2f+U7X9hZqhgycyPS8V8Bm7TZKAsFZyT/9dVeT/aqOQBt+HeEp4/j/p2ew+YmcdoEFMZtUKV2L/CH03lodlxzsNq479lQvUFNtpQZobJX90z6gsjfUDjOBk5M5cXnd+52HaUurHb1KrlQaxoVEvQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300905; c=relaxed/simple;
	bh=arL/7RVLXJxrKVxhxcK9OJ/+zcoX0CjtV+x8HUGf0ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzubAlr/JZeInNokLx9cl4qI8LfxnEli8NyfbWWhptb/qMlka5BnCNmOC6zF7ajPwTBmDXJdWtr8v50p9Vlf9q2n5UR49nB0lSGm4mZu0yuvXQIhmXaqWbntMHTjEJ+3Vh9PMdJXHu8VuNB3UFZinAuo2sKjPU/izlFXjB5B5JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qASwp+L0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qASwp+L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4155C19423;
	Sat, 28 Feb 2026 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300904;
	bh=arL/7RVLXJxrKVxhxcK9OJ/+zcoX0CjtV+x8HUGf0ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qASwp+L0NCP630m28Y2dqNpd7K36gOPNLswQysVuFpcmUUxlF5uLS7S9Dktefa8ZJ
	 9eoOy16yntOCTotjxmRaSd2RJZ2MhKC8zxzMR3dLlFIR8qz1MlvSWrbjnUbGBArAgC
	 BsgSQD6bsNcauu/IaL3h42DNjRdjykaz1Z3OF1lOOX4eTCCW+LbmuDShzzRA/pXscb
	 5FRDfft7DzY2hjYRbJlr7TVwX3gypixhuJo6rimKYzNOV1M4Co/zy87VRmPHPMWPrd
	 4Z9pWB/mikHqpRqZneoM/ZHLZ8MtWkXBxb+J51q9FcwvrZ6bp6fpCOuIFxsxn7DrCs
	 AuNIWoCAXVWZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/752] libperf build: Always place libperf includes first
Date: Sat, 28 Feb 2026 12:35:30 -0500
Message-ID: <20260228174750.1542406-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit 8c5b40678c63be6b85f1c2dc8c8b89d632faf988 ]

When building tools/perf the CFLAGS can contain a directory for the
installed headers.

As the headers may be being installed while building libperf.a this can
cause headers to be partially installed and found in the include path
while building an object file for libperf.a.

The installed header may reference other installed headers that are
missing given the partial nature of the install and then the build fails
with a missing header file.

Avoid this by ensuring the libperf source headers are always first in
the CFLAGS.

Fixes: 3143504918105156 ("libperf: Make libperf.a part of the perf build")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 7fbb50b74c00b..5c64122bf5374 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -51,9 +51,9 @@ INCLUDES = \
 -I$(srctree)/tools/include/uapi
 
 # Append required CFLAGS
+override CFLAGS := $(INCLUDES) $(CFLAGS)
 override CFLAGS += -g -Werror -Wall
 override CFLAGS += -fPIC
-override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
 override CFLAGS += $(EXTRA_WARNINGS)
 override CFLAGS += $(EXTRA_CFLAGS)
-- 
2.51.0

