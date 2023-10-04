Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1408A1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A5FC433C7;
	Wed,  4 Oct 2023 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442882;
	bh=bGU+5ASGzg2sKsRXB6/i7VsYUSslbaQ6oAvTyd93BFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4FY9Oxmg3f/dO5Dw/au08+1LxXMltJ1QRTk1kdtpFbXtRx1tkUct+CXGwHQzZ5DZ
	 EgwL+hv1C8yw8gach+nH9eJoBjW+OzuHBaFFV6/dyW80cpnOmvR/fKl0AbQ+HeJcT/
	 KDkqcR6H0XuJYRU1hlCHmw8Pky0C9Qli3DZpKVTE=
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
Subject: [PATCH 5.15 142/183] perf build: Define YYNOMEM as YYNOABORT for bison < 3.81
Date: Wed,  4 Oct 2023 19:56:13 +0200
Message-ID: <20231004175209.938770222@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2914d5bed6e8..7d085927da413 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -263,6 +263,12 @@ ifeq ($(BISON_GE_35),1)
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



