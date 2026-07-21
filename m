Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD4446A5E2;
	Tue, 21 Jul 2026 15:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648588; cv=none; b=exICGC2ToIs1++A3sHXKMTd+eJMGQophCf3zk5F8RKSbJjDZSvV1Vxasr7K0zdQWYaPikZmeGeBwXv4PzkSmrVZ6KSZg0cYCt/LyC6j9Tq8OqT/47BVLE1TB3YsDZM5gQTS9cHmYHbM5jflvHdTL2Au5eF9LAbylnn0EwjCAh68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648588; c=relaxed/simple;
	bh=ucwsGJIkdZIumxbHk+qEFXGYYw2PHBMEYE/giMXVuPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfxYY35ssxddPyEEB3vsgPZsgx7CSi8BIIUegdGIJcWXVeqP44b7xWkI+W/2A50Rti5qmvaSfY135tyJ1M9oUAGEHdkpqPwIHZaKc3A8wJNydn4UqXpPgX5i7euDKs80TZ4JZozBtfvyvIcodgDqrtoKHnsUZb7B2Eed8RpWmKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3PkNe/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3PkNe/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABF1F00A3A;
	Tue, 21 Jul 2026 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648587;
	bh=cWQ8c6P5by0wPYTQiUVeCtWVzETR7ppEipuDw0sCUzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3PkNe/R1TqkFa9iG6PTyHoZpnsN7fSFHgO84hs5Twx8yjJ/LJOHHodIBNNsxvfJP
	 1n9Kf/ktTl40SYYJpi+3ZV7ZM97vVJgQPeDdLVh5/Vxz5dKoPrA4nl+gUz/0wGo1iH
	 bYRyBkSjCXFAlG+wIQU1oOZTs7ntFiNjCiYPSmyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0255/2077] vfio: selftests: Fix out-of-tree build with make O=
Date: Tue, 21 Jul 2026 16:58:48 +0200
Message-ID: <20260721152558.694887974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit a21b864bd951e452922dbd66747da24daca2b04f ]

The test programs are compiled via a static pattern rule that requires
intermediate .o files:

  $(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)

After lib.mk prefixes TEST_GEN_PROGS with $(OUTPUT), this creates
dependencies on .o files in the output directory (e.g.
$(OUTPUT)/vfio_dma_mapping_test.o). However, there is no rule to compile
these .o files from the source directory .c files when OUTPUT differs
from the source directory.

Add an explicit chain of pattern rules:
  $(OUTPUT)/% -> $(OUTPUT)/%.o -> %.c

Following the same pattern already used in libvfio.mk for the library
objects.

Fixes: 19faf6fd969c ("vfio: selftests: Add a helper library for VFIO selftests")
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v2-4ccc247e6aff+1d93-vfio_st_make_o_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vfio/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 0684932d91bfcb..a19b75742342ad 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -27,10 +27,13 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
+$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
+$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
 TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
 -include $(TEST_DEP_FILES)
 
-- 
2.53.0



