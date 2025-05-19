Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241D226D03;
	Mon, 19 May 2025 21:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689737; cv=none; b=Sq+Yx4JEi10ux/QaEWuXjA9excXgfXbIelyIoHx6bCp39ubaUJfNIdO2jlcC9U1yMk31NQzz3bC/uVMUoUME9qaCLBoRj44blPqRKhoORUmTjsEdmLOyRKjuvFUQnEKbWWlbqHXsVTUX+12MNIqlh9HE4SO1eccd2B6KGGb6uT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689737; c=relaxed/simple;
	bh=1fJVId28LO8VYcmUKnPr0/4A/64dGWmqoZ8gpVd+k8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hzWzD/kpNUM1WFdBV1ir9Zt8ITVHpSmYlnoGM/SP6jw+hEzxNgUbBsO3HKuKQdhaii1hQkV9JMg1YUAJix8fx0oV5ZfJIX06Fl511pddfjx1AvxQOjLhsN2AyUqEljFbaRMRYOap2Uz314dwrQgXiIhwLJo/GwQ1oh3sDNOPloY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OqiJAmx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OqiJAmx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525FAC4CEEB;
	Mon, 19 May 2025 21:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689736;
	bh=1fJVId28LO8VYcmUKnPr0/4A/64dGWmqoZ8gpVd+k8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqiJAmx707UF1wWAbKx1GvcvYiPhyNmAqVaTKff1lzbS+TM1MOysSu3dM2S9wJFC2
	 +AOaoSL2ai8o3qGbZ8vjhkW/GA1Rkac4i7z4QoJXsnHMMlXUd9NpHY5aT3Dj5j1gH7
	 K2v4rC1qRi7APzX8CZPQ+Oii6U16TtphlDFPfOFTAPUzaQCFkD9ESR1NL2SYoaTH1y
	 Y1XnnVMOaVzCvhCbjJLiqY/WlRxGqTxRI+WWunDG+ubqMzzSTTyjjJLTzXYUj3O0Hi
	 7FrYWecsgWSkhEF7vu01i/bUPYFUJiiH3cOBM1h3ueO5F/yH0eYIFmqLsGs6+xuzUr
	 SEXGNVP6LBXkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>,
	jdike@addtoit.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 05/18] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:21:54 -0400
Message-Id: <20250519212208.1986028-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212208.1986028-1-sashal@kernel.org>
References: <20250519212208.1986028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.29
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit ab09da75700e9d25c7dfbc7f7934920beb5e39b9 ]

Building the kernel with O= is affected by stale in-tree build artifacts.

So, if the source tree is not clean, Kbuild displays the following:

  $ make ARCH=um O=build defconfig
  make[1]: Entering directory '/.../linux/build'
  ***
  *** The source tree is not clean, please run 'make ARCH=um mrproper'
  *** in /.../linux
  ***
  make[2]: *** [/.../linux/Makefile:673: outputmakefile] Error 1
  make[1]: *** [/.../linux/Makefile:248: __sub-make] Error 2
  make[1]: Leaving directory '/.../linux/build'
  make: *** [Makefile:248: __sub-make] Error 2

Usually, running 'make mrproper' is sufficient for cleaning the source
tree for out-of-tree builds.

However, building UML generates build artifacts not only in arch/um/,
but also in the SUBARCH directory (i.e., arch/x86/). If in-tree stale
files remain under arch/x86/, Kbuild will reuse them instead of creating
new ones under the specified build directory.

This commit makes 'make ARCH=um clean' recurse into the SUBARCH directory.

Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Closes: https://lore.kernel.org/lkml/20250502172459.14175-1-skhan@linuxfoundation.org/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 00b63bac5effb..3317d87e20920 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -151,5 +151,6 @@ MRPROPER_FILES += $(HOST_DIR)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING DEV_NULL_PATH
-- 
2.39.5

