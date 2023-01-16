Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4F96FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC31C433EF;
	Mon, 16 Jan 2023 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886920;
	bh=nPnnrOx9GASPEomNcyvveyF5DOVQIDh3Nts/E/4B5ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VroA7C9AWWsNqzMMIpAOiaD9zIL7hoNyD+cPYt6M4jdZj92gmhwj6I13ySvwF1Cjg
	 3Lg4TN5ybOAWEqQuyO+OifZM1l5TQOWVkiqJ6b9j1f/9M3SPAib6Bf2T3SoshXGZQA
	 ViJVLTOPTgSg4JCPYY5DzJd7AiFuBOoBQJ1KHIB4=
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
Subject: [PATCH 5.4 582/658] perf tools: Fix resources leak in perf_data__open_dir()
Date: Mon, 16 Jan 2023 16:51:10 +0100
Message-Id: <20230116154936.124365208@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 3c874f52f1a2..4da900bdb2f1 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -120,6 +120,7 @@ int perf_data__open_dir(struct perf_data *data)
 		file->size = st.st_size;
 	}
 
+	closedir(dir);
 	if (!files)
 		return -EINVAL;
 
@@ -128,6 +129,7 @@ int perf_data__open_dir(struct perf_data *data)
 	return 0;
 
 out_err:
+	closedir(dir);
 	close_dir(files, nr);
 	return ret;
 }
-- 
2.35.1



