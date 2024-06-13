Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029CF17FD;
	Thu, 13 Jun 2024 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281910; cv=none; b=HiXl0wBPxv7E71goCbJa/yYXAw/CV6l7//Zi9Lhhtf6sa6qNOP3oEpHWzCkkAHl8brOK7pTctBNf3OHnPjh8ARGk8GOoB3oFxj+RqD+bNHe9eWstAfp/1wDmoemk1LrQGHZw2bXPiQ4GeDJFyFXeBg5WmUpK26oBTc0pm//FpNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281910; c=relaxed/simple;
	bh=EVpGUnnyTgQb0u5y/vw4uKXG88dxr7EcqVOG5iI6klY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfsv+0MZ8xdy2a9J+9Uk9nejS/ZNSZvTPePZqIWkug0DdAoIZkNzOmn3Hka9nHwSVA5u/QRTUUaff35NJ3GfaVbx7cXWyHvzt+vCX5vIAgI8UOV4zSyE65yKM/exgSy/qcO9GTBAjTu3nl7JBaMx+vA1i8+3a3419jLd2+W+FNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZXq5iei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZXq5iei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C07EC2BBFC;
	Thu, 13 Jun 2024 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281909;
	bh=EVpGUnnyTgQb0u5y/vw4uKXG88dxr7EcqVOG5iI6klY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZXq5iein7usbdxiWmbxpyzttLGXhvRI3XBXfhUaDCxhf1o+fZRv4psVQUPEuLOaM
	 jlu/ZX0XTOGmZumPJsowcL9+1lKHFEkZR70fKsWJvoYPCOzLgOdP/z+/riZ86l2I6h
	 uHQgKMSiVMumtqoFBTmvA4vV5ojtP85CB3WciXFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/402] selftests/binderfs: use the Makefiles rules, not Makes implicit rules
Date: Thu, 13 Jun 2024 13:30:55 +0200
Message-ID: <20240613113305.960949124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 019baf635eb6ffe8d6c1343f81788f02a7e0ed98 ]

First of all, in order to build with clang at all, one must first apply
Valentin Obst's build fix for LLVM [1]. Once that is done, then when
building with clang, via:

    make LLVM=1 -C tools/testing/selftests

...the following error occurs:

   clang: error: cannot specify -o when generating multiple output files

This is because clang, unlike gcc, won't accept invocations of this
form:

    clang file1.c header2.h

While trying to fix this, I noticed that:

a) selftests/lib.mk already avoids the problem, and

b) The binderfs Makefile indavertently bypasses the selftests/lib.mk
build system, and quitely uses Make's implicit build rules for .c files
instead.

The Makefile attempts to set up both a dependency and a source file,
neither of which was needed, because lib.mk is able to automatically
handle both. This line:

    binderfs_test: binderfs_test.c

...causes Make's implicit rules to run, which builds binderfs_test
without ever looking at lib.mk.

Fix this by simply deleting the "binderfs_test:" Makefile target and
letting lib.mk handle it instead.

[1] https://lore.kernel.org/all/20240329-selftests-libmk-llvm-rfc-v1-1-2f9ed7d1c49f@valentinobst.de/

Fixes: 6e29225af902 ("binderfs: port tests to test harness infrastructure")
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/binderfs/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/filesystems/binderfs/Makefile b/tools/testing/selftests/filesystems/binderfs/Makefile
index 8af25ae960498..24d8910c7ab58 100644
--- a/tools/testing/selftests/filesystems/binderfs/Makefile
+++ b/tools/testing/selftests/filesystems/binderfs/Makefile
@@ -3,6 +3,4 @@
 CFLAGS += -I../../../../../usr/include/ -pthread
 TEST_GEN_PROGS := binderfs_test
 
-binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
-
 include ../../lib.mk
-- 
2.43.0



