Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA70F4ED1AD;
	Thu, 17 Sep 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664572; cv=none; b=RZ3yOLKvgUXhK0yNz5xahC70U7Vsvosfz95egA1A1Tm1F6L+wr1runhY20TwGBx/rWBP0el17v6HLFdnJKy79VYe/2RtaEu3DZjluW93QE3yJMcXIp+FuhFH49Z4x8x+YT0LZPSU1EZmb9j3c52UjV9w8BZRSo2uxnqiISAfmp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664572; c=relaxed/simple;
	bh=eOpEGS+BfP+oCHZJL0AoYcaqlsqBxUKP3DqrgtYOuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBwYacoS0fPxFU2WGqD91d+7wiglfj1BZsHa2sJXvXGeIgKRGiMi+FkBNPUaK1mZi00BD4OHa8YCKsdZ6amda/MCNTKyhVXBd9qLGDyUFiA84C34PFQkRu3UR5NXbjle3yYW+7+1f5VHg+QR/DmeiJI/hjArm8+EVFX0hrG/gcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2thlRBlg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2thlRBlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83D31F000FF;
	Thu, 17 Sep 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664570;
	bh=TkGficcXLPy+tC+i7zYLSjp5M2WWUgDq5D8Z7Xk3MNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2thlRBlgvafFUuc2L/EVHkSyMOkOLsQ3/SuMP0QrY6XK4jSi08jwe949i5xugtqUh
	 YPW8D6DA9lm+d4T/0p8Kushc2s2ofPpoCdcAFZ/CXRZ4+8+xGKfMlyjI9mzE48rZJD
	 gOpUAck6wqaVYzSYwEIcox5NaKY1+G1M101b1c2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0416/1250] bpftool: Pass host flags to bootstrap libbpf
Date: Thu, 17 Sep 2026 16:03:31 +0100
Message-ID: <20260917151603.300781495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index fd43e5ea63f38..4b6670bad86e7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -47,7 +47,8 @@ $(LIBBPF_INTERNAL_HDRS): $(LIBBPF_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_HDRS_
 $(LIBBPF_BOOTSTRAP): $(wildcard $(BPF_DIR)/*.[ch] $(BPF_DIR)/Makefile) | $(LIBBPF_BOOTSTRAP_OUTPUT)
 	$(Q)$(MAKE) -C $(BPF_DIR) OUTPUT=$(LIBBPF_BOOTSTRAP_OUTPUT) \
 		DESTDIR=$(LIBBPF_BOOTSTRAP_DESTDIR:/=) prefix= \
-		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" $@ install_headers
+		ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" AR="$(HOSTAR)" \
+		CFLAGS="$(LIBBPF_BOOTSTRAP_CFLAGS)" EXTRA_CFLAGS= $@ install_headers
 
 $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS): $(LIBBPF_BOOTSTRAP_HDRS_DIR)/%.h: $(BPF_DIR)/%.h | $(LIBBPF_BOOTSTRAP_HDRS_DIR)
 	$(call QUIET_INSTALL, $@)
@@ -92,6 +93,9 @@ HOST_CFLAGS := $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),\
 		$(subst $(CLANG_CROSS_FLAGS),,$(CFLAGS)))
 HOST_LDFLAGS := $(LDFLAGS)
 
+# Remove warnings for libbpf bootstrap build
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+
 INSTALL ?= install
 RM ?= rm -f
 
-- 
2.53.0



