Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2742C3E40EF;
	Thu, 17 Sep 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668094; cv=none; b=VLLbVGdfrFTwP+7UE7Gv9N0mawfXSkk+0iFgbW1ZMc4S43kvx9DgdO5y38cicNuA0vvyxr4DuQess30Rkofgx/NUro/wvOEw3B53dqDWdmG4UeFThw44uRkSHL+pM4maYhe/t0DGVJyvFmktKLyigyRCyOw1OgOE8fjb2Xmc09k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668094; c=relaxed/simple;
	bh=TVW/awgtio67xqgDC4ksKBaIgx30krwuCSZaynXue2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7KUyk10xHsLZRamJC15Pi6/DPgdHipzcQVJueMquizE+1flU3Fd2e3ITjvfFfdmD5bNj1xoEl1Iep5G8I782NGp3aywqHRE4sD4R8hnalHYW/7DginjZnCsxXpOF+rKBSf4/8xBMDw+AtxX68vP6MctLi9wp1GVbiDtW3Q2GHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIMhNnbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIMhNnbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF001F000FF;
	Thu, 17 Sep 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668093;
	bh=M4S+uUQp0nTkuqAiW353QgED0ZbtBNkD+vqJqqytfrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIMhNnbulsFZ90s30mIImp4eE+jLiw2Arm+VJYetW/rkbKqFG+VEvv/JgxpkJ44xr
	 Gg94HJAcLcpX3uQCdVf/ejKgjcukSCq2tSuoHhKblxJLivj3pZm0hmt0m6sm8OEl+q
	 d/ilPkolp8DIMQPdFkvXmKEjiiNGl6ynXSrvVL3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0311/1102] bpftool: Pass host flags to bootstrap libbpf
Date: Thu, 17 Sep 2026 16:04:14 +0100
Message-ID: <20260917151547.430171005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 9080b97689dbf8d2c338a9af97cd2b4a714f25bf ]

bpftool builds a bootstrap libbpf with HOSTCC, but the libbpf submake can
still inherit target build flags through CFLAGS. This can break cross
builds when host objects are compiled with target-only options.

Since HOST_CFLAGS contains warning options that are not suitable for
building libbpf, use LIBBPF_BOOTSTRAP_CFLAGS with the warning options
removed to build the bootstrap libbpf. Clear EXTRA_CFLAGS so target
extra flags are not mixed into the host bootstrap libbpf build.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/r/20260602-tools_build_fix_zero_init_bpf_only-v2-1-c76e5250ea1c@arm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index ba927379eb201..f92cdb7dbd428 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -53,7 +53,8 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
 $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
 		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR:/=) prefix= \
-		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" $@ install_headers
+		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" \
+		CFLAGS="$(LIBBPF_BOOTSTRAP_CFLAGS)" EXTRA_CFLAGS= $@ install_headers
 
 $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
 	$(call QUIET_INSTALL, $@)
@@ -93,6 +94,9 @@ HOST_CFLAGS := $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),\
 		$(subst $(CLANG_CROSS_FLAGS),,$(CFLAGS)))
 HOST_LDFLAGS := $(LDFLAGS)
 
+# Remove warnings for libbpf bootstrap build
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+
 INSTALL ?= install
 RM ?= rm -f
 
-- 
2.53.0



