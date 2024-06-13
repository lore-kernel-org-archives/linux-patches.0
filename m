Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF81411C5;
	Thu, 13 Jun 2024 12:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280989; cv=none; b=POGQ5662Tob2v74cPjKT2K72PZjvXgFt9h/Zg0sXWdDUkn39jxj0WY/zFBvxZjJGchHxOtK1kkgOhzXesrHSDhgnnDWfLFUPj17fZdBwHnoxUpcyN8p97luuux6jtx6fpwMjAgRomwS0Ryu42NCgBnyQbG0iJL8dSC9PNB83UGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280989; c=relaxed/simple;
	bh=cLHAOIpc1lPPQL324j/QceZ32RuPslCENC7bMRtOBRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSpZ2LamZqHG6mrGSufWNGISs83ddRGKqSfiA05MNaF9ggkxeDHDvkNekcdEY3pQ5XRCTquBbWWkZnWX4K9MLWkcVsDvZBvyQBM+Kr+cBJB+lCK4TfbNh07C4m1Gue+UJgZzUxmDjJV0Vv9owqTGIGduOHEXqANDkvznRzjvkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iikK6vE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iikK6vE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83198C2BBFC;
	Thu, 13 Jun 2024 12:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280988;
	bh=cLHAOIpc1lPPQL324j/QceZ32RuPslCENC7bMRtOBRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iikK6vEDwlUH0C/gUOLCaS2heT8YndWiDggFdLINnJ8mo9GrYipi6NzXmHgITV2e
	 7lEYKZ1siF7j9X7VR/jwRkqSt2y9ZXISAr3D3uhrKWevrBY0b6hUsS5lNe0ZEpPVqC
	 w2KPizPlLCBUaRQ3FE3JBX/wWo09hAf2Diiqwkrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/317] selftests/binderfs: use the Makefiles rules, not Makes implicit rules
Date: Thu, 13 Jun 2024 13:31:29 +0200
Message-ID: <20240613113250.295552755@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



