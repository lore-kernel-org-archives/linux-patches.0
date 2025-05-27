Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0983A1EA91;
	Tue, 27 May 2025 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364539; cv=none; b=dGA38zP0B5M36TORtCkhkdk81+inThEzBs03WBSWRoqYRU+dDjfpRlO6TZRYH4MPn4hh4vm3JV6J2i7td6vCSWGeznWtbL7QB++jK5hII7jhnZU5NKwWEi0leo8GO8D0TMaghLtKFupMIJ6GR3i/s/pgGmiXZoKYWgQYSlu7Gho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364539; c=relaxed/simple;
	bh=IBZdjmyso2KyAHFHPBo5+IdpAG7HSpi2mk85LpiDVEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+NWil9BXYK5PutBgev0TpTJJaCNh3wu9SMOTxoSTm1e6Es6kHOsUC71Pg5VkSO/r9Jle7hRDA9Bj0Lr3t9mB2v94lagsYLRohIds5cm6V2md30HAFOCnYnlpYQee8OtZFNQUCP7JO72y/5/hr3hqVjWtNJwvstzaJgIslI1zQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQM39y4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQM39y4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D23BC4CEE9;
	Tue, 27 May 2025 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364538;
	bh=IBZdjmyso2KyAHFHPBo5+IdpAG7HSpi2mk85LpiDVEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQM39y4IgsrzNxXS81TMitzs2oRmAXqgDgXPk8rD43JFuvsIw9SgldkMYaSi5oJPc
	 r/x+tjT3/ZlDN+ZTHXQ9syCUghpZszfitXdh+gJmnZUadZIM4Q+DthRAB2586iqdfu
	 CUR7/DkUL9QGEieKM8YuWxOX0twFzHcF/+pjVOxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/626] tools/build: Dont pass test log files to linker
Date: Tue, 27 May 2025 18:19:42 +0200
Message-ID: <20250527162448.661531814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 935e7cb5bb80106ff4f2fe39640f430134ef8cd8 ]

Separate test log files from object files. Depend on test log output
but don't pass to the linker.

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250311213628.569562-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.build | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
index 5fb3fb3d97e0f..ffe988867703b 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -149,6 +149,10 @@ objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
 obj-y        := $(addprefix $(objprefix),$(obj-y))
 subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
 
+# Separate out test log files from real build objects.
+test-y       := $(filter %_log, $(obj-y))
+obj-y        := $(filter-out %_log, $(obj-y))
+
 # Final '$(obj)-in.o' object
 in-target := $(objprefix)$(obj)-in.o
 
@@ -159,7 +163,7 @@ $(subdir-y):
 
 $(sort $(subdir-obj-y)): $(subdir-y) ;
 
-$(in-target): $(obj-y) FORCE
+$(in-target): $(obj-y) $(test-y) FORCE
 	$(call rule_mkdir)
 	$(call if_changed,$(host)ld_multi)
 
-- 
2.39.5



