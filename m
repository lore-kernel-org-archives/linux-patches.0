Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83228FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDFC4339B;
	Mon, 15 May 2023 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169605;
	bh=HmDcSOsLgumo/hdJPNunpB1OKIdG4bdJ8yeX5eqGbEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIcF/YTIY0/mrgApvDrLPmxPwOzJHQQYELHe6i23KrfGSkVe+jydlVmmHEpVBYn2g
	 m15Uk8nPm9RYIS7CEME8Z8F/TbQg2p8ZuEQl/dimHgGo6lWuSLMDBekfUjIxPfzCzC
	 ScPNnIxMVhLJ4PJQBSXjIIuz5m3Dy9tp0BASIay8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yujie.liu@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 111/246] perf symbols: Fix use-after-free in get_plt_got_name()
Date: Mon, 15 May 2023 18:25:23 +0200
Message-Id: <20230515161725.906448252@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c8bb2d76a40ac0ccf6303d369e536fddcde847fb ]

Fix use-after-free in get_plt_got_name().

Discovered using EXTRA_CFLAGS="-fsanitize=undefined -fsanitize=address".

Fixes: ce4c8e7966f317ef ("perf symbols: Get symbols for .plt.got for x86-64")
Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/oe-lkp/202303061424.6ad43294-yujie.liu@intel.com
Link: https://lore.kernel.org/r/20230316194156.8320-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 41882ae8452e5..98a18fb854180 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -580,6 +580,7 @@ static bool get_plt_got_name(GElf_Shdr *shdr, size_t i,
 	const char *sym_name;
 	char *demangled;
 	GElf_Sym sym;
+	bool result;
 	u32 disp;
 
 	if (!di->sorted)
@@ -606,9 +607,11 @@ static bool get_plt_got_name(GElf_Shdr *shdr, size_t i,
 
 	snprintf(buf, buf_sz, "%s@plt", sym_name);
 
+	result = *sym_name;
+
 	free(demangled);
 
-	return *sym_name;
+	return result;
 }
 
 static int dso__synthesize_plt_got_symbols(struct dso *dso, Elf *elf,
-- 
2.39.2



