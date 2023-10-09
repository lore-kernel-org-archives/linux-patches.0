Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F414418035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+79NWhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE6CC433C7;
	Mon,  9 Oct 2023 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858873;
	bh=xVf1poW2Vns6eGjR8b/Pih6RrD0lZfn+7NGgDYWLsYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+79NWhRiCaboz/nrCfGTckpvCFnJTlZKyvIAELrpwnHOmDSB5esF2jGBchg4DsLT
	 cc1fTH0nzNFNl345toWatJiCXsONJjwSxDiTzi4LjOcEgsPl/7/KrDoUXNWpXYmZtE
	 5OlGSSXhOyD7lhx36is/1gIoJuXkL2/4coS10dPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/226] perf build: Define YYNOMEM as YYNOABORT for bison < 3.81
Date: Mon,  9 Oct 2023 15:01:29 +0200
Message-ID: <20231009130130.115254228@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 88cc47e24597971b05b6e94c28a2fc81d2a8d61a ]

YYNOMEM was introduced in bison 3.81, so define it as YYABORT for older
versions, which should provide the previous perf behaviour.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/Build | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 0cf27354aa451..0f9732d5452e6 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -253,6 +253,12 @@ ifeq ($(BISON_GE_35),1)
 else
   bison_flags += -w
 endif
+
+BISON_LT_381 := $(shell expr $(shell $(BISON) --version | grep bison | sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\).\([0-9]\+\)/\1\2\3/g') \< 381)
+ifeq ($(BISON_LT_381),1)
+  bison_flags += -DYYNOMEM=YYABORT
+endif
+
 CFLAGS_parse-events-bison.o += $(bison_flags)
 CFLAGS_pmu-bison.o          += -DYYLTYPE_IS_TRIVIAL=0 $(bison_flags)
 CFLAGS_expr-bison.o         += -DYYLTYPE_IS_TRIVIAL=0 $(bison_flags)
-- 
2.40.1



