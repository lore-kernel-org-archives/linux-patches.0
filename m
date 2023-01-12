Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0070379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D798C433EF;
	Thu, 12 Jan 2023 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534270;
	bh=35R09A3QVLlJDlfi6N1Bg5ntKERc81fz3rf28Zrux18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw/eB4Y5Je1VdV1x8TVvw86Ty8ZFQoRHrSAacwlhLzSxTT173m9KXkf0Ym3Vw/T/a
	 6sJdtOQbelEY8OSy6XH0FkIZZtuF/3qCUkoYXmXM+Z0d+Z2TJGzikniLpmJTeBWCYI
	 AtvRuP786yjGLqNKH6676cIIRd0M1zpm33mG9vA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 752/783] perf tools: Fix resources leak in perf_data__open_dir()
Date: Thu, 12 Jan 2023 14:57:48 +0100
Message-Id: <20230112135559.229604390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0a6564ebd953c4590663c9a3c99a3ea9920ade6f ]

In perf_data__open_dir(), opendir() opens the directory stream.  Add
missing closedir() to release it after use.

Fixes: eb6176709b235b96 ("perf data: Add perf_data__open_dir_data function")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221229090903.1402395-1-linmq006@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 48754083791d..29d32ba046b5 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -127,6 +127,7 @@ int perf_data__open_dir(struct perf_data *data)
 		file->size = st.st_size;
 	}
 
+	closedir(dir);
 	if (!files)
 		return -EINVAL;
 
@@ -135,6 +136,7 @@ int perf_data__open_dir(struct perf_data *data)
 	return 0;
 
 out_err:
+	closedir(dir);
 	close_dir(files, nr);
 	return ret;
 }
-- 
2.35.1



