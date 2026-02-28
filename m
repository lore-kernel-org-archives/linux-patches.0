Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A480325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300965; cv=none; b=EQZzlTmnYcTRI3o4oXTX1St7w7S6n/G6ZlBJCy+RbPQ/NnvdjInDli3oTi+kKjSW6UuWyj5QMhvenbDxKiZdRAn7vkaIeTqr1kZGz5m7M3kJjkr9fjmLIY18rjXtZvaEt9Hd9DyR5ap0eKa8FhLVAMTCjJ9A707I2vVPJceCplk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300965; c=relaxed/simple;
	bh=+0OZ4Xt0+oMZkYhCQdgbJCd7KFQ+4WN56/lDtbzBgUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAiBdbLQtDxwG/eNHfB+dGvwnhSGJv2QzFmAUrHMyQp+RU46x4rsCQ0qSIYQhRSVKD6aBVBQy1pydV8Bqv6f7c3fapHSsah+klOwyC2U9CTwuEYgJqYHxjNT4Ka2QQHiTMxe0nF/8jtmXduz7tt5s+HAzLAPQMpzFxhWDuly9kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuTV6Rsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuTV6Rsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095DAC19423;
	Sat, 28 Feb 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300965;
	bh=+0OZ4Xt0+oMZkYhCQdgbJCd7KFQ+4WN56/lDtbzBgUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuTV6Rspjjo7NK39pebB+8naS/6MZAEAMnyvheTek/9K3O+LKORs5hjH+Fl/TifFj
	 nNQW1qOZXbxylrQPM668SKXEXl7zfCGRnLscxKgs9OgQzM2RGVk94hUjbjAR2d4Pi4
	 222ePp8iW4f/sHn9Zmz+gwxIZax4iJD/bFX5xn70uJD6Ka38zHXKM+i94BtkbcjKtv
	 QuOQIecGt7OvZvX7j7c/KoS6mr3tOgv5hHj1tCVupFU2XphOypsRs55fE6p+WuLYHj
	 AWvy1eFJEd13i1g02SeAKLCyukXVOY+zHRfwdjjkta00cYmpJ0TTul9cHnqC9Y9Daf
	 hIeMekgn3NYqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/752] bpftool: Fix dependencies for static build
Date: Sat, 28 Feb 2026 12:36:42 -0500
Message-ID: <20260228174750.1542406-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 08a7491843224f8b96518fbe70d9e48163046054 ]

When building selftests/bpf with EXTRA_LDFLAGS=-static the follwoing
error happens:

  LINK    /ws/linux/tools/testing/selftests/bpf/tools/build/bpftool/bootstrap/bpftool
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-dso_dlfcn.o): in function `dlfcn_globallookup':
   [...]
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-c_zlib.o): in function `zlib_oneshot_expand_block':
(.text+0xc64): undefined reference to `uncompress'
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-c_zlib.o): in function `zlib_oneshot_compress_block':
(.text+0xce4): undefined reference to `compress'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:252: /ws/linux/tools/testing/selftests/bpf/tools/build/bpftool/bootstrap/bpftool] Error 1
make: *** [Makefile:327: /ws/linux/tools/testing/selftests/bpf/tools/sbin/bpftool] Error 2
make: *** Waiting for unfinished jobs....

This is caused by wrong order of dependencies in the Makefile. Fix it.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260128211255.376933-1-ihor.solodrai@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 586d1b2595d16..fd43e5ea63f38 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -130,8 +130,8 @@ include $(FEATURES_DUMP)
 endif
 endif
 
-LIBS = $(LIBBPF) -lelf -lz -lcrypto
-LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lz -lcrypto
+LIBS = $(LIBBPF) -lelf -lcrypto -lz
+LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lcrypto -lz
 
 ifeq ($(feature-libelf-zstd),1)
 LIBS += -lzstd
-- 
2.51.0

