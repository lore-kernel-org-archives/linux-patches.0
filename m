Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F642676C9;
	Tue,  8 Apr 2025 11:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111296; cv=none; b=J2V0B7yUWvqazd2wF7upzmrftV9NiP0pBfTAa24ZlZ110VkBvn3M8LDtxiflmVVrn+wkK0wNTjzAwGdCp0rcXwulPWKhd4XfErHh12aBUYEGulSf8Dzptwx5CuEf5JiAI/25LI+BfFkPaBfEyVXUI7iCN6XAjsinb2UMMSXpUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111296; c=relaxed/simple;
	bh=FQc0CruzKBgG6TpAFaNXjy2S2cDjufRmeIO/FU6qv3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUNPVGebfVIIEgj+Q+WHsgLpNJEJMeIQ/T314AsxnhH+ELIzumkfsoWwCBqdOa1Ln5XD58pkZM/nu1uzcYnPD6ZC3FMxbH/vf20hwVf9tSzHxnEp5fjyEtzEMmE4BN6IwmfaHblUThCV/Y5g54ejx4litcpLu4dgGe2CJF3zB78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAZlwS18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAZlwS18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF34C4CEE5;
	Tue,  8 Apr 2025 11:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111295;
	bh=FQc0CruzKBgG6TpAFaNXjy2S2cDjufRmeIO/FU6qv3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAZlwS18Ml4r0yWMlv8gsLERyNJi+no40znScMrN8P0R3m9qC6tA1FCmBpmhNvq1J
	 BSqb9XYIUjL4kpLdXwYbCdmhD22xaOM+gIVAJrSj602gHaFR7EAAd8lM0Q6F7R8ZTR
	 wNNG6cqU9IISvaPHgmjz+MLmUAVeXdInX37Es/2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 378/731] selftests/bpf: Fix runqslower cross-endian build
Date: Tue,  8 Apr 2025 12:44:35 +0200
Message-ID: <20250408104923.069768031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit cb3ade567816a03d1ac1c33bf86073574efcfcaf ]

The runqslower binary from a cross-endian build currently fails to run
because the included skeleton has host endianness. Fix this by passing the
target BPF endianness to the runqslower sub-make.

Fixes: 5a63c33d6f00 ("selftests/bpf: Support cross-endian building")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250125071423.2603588-1-itugrok@yahoo.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/runqslower/Makefile        | 3 ++-
 tools/testing/selftests/bpf/Makefile | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index e49203ebd48c1..78a436c4072e3 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -6,6 +6,7 @@ OUTPUT ?= $(abspath .output)/
 BPFTOOL_OUTPUT := $(OUTPUT)bpftool/
 DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)bootstrap/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
+BPF_TARGET_ENDIAN ?= --target=bpf
 LIBBPF_SRC := $(abspath ../../lib/bpf)
 BPFOBJ_OUTPUT := $(OUTPUT)libbpf/
 BPFOBJ := $(BPFOBJ_OUTPUT)libbpf.a
@@ -60,7 +61,7 @@ $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
 	$(QUIET_GEN)$(BPFTOOL) gen skeleton $< > $@
 
 $(OUTPUT)/%.bpf.o: %.bpf.c $(BPFOBJ) | $(OUTPUT)
-	$(QUIET_GEN)$(CLANG) -g -O2 --target=bpf $(INCLUDES)		      \
+	$(QUIET_GEN)$(CLANG) -g -O2 $(BPF_TARGET_ENDIAN) $(INCLUDES)	      \
 		 -c $(filter %.c,$^) -o $@ &&				      \
 	$(LLVM_STRIP) -g $@
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 87551628e1129..6722080b2107a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -306,6 +306,7 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL) $(RUNQSLOWER_OUTPUT)
 		    BPFTOOL_OUTPUT=$(HOST_BUILD_DIR)/bpftool/		       \
 		    BPFOBJ_OUTPUT=$(BUILD_DIR)/libbpf/			       \
 		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR)		       \
+		    BPF_TARGET_ENDIAN=$(BPF_TARGET_ENDIAN)		       \
 		    EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)' \
 		    EXTRA_LDFLAGS='$(SAN_LDFLAGS) $(EXTRA_LDFLAGS)' &&	       \
 		    cp $(RUNQSLOWER_OUTPUT)runqslower $@
-- 
2.39.5



