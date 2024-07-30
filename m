Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00BD18455C;
	Tue, 30 Jul 2024 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360791; cv=none; b=eRrxEu84v5sAA9YxMDQJUyD7ue7dEFR4nAxgQAHWhiJYx7hYMM91CfIekNLpvW6UQA1v3LFnb9jEC8jN2sX2pvoduk6y7f1yQlKpIExUWRaX9GptGIVInBgzkVN4ycqjM2cytDxKqmsVEVMjyvlCyWNp/RTh+32efQ1qa4DBMOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360791; c=relaxed/simple;
	bh=n8gSz+XG1IFFRNwCKFTCkeVO9VCGKNyiAf10S1xqE4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBmtbOMuMUYBEf/rnN8GxP43oKNZES0oHWAucqjW7yCFnCNYc222aqXUkx7JrGCXQG1VuuoL+UuPJna/RdVXAFj7Dh96FmGgLuyiEgJfyKJSb5dkgarTCyjimjwFBEHJjG+zy5l73B6dRYGlPsVWrlI1ak9pc0piwZNAd/VJkJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtaY/jhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtaY/jhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2959C32782;
	Tue, 30 Jul 2024 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360791;
	bh=n8gSz+XG1IFFRNwCKFTCkeVO9VCGKNyiAf10S1xqE4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtaY/jhrFCY7nfPk0I6DvHlmKJ4y6Q/hbmzmSp+kfzTOp+faQiJvyLUVnJfVW4Mlx
	 T0/uRceTLrjymaE+/UKy3GpSMFRNpmpD9AatDW2KGrvcj/ZLui1zWR5eQbWfy0m2wu
	 2w7CMqogh+6VASQq8476grhfWUe8ET5pYmAp2Gkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Leo Yan <leo.yan@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Yunseong Kim <yskelg@gmail.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 809/809] perf dso: Fix build when libunwind is enabled
Date: Tue, 30 Jul 2024 17:51:25 +0200
Message-ID: <20240730151756.934862307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 92717bc077892d1ce60fee07aee3a33f33909b85 ]

Now that symsrc_filename is always accessed through an accessor, we also
need a free() function for it to avoid the following compilation error:

  util/unwind-libunwind-local.c:416:12: error: lvalue required as unary
    ‘&’ operand
  416 |      zfree(&dso__symsrc_filename(dso));

Fixes: 1553419c3c10 ("perf dso: Fix address sanitizer build")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Yunseong Kim <yskelg@gmail.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20240715094715.3914813-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c                    | 2 +-
 tools/perf/util/dso.h                    | 5 +++++
 tools/perf/util/unwind-libunwind-local.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 2340c4f6d0c24..67414944f2457 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1501,7 +1501,7 @@ void dso__delete(struct dso *dso)
 	auxtrace_cache__free(RC_CHK_ACCESS(dso)->auxtrace_cache);
 	dso_cache__free(dso);
 	dso__free_a2l(dso);
-	zfree(&RC_CHK_ACCESS(dso)->symsrc_filename);
+	dso__free_symsrc_filename(dso);
 	nsinfo__zput(RC_CHK_ACCESS(dso)->nsinfo);
 	mutex_destroy(dso__lock(dso));
 	RC_CHK_FREE(dso);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 878c1f441868b..ed0068251c655 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -602,6 +602,11 @@ static inline void dso__set_symsrc_filename(struct dso *dso, char *val)
 	RC_CHK_ACCESS(dso)->symsrc_filename = val;
 }
 
+static inline void dso__free_symsrc_filename(struct dso *dso)
+{
+	zfree(&RC_CHK_ACCESS(dso)->symsrc_filename);
+}
+
 static inline enum dso_binary_type dso__symtab_type(const struct dso *dso)
 {
 	return RC_CHK_ACCESS(dso)->symtab_type;
diff --git a/tools/perf/util/unwind-libunwind-local.c b/tools/perf/util/unwind-libunwind-local.c
index 5c073d815ba2b..7460bb96bd225 100644
--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -408,7 +408,7 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
 							__func__,
 							dso__symsrc_filename(dso),
 							debuglink);
-					zfree(&dso__symsrc_filename(dso));
+					dso__free_symsrc_filename(dso);
 				}
 				dso__set_symsrc_filename(dso, debuglink);
 			} else {
-- 
2.43.0



