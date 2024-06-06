Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4614B197A8F;
	Thu,  6 Jun 2024 14:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683279; cv=none; b=WYvcRXsFELfdShw5COWFkyBllDTY0tjUF04MzUUfP3TsKhQfTC0bK96m79KaEzMVaOIjcPTQIUWJqKVdwoJsE7YIAi53L7cqB6St1IoEvcP6i0W5+SmbAQP6Y/UTEgNtwrpjr3u2VvTMYbgwTRDV/ZCadRqKIXAqE8QooAoGvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683279; c=relaxed/simple;
	bh=/Vmpp4NsZgYAiriYCj4X+9R47M5ikhOW4KLcFH9KMo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQoGe6Iq6ctT11XnkZ9Z49ic0Mr4vexoiGbahvtvel6G84XynrfUw/xtxjuYrt6VPRJfawUqfGVh9h/t94rh5o1ZUhpbQnjRhRXOpRLT/DsSUqHEeRuM/3TP3T+A3KfHs24rqMkDIPtq3ewahjR44o31r19hWbuV6xgoPiFIbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLVUL8hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLVUL8hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209E0C32781;
	Thu,  6 Jun 2024 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683279;
	bh=/Vmpp4NsZgYAiriYCj4X+9R47M5ikhOW4KLcFH9KMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLVUL8hqo7Cecr4yR97NztvFZ0QMwAr6FCmuM3HptMUy70C2P0YkeQuhuW4eOT/hb
	 xHqjFK0C7y9k6VJIRY1wMS499uY7ZWbgQJyawkG4D4RVhZxlOz4pJtTB3VsiPxuaU4
	 KHTllwYb5Im4nwDFKVDrWm3C6lFT4c0FaW8v9lRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/744] selftests/resctrl: fix clang build failure: use LOCAL_HDRS
Date: Thu,  6 Jun 2024 15:58:13 +0200
Message-ID: <20240606131739.480727414@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit d8171aa4ca72f1a67bf3c14c59441d63c1d2585f ]

First of all, in order to build with clang at all, one must first apply
Valentin Obst's build fix for LLVM [1]. Once that is done, then when
building with clang, via:

    make LLVM=1 -C tools/testing/selftests

...the following error occurs:

   clang: error: cannot specify -o when generating multiple output files

This is because clang, unlike gcc, won't accept invocations of this
form:

    clang file1.c header2.h

Fix this by using selftests/lib.mk facilities for tracking local header
file dependencies: add them to LOCAL_HDRS, leaving only the .c files to
be passed to the compiler.

[1] https://lore.kernel.org/all/20240329-selftests-libmk-llvm-rfc-v1-1-2f9ed7d1c49f@valentinobst.de/

Fixes: 8e289f454289 ("selftests/resctrl: Add resctrl.h into build deps")
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 2deac2031de9e..021863f86053a 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -5,6 +5,8 @@ CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
 
+LOCAL_HDRS += $(wildcard *.h)
+
 include ../lib.mk
 
-$(OUTPUT)/resctrl_tests: $(wildcard *.[ch])
+$(OUTPUT)/resctrl_tests: $(wildcard *.c)
-- 
2.43.0



