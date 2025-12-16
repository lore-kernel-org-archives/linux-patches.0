Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FAC364036;
	Tue, 16 Dec 2025 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887780; cv=none; b=mi80oqTEILpEjF/Jie9fDX4L7ufVLIGgWREtWJwieECJ/iyzA9iWAiWePf21u0rcPn6fKe2AhY7KSAqf4WYFVbWGjpU1HkdjZHlkHmrGWFNAtIjxX384kfGKIH1ey8VBC9hO8uEmhp/kkCxK0VT6ZgubpkUy5QXxSRENPwgU/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887780; c=relaxed/simple;
	bh=irMPozeV6/ocbQUHh1/Vz3ILUoON3zHoylHzzHTs9GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czBbIi9m+35mrOjvHutjqZa8XRFTxRT0zj5yM9pfs9KcTBIX1L3KrxCxL0YIhR5aCIy8z8Hu7YgVtCQ5yzh98YvII71dmxBVnt0dWPFe/bDq/MaqH0pLwC9mJ1jHya1s4sGezwjd9E3wOnp4jgIA/zcsgkdbDWq5XcQr8LwO6aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPBhiSHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPBhiSHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2B2C4CEF1;
	Tue, 16 Dec 2025 12:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887780;
	bh=irMPozeV6/ocbQUHh1/Vz3ILUoON3zHoylHzzHTs9GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPBhiSHbOjUad8+CZHbCi1kAPsXHV5EHpvOHT/nMROyHSL8dl+++OKf3BqbaWp48L
	 gFrts/mJwvy4sApWPtzeSrqynENSz55zXDyUPGOcFa8XBaI3+tEhhT6/73K2mggvi/
	 9P5TCZR6k/YvcTp6ouG2u01ITcEtE3JN0649Baas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Costa Shulyupin <costa.shul@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/614] tools/rtla: Fix unassigned nr_cpus
Date: Tue, 16 Dec 2025 12:11:42 +0100
Message-ID: <20251216111413.502577065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Costa Shulyupin <costa.shul@redhat.com>

[ Upstream commit b4275b23010df719ec6508ddbc84951dcd24adce ]

In recently introduced timerlat_free(),
the variable 'nr_cpus' is not assigned.

Assign it with sysconf(_SC_NPROCESSORS_CONF) as done elsewhere.
Remove the culprit: -Wno-maybe-uninitialized. The rest of the
code is clean.

Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Reviewed-by: Tomas Glozar <tglozar@redhat.com>
Fixes: 2f3172f9dd58 ("tools/rtla: Consolidate code between osnoise/timerlat and hist/top")
Link: https://lore.kernel.org/r/20251002170846.437888-1-costa.shul@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/Makefile.rtla  | 2 +-
 tools/tracing/rtla/src/timerlat.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/Makefile.rtla b/tools/tracing/rtla/Makefile.rtla
index 08c1b40883d3a..1743d91829d46 100644
--- a/tools/tracing/rtla/Makefile.rtla
+++ b/tools/tracing/rtla/Makefile.rtla
@@ -18,7 +18,7 @@ export CC AR STRIP PKG_CONFIG LD_SO_CONF_PATH LDCONFIG
 FOPTS		:= -flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong	\
 		-fasynchronous-unwind-tables -fstack-clash-protection
 WOPTS		:= -O -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2		\
-		-Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
+		-Wp,-D_GLIBCXX_ASSERTIONS
 
 ifeq ($(CC),clang)
   FOPTS		:= $(filter-out -flto=auto -ffat-lto-objects, $(FOPTS))
diff --git a/tools/tracing/rtla/src/timerlat.c b/tools/tracing/rtla/src/timerlat.c
index b692128741279..11ad447a8dd78 100644
--- a/tools/tracing/rtla/src/timerlat.c
+++ b/tools/tracing/rtla/src/timerlat.c
@@ -215,7 +215,8 @@ void timerlat_analyze(struct osnoise_tool *tool, bool stopped)
 void timerlat_free(struct osnoise_tool *tool)
 {
 	struct timerlat_params *params = to_timerlat_params(tool->params);
-	int nr_cpus, i;
+	int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int i;
 
 	timerlat_aa_destroy();
 	if (dma_latency_fd >= 0)
-- 
2.51.0



