Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F4FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70887C433D2;
	Mon, 15 May 2023 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169609;
	bh=q7uSRsJsO29IA51Q1xdw9dYkw7E3rxMHB33ck/9LeZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrV9y7Ml1KFda22FQKhiISpsxDtGdYZAROx/yflumlGkrJusFgxLXtv6qR+jAHSV/
	 JHrx0bYWTsniDBJZw9k+LQ9IkKkcRGrWolXdtMyFy8UMotxDSQWaAwIA/+UahCrgUS
	 CMbnG+MODP0eyyztPxus10isz4FOpSvXcBz5oFiY=
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
Subject: [PATCH 6.3 112/246] perf symbols: Fix unaligned access in get_x86_64_plt_disp()
Date: Mon, 15 May 2023 18:25:24 +0200
Message-Id: <20230515161725.935895692@linuxfoundation.org>
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

[ Upstream commit a2410b579c72242ac0f77b3768093d8c1b48012e ]

Use memcpy() to avoid unaligned access.

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
index 98a18fb854180..42b83bef67aaf 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -565,9 +565,12 @@ static u32 get_x86_64_plt_disp(const u8 *p)
 		n += 1;
 	/* jmp with 4-byte displacement */
 	if (p[n] == 0xff && p[n + 1] == 0x25) {
+		u32 disp;
+
 		n += 2;
 		/* Also add offset from start of entry to end of instruction */
-		return n + 4 + le32toh(*(const u32 *)(p + n));
+		memcpy(&disp, p + n, sizeof(disp));
+		return n + 4 + le32toh(disp);
 	}
 	return 0;
 }
-- 
2.39.2



