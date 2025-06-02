Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5181DED64;
	Mon,  2 Jun 2025 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874665; cv=none; b=NLAROVgFoxsoJLoFqtV5HbshSqJprHv/JTbcceVY8CuLOedBIa1hpdGy1zXGgRI9O1tUbVgccb1pTA6snRJKVa91cgiXo3Kds9r9/x3lx9uA5JBKw1f8LBI9HYkd/wm0r62esgyxFWNnl0XnpfdDH8tDHrrKrshO+3lJzfL/870=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874665; c=relaxed/simple;
	bh=Dzb31lT4A+57NGmIqdC9iKW33eX27dJTiu6GgX3Ycb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhtrCUsw2WAudJkyoyvmUytaPa8v99+w6ei9m9unfBf9CjRAovfZbu0igIC1REYhpwDJYcAEG8tiCB9B12pAmDggIpMYkY9e1NrjtCmNIZDKIhL8qDG5iJrAoEWJWBQ4oHxbx2L6kaourkDXJ+TikE69cAFKg9MxXMdmLg7SA9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttH8XcCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttH8XcCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACDCC4CEEB;
	Mon,  2 Jun 2025 14:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874665;
	bh=Dzb31lT4A+57NGmIqdC9iKW33eX27dJTiu6GgX3Ycb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttH8XcCPth8TW0LneU4TbeABitufYm2ky/b++0ESJawPu98a8dr/Pzuz1K++rg5tU
	 MROT1ZU5MxnSxUtdUD6uXzwzRBsniOSSCw7uCeMUSUsfmyb6XouKY61yL8RAs0mf1U
	 UfF5+9bFqutDjOex1vOOdDqUAwg/APatVQWXRksQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/204] tools/build: Dont pass test log files to linker
Date: Mon,  2 Jun 2025 15:47:09 +0200
Message-ID: <20250602134259.429798680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cd72016c3cfa7..ab0630ae6be85 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -130,6 +130,10 @@ objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
 obj-y        := $(addprefix $(objprefix),$(obj-y))
 subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
 
+# Separate out test log files from real build objects.
+test-y       := $(filter %_log, $(obj-y))
+obj-y        := $(filter-out %_log, $(obj-y))
+
 # Final '$(obj)-in.o' object
 in-target := $(objprefix)$(obj)-in.o
 
@@ -140,7 +144,7 @@ $(subdir-y):
 
 $(sort $(subdir-obj-y)): $(subdir-y) ;
 
-$(in-target): $(obj-y) FORCE
+$(in-target): $(obj-y) $(test-y) FORCE
 	$(call rule_mkdir)
 	$(call if_changed,$(host)ld_multi)
 
-- 
2.39.5



