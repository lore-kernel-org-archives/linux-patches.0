Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C689369D78;
	Wed, 20 May 2026 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296014; cv=none; b=s0F2g1zlQUNt40+u4HqvNr1Qr6wBMTSUbor5U/blZ3VM2kkpqnvYVrVPwSvoECp/LoZn8Rd2f6vuhS/imynkgEGjn+a9AONiYJ6aymYI0Lh9tfsf54ZqKZt24naDvDuWR3EZSSYVnN0wI+smeNvmstiG8Vf5HvTieonQsbDVSNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296014; c=relaxed/simple;
	bh=2jWRhAqVQsO/7jqko0NmOVrUx9Yf181vyBWw29DiUk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgsuB9NpA+ggdHHs4AeVMO7oaUJoarpqgXGSa7nBOcbmi6Q3GNJ95hdNbJucOvjaCL7vnBVILAwqSvHPEWgtckiiqGhWoiJWRYOO2E9dRbJEAL4zU7iFunLPAzbxOTHFMMk4HcTRSIZifyY42ooG3QDp0fzVnwgriKJHoiPJaVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hvr1vZd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hvr1vZd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817B21F000E9;
	Wed, 20 May 2026 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296013;
	bh=6Y96eFEnwi8rw/qPCdh2PmMq6iSngafWUAoNaBJDav4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hvr1vZd5silpUyIv6CKWcCRCp/UCKrZCiRstztJcNJTtjJvU/qDHKxY/81tKI/u6/
	 Qt4TG+9UHcuSPQLNXacdxkIrgh3bJSVKCsERQbLqTcVBlHg8LXkxbN2yQz48CeRRDu
	 Ui0HBoxEawtOLQKo6Rt6zqXpOs+Sc8Kx4wR9WVko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0637/1146] tools build: Correct link flags for libopenssl
Date: Wed, 20 May 2026 18:14:47 +0200
Message-ID: <20260520162202.599287427@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 5c980ab238c8a9e2b24221603f11eadc98a7f45e ]

The perf static build reports that the BPF skeleton is disabled due to
the missing libopenssl feature.

Use PKG_CONFIG to determine the link flags for libopenssl.  Add
"--static" to the PKG_CONFIG command for static linking.

Fixes: 7678523109d1 ("tools/build: Add a feature test for libopenssl")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/Makefile | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 1fbcb3ce74d21..f163a245837a6 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -103,12 +103,18 @@ else
   endif
 endif
 
+ifeq ($(findstring -static,${LDFLAGS}),-static)
+  PKG_CONFIG += --static
+endif
+
 all: $(FILES)
 
 __BUILD = $(CC) $(CFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.c,$(@F)) $(LDFLAGS)
   BUILD = $(__BUILD) > $(@:.bin=.make.output) 2>&1
   BUILD_BFD = $(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
-  BUILD_ALL = $(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -lslang $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -ldl -lz -llzma -lzstd -lssl
+  BUILD_ALL = $(BUILD) -fstack-protector-all -O2 -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -lslang \
+	      $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -ldl -lz -llzma -lzstd \
+	      $(shell $(PKG_CONFIG) --libs --cflags openssl 2>/dev/null)
 
 __BUILDXX = $(CXX) $(CXXFLAGS) -MD -Wall -Werror -o $@ $(patsubst %.bin,%.cpp,$(@F)) $(LDFLAGS)
   BUILDXX = $(__BUILDXX) > $(@:.bin=.make.output) 2>&1
@@ -384,7 +390,7 @@ $(OUTPUT)test-libpfm4.bin:
 	$(BUILD) -lpfm
 
 $(OUTPUT)test-libopenssl.bin:
-	$(BUILD) -lssl
+	$(BUILD) $(shell $(PKG_CONFIG) --libs --cflags openssl 2>/dev/null)
 
 $(OUTPUT)test-bpftool-skeletons.bin:
 	$(SYSTEM_BPFTOOL) version | grep '^features:.*skeletons' \
-- 
2.53.0



