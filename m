Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708C0FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1929FC433EF;
	Mon, 15 May 2023 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170351;
	bh=HvOo0yLS5BMsclKeQb9krBNa0Lt+QRCkcuetBiy6zy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grZ1gPzHuPh3AZ+8DH2GsOIHe352dhF5Fa1mzrjxTryqQNooMWhnIMNaRRaVXF/nP
	 Jbzf9IzYsPGAW0IYIVfWx9TWnCrmx4CSG6OjgmnAb0ydvim1QQL5TgNObfPnMH8rVE
	 ruDiQRetM5n6Ppv42Ymig3ZBS7FZq7FdcNxvho2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Ochowicz <Will.Ochowicz@genusplc.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/239] perf symbols: Fix return incorrect build_id size in elf_read_build_id()
Date: Mon, 15 May 2023 18:26:06 +0200
Message-Id: <20230515161724.771221827@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 1511e4696acb715a4fe48be89e1e691daec91c0e ]

In elf_read_build_id(), if gnu build_id is found, should return the size of
the actually copied data. If descsz is greater thanBuild_ID_SIZE,
write_buildid data access may occur.

Fixes: be96ea8ffa788dcc ("perf symbols: Fix issue with binaries using 16-bytes buildids (v2)")
Reported-by: Will Ochowicz <Will.Ochowicz@genusplc.com>
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Will Ochowicz <Will.Ochowicz@genusplc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/lkml/CWLP265MB49702F7BA3D6D8F13E4B1A719C649@CWLP265MB4970.GBRP265.PROD.OUTLOOK.COM/T/
Link: https://lore.kernel.org/r/20230427012841.231729-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 80345695b1360..29c9348c30f00 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -553,7 +553,7 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
 				size_t sz = min(size, descsz);
 				memcpy(bf, ptr, sz);
 				memset(bf + sz, 0, size - sz);
-				err = descsz;
+				err = sz;
 				break;
 			}
 		}
-- 
2.39.2



