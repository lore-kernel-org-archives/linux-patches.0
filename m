Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87474335BAA;
	Mon, 18 Aug 2025 13:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524998; cv=none; b=CpDNfB/2R5I+MXNJChFdNUOWsEV5cf0rsc6BWbSs442O5NslM6T5VxoSwd3VPpb89rd6PQlCMkq6xSMyNSzVTfDWWYTzlCYW3nHD0gmmtFFWXcSBvCgtdRDoDpcvmDkJpWIXlN8oaMmXQYQD4h9Cj58G2SYGxUBi9UO9rulH82k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524998; c=relaxed/simple;
	bh=DF/wXXxk4HS2CJ0746B5dqldqu/gwCuO4zh+uyULRTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my0NXTex4YkSyWdYMHrRwgeYglSwF0Wj9nquifcdQRe3y8UR+pIt1E7/0WJkvTucwNeiRVtRQ9I+DpSbO9aoo9kqEiUE49FiOdk11EC3EjVF0M+zcgKxXRyxQ4QzC9dHhIeWnDV5v8+6lW8b622xxPf5FtjetdFnT6jB5uKHr88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/2Syavt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/2Syavt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CEDC4CEEB;
	Mon, 18 Aug 2025 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524998;
	bh=DF/wXXxk4HS2CJ0746B5dqldqu/gwCuO4zh+uyULRTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/2Syavte40qrFU08TXrmZs+ajF/GaP7Bi1RbS7GUlNNAk9c04QL8Y3I3HLhOlERA
	 wyRg/UzRp0MNLviIsai2SbHV2ccjBVWznPz7ZkPkOGoQ3FP306oFX9D/PayKm5zHr7
	 2IwvRELXw91PpbAiyEjtLoxw8oRLmay3IVTSXOpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 126/570] selftests/kexec: fix test_kexec_jump build
Date: Mon, 18 Aug 2025 14:41:53 +0200
Message-ID: <20250818124510.681001101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 661e9cd196598c7d2502260ebbe60970546cca35 ]

The test_kexec_jump program builds correctly when invoked from the top-level
selftests/Makefile, which explicitly sets the OUTPUT variable. However,
building directly in tools/testing/selftests/kexec fails with:

  make: *** No rule to make target '/test_kexec_jump', needed by 'test_kexec_jump.sh'.  Stop.

This failure occurs because the Makefile rule relies on $(OUTPUT), which is
undefined in direct builds.

Fix this by listing test_kexec_jump in TEST_GEN_PROGS, the standard way to
declare generated test binaries in the kselftest framework. This ensures the
binary is built regardless of invocation context and properly removed by
make clean.

Link: https://lore.kernel.org/r/20250702171704.22559-2-moonhee.lee.ca@gmail.com
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kexec/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kexec/Makefile b/tools/testing/selftests/kexec/Makefile
index e3000ccb9a5d..874cfdd3b75b 100644
--- a/tools/testing/selftests/kexec/Makefile
+++ b/tools/testing/selftests/kexec/Makefile
@@ -12,7 +12,7 @@ include ../../../scripts/Makefile.arch
 
 ifeq ($(IS_64_BIT)$(ARCH_PROCESSED),1x86)
 TEST_PROGS += test_kexec_jump.sh
-test_kexec_jump.sh: $(OUTPUT)/test_kexec_jump
+TEST_GEN_PROGS := test_kexec_jump
 endif
 
 include ../lib.mk
-- 
2.39.5



