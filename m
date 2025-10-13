Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A196C3081C1;
	Mon, 13 Oct 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369232; cv=none; b=oHup0cmX4oKm5jarSrHso9izjty3D02n/F2yxWpeHmItbXDwYsZTvyuyhPuv93wMLetl6NBBSXQ9tynvyDyPKr5X7oLeiYqdEzcrppH152P9LIfORC0pP6fyIY0gwKiMWRpdXlHtse7R+gojWuJRFF1aw04ZRxmrJF6CtWWl7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369232; c=relaxed/simple;
	bh=gF0q5RDj26N0DLMo5gH3q2j4qtOdYkBeqmDTzhLb/H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FN0wCY4/KfdctDupUcRcrTi8lbiw9zm47lfyToh6Ha1xgbD0IINshMZoXHfR5RaJYuaVgJtWnIcBv+wH/uLjdgsp/c3tS+rg3NiVzFI/qJLhuZqVZdwhvB9RklZXdC7mDv8zo3IogXExrXEiAFPY+GoWUc0PWAqVTgoLZ2GxKIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgO4xwZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgO4xwZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEBBC4CEE7;
	Mon, 13 Oct 2025 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369232;
	bh=gF0q5RDj26N0DLMo5gH3q2j4qtOdYkBeqmDTzhLb/H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgO4xwZFQco+8JmJBtldTT293Q2rwJaBONNigTjmDXGRVWZ4IuBBoFX0PSW2uHnRZ
	 2QKWiNPmUmrI98VSZqS0zSa2X3d24HwFQXqva+gMN6bjgpfemrneNQ7Lb4X+dsX+dv
	 2uRDhqDrcv9eWkPzeQwu4VPbG/zWcufMrA11STK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 175/563] selftests/futex: Fix futex_wait() for 32bit ARM
Date: Mon, 13 Oct 2025 16:40:36 +0200
Message-ID: <20251013144417.626205240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 237bfb76c90b184f57bb18fe35ff366c19393dc8 ]

On 32bit ARM systems gcc-12 will use 32bit timestamps while gcc-13 and later
will use 64bit timestamps.  The problem is that SYS_futex will continue
pointing at the 32bit system call.  This makes the futex_wait test fail like
this:

  waiter failed errno 110
  not ok 1 futex_wake private returned: 0 Success
  waiter failed errno 110
  not ok 2 futex_wake shared (page anon) returned: 0 Success
  waiter failed errno 110
  not ok 3 futex_wake shared (file backed) returned: 0 Success

Instead of compiling differently depending on the gcc version, use the
-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 options to ensure that 64bit timestamps
are used.  Then use ifdefs to make SYS_futex point to the 64bit system call.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/20250827130011.677600-6-bigeasy@linutronix.de
Stable-dep-of: ed323aeda5e0 ("selftest/futex: Compile also with libnuma < 2.0.16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/Makefile |  2 +-
 tools/testing/selftests/futex/include/futextest.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 8cfb87f7f7c50..ddfa61d857b9b 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 INCLUDES := -I../include -I../../ $(KHDR_INCLUDES)
-CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread $(INCLUDES) $(KHDR_INCLUDES)
+CFLAGS := $(CFLAGS) -g -O2 -Wall -pthread -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 $(INCLUDES) $(KHDR_INCLUDES)
 LDLIBS := -lpthread -lrt -lnuma
 
 LOCAL_HDRS := \
diff --git a/tools/testing/selftests/futex/include/futextest.h b/tools/testing/selftests/futex/include/futextest.h
index 7a5fd1d5355e7..3d48e9789d9fe 100644
--- a/tools/testing/selftests/futex/include/futextest.h
+++ b/tools/testing/selftests/futex/include/futextest.h
@@ -58,6 +58,17 @@ typedef volatile u_int32_t futex_t;
 #define SYS_futex SYS_futex_time64
 #endif
 
+/*
+ * On 32bit systems if we use "-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64" or if
+ * we are using a newer compiler then the size of the timestamps will be 64bit,
+ * however, the SYS_futex will still point to the 32bit futex system call.
+ */
+#if __SIZEOF_POINTER__ == 4 && defined(SYS_futex_time64) && \
+	defined(_TIME_BITS) && _TIME_BITS == 64
+# undef SYS_futex
+# define SYS_futex SYS_futex_time64
+#endif
+
 /**
  * futex() - SYS_futex syscall wrapper
  * @uaddr:	address of first futex
-- 
2.51.0



