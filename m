Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA06346AE3;
	Sat, 12 Sep 2026 07:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199081; cv=none; b=T328qn64HiBQS701jwwUNFdtrPHFqokZEYBOyqf7YDTRRcNvLS0Gvll5sCBSp5AnX+skjaNJSgmPn64L3D1YgGnO/iQlqbgcvtGiKCT4l6eJlyJRevmKLtBQDxjiKWZcNhOj6rLjodzmPQnjhBTiZ8T+Ftrws8JznSkldluqs2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199081; c=relaxed/simple;
	bh=ZxRWvEbBt35rYvemaWV3B/h8wnKgziyYDqkpXYVCRPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ3bYp+DNxHIOoUc2XIEN2DKrUqYRja8WDRyLxzIbiuoMR/EvmXUsSZ9b4TN++ddr/W+0ykpef6GC+O6JY5iGzgMZ/Fg9C03RblTxrcAcSCdryEkNg6yiEOlxw0csZTbMNIeQ28sEnfb1iHAjHpB7zX5eZ4ujdu5PbYbs7w7mKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML0PaYpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML0PaYpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70B1F000FF;
	Sat, 12 Sep 2026 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199080;
	bh=fy7gM+QNH9JoHdOSSj1VBdQLJpbhxG4jbiLJeFIKD+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML0PaYpH5sixlwupiT9a2cpPupAUiDZPEEKAOxLEJZRUWUMX47shyDWWz5VekbGQo
	 AY4XrDU2gbe1W1iVn2UKzypOrMbWl7ctqTh2+0s43aY5+EBbvHrRJL+wiyoGNSN+sQ
	 kWDvm0sWbTD8Y0ChZdLiR2kBXThlmPohdv//l5gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0513/1815] perf build: Fix compiler errors with old capstone
Date: Sat, 12 Sep 2026 08:37:43 +0200
Message-ID: <20260912065700.932392302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e01c7bd5b1eece254bcbf282db066b12c4815d21 ]

It seems RISCV was added in capstone version 5 (released Jul 2023).
Unfortunately they are enum constants so cannot check with #ifdef but
anyway we can define the symbols.  Let's do it using the version
number to avoid build errors.  It'll fail at runtime though.

  util/capstone.c: In function 'e_machine_to_capstone':
  util/capstone.c:186:25: error: 'CS_ARCH_RISCV' undeclared (first use in this function);
                                  did you mean 'CS_ARCH_SYSZ'?
    186 |                 *arch = CS_ARCH_RISCV;
        |                         ^~~~~~~~~~~~~
        |                         CS_ARCH_SYSZ
  util/capstone.c:186:25: note: each undeclared identifier is reported only once for each function it appears in

  util/capstone.c:187:34: error: 'CS_MODE_RISCV64' undeclared (first use in this function);
                                  did you mean 'CS_MODE_MIPS64'?
    187 |                 *mode |= (is64 ? CS_MODE_RISCV64 : CS_MODE_RISCV32) | CS_MODE_RISCVC;
        |                                  ^~~~~~~~~~~~~~~
        |                                  CS_MODE_MIPS64

Also note that capstone renamed CS_MODE_RISCVC to CS_MODE_RISCV_C which
would cause a different build failure on latest versions.  It's reported
in https://github.com/capstone-engine/capstone/issues/2977 so I think
they will add compatibility layer to prevent the error.

Fixes: 12c4737f55f2 ("perf capstone: Determine architecture from e_machine")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/capstone.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/capstone.c b/tools/perf/util/capstone.c
index 9bba78ee0c5a2..00e0141cae8db 100644
--- a/tools/perf/util/capstone.c
+++ b/tools/perf/util/capstone.c
@@ -24,6 +24,13 @@
 #include "symbol.h"
 #include "thread.h"
 
+#if CS_VERSION_MAJOR < 5
+#define CS_ARCH_RISCV    15
+#define CS_MODE_RISCV32  1
+#define CS_MODE_RISCV64  2
+#define CS_MODE_RISCVC   4
+#endif
+
 #ifdef LIBCAPSTONE_DLOPEN
 static void *perf_cs_dll_handle(void)
 {
-- 
2.53.0



