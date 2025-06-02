Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D655322A4EB;
	Mon,  2 Jun 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876785; cv=none; b=MozpuE5r2yUQo00EJJH2SGhNJFMjKS8dxP1Atvrgj5qVGddHXH/KP5Y4FZ5FAQJnUa2u0qRsbE4A6ANmnc3diD2ihG/zrRqvEIJi5TjW4Z6vGmVNAg5lAR8SeMGcJJRjcFNOv5VW/qbq3a+N5l/haEtu1P43OYRQw7nyyaBeBQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876785; c=relaxed/simple;
	bh=KYkYWdEmBe77EdLxcWFEYLCseUN4XUFmfWlIj6nQHEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjgdrLWdBLu9ECNfwG7SqLueHmXUO394VwyKi+TZ3pd0B9p/b11A1gmMlFS3HVaZSNrBkS0g3ExUBHg9XmuRkD5RV/wgd+/j1YP+7dPaOJRsEPC8+wijsH8Ngvkgb5qQ9QSGJf1XighW5E4W9LbRMvJuFjBpkFfLdVyRBXY6lSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDIy51Io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDIy51Io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C49C4CEF0;
	Mon,  2 Jun 2025 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876785;
	bh=KYkYWdEmBe77EdLxcWFEYLCseUN4XUFmfWlIj6nQHEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDIy51IoDicZz13eDD2U5noLNuK2WLnNPTVdwil5y+xhV8RtLY9KWA8eEmSg9zJqH
	 u4t1N9G0tjbnW/rj/NDuNS1Ius7eml3ctG/Kpll9eK+CIwokFhNpu1OgyhIorSL4fM
	 42KqNwKgBVuNjf5lJd/sJ5mhqB04gTTIiq1JJOtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/325] tools/build: Dont pass test log files to linker
Date: Mon,  2 Jun 2025 15:45:19 +0200
Message-ID: <20250602134321.501414564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 715092fc6a239..6a043b729b367 100644
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



