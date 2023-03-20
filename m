Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858011C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061D2C433D2;
	Mon, 20 Mar 2023 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325133;
	bh=OQzblPpPsKs2I7b2Fr4Fe9jN73W2mnjDF9LAtJj41zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLxBnw8t8RWFrrVi1jXcTThADi2EgHj7aXvcI0W0GyNMRJjjw2Wh+V8oYZbqvqHZQ
	 tr0oM73vIxsJVVWcOM7WmDqjLvAAnnCHA7D160e37k6tjiC6QnFRpYub/Zz29atlZY
	 ChuG9ikZRZsLuvIvuEdcRjbgn1tC5QIO284qqPIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Tucker <guillaume.tucker@collabora.com>,
	Huang Rui <ray.huang@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 009/211] selftests: amd-pstate: fix TEST_FILES
Date: Mon, 20 Mar 2023 15:52:24 +0100
Message-Id: <20230320145513.696272943@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 2da789cda462bda93679f53ee38f9aa2309d47e8 ]

Bring back the Python scripts that were initially added with
TEST_GEN_FILES but now with TEST_FILES to avoid having them deleted
when doing a clean.  Also fix the way the architecture is being
determined as they should also be installed when ARCH=x86_64 is
provided explicitly.  Then also append extra files to TEST_FILES and
TEST_PROGS with += so they don't get discarded.

Fixes: ba2d788aa873 ("selftests: amd-pstate: Trigger tbench benchmark and test cpus")
Fixes: a49fb7218ed8 ("selftests: amd-pstate: Don't delete source files via Makefile")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/amd-pstate/Makefile | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/amd-pstate/Makefile b/tools/testing/selftests/amd-pstate/Makefile
index 5fd1424db37d8..c382f579fe94a 100644
--- a/tools/testing/selftests/amd-pstate/Makefile
+++ b/tools/testing/selftests/amd-pstate/Makefile
@@ -4,10 +4,15 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-TEST_PROGS := run.sh
-TEST_FILES := basic.sh tbench.sh gitsource.sh
+ifeq (x86,$(ARCH))
+TEST_FILES += ../../../power/x86/amd_pstate_tracer/amd_pstate_trace.py
+TEST_FILES += ../../../power/x86/intel_pstate_tracer/intel_pstate_tracer.py
+endif
+
+TEST_PROGS += run.sh
+TEST_FILES += basic.sh tbench.sh gitsource.sh
 
 include ../lib.mk
-- 
2.39.2



