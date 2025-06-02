Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89921FBC8C;
	Mon,  2 Jun 2025 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873180; cv=none; b=D1iR/mD7JxGz7IE71JPEyoJ8pcnNenajAm0ZkurlDXqq7eKPRj0eZg+mgjdrOfc7E975EHOXagoqCOavioyv2NScSIH/GTsjqzuGJZZBODo95pKXywtSmZXEF7wlDOBwbKDhGCVXQGMFiqMRU6gfCzvUkhVJCMY27YjZBZ33iqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873180; c=relaxed/simple;
	bh=KIKC4+XJPxdEyVmyoT6TxQ9W30qiLQjtKFx2aUpHR8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+7ypRfnrNNWCxyBmp59XlehjBQY1pOXzj6kyfHIImoiAtug3uQc2Ov4rIwCKcAOzYMo9EDwdfo4cSFv3jBhr8K0ZSHPLEZnmYp5wk+7h79CZ8xw95caCUxGEKc9TMuCE1Fbjh9G20goZfm6PMT5E2I28FdQvgan3KDp2mULNMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+4blpsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+4blpsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F4BC4CEF2;
	Mon,  2 Jun 2025 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873180;
	bh=KIKC4+XJPxdEyVmyoT6TxQ9W30qiLQjtKFx2aUpHR8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+4blpsT8SiCwEGRpMZBludFFCQK407AXsNb7onkbcBHaF+0tqmmFMy5WQ/B3L61W
	 G3B1wqNKL3bWjQgVwfI2DuE9JdWgp2sZNFwS7oYvtY5qtegdZMeIKKnpD9bKSKH659
	 02I4dYDOmtXVdwFjuKSI5vIONm1clLNowLnBVJO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/444] tools/build: Dont pass test log files to linker
Date: Mon,  2 Jun 2025 15:42:07 +0200
Message-ID: <20250602134343.480080426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fac42486a8cf0..27f4ee9cb4db4 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -141,6 +141,10 @@ objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
 obj-y        := $(addprefix $(objprefix),$(obj-y))
 subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
 
+# Separate out test log files from real build objects.
+test-y       := $(filter %_log, $(obj-y))
+obj-y        := $(filter-out %_log, $(obj-y))
+
 # Final '$(obj)-in.o' object
 in-target := $(objprefix)$(obj)-in.o
 
@@ -151,7 +155,7 @@ $(subdir-y):
 
 $(sort $(subdir-obj-y)): $(subdir-y) ;
 
-$(in-target): $(obj-y) FORCE
+$(in-target): $(obj-y) $(test-y) FORCE
 	$(call rule_mkdir)
 	$(call if_changed,$(host)ld_multi)
 
-- 
2.39.5



