Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF5380FC7;
	Sat, 12 Sep 2026 08:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201296; cv=none; b=CmAzq1BoU21Zn4QGVbGQGz/T5Mc4e11rzKpmemJyRXa4+eWt50ITV15cE4m3FwuAZ4JAjoKGNnRRx6+aOuekmIgFwySwNazwpvC+Bv1M1G46qxOzdiHXlktrQj0ME7M9qdgIeE5ELp6zag5esE+93FCal4wkk7FFB2D0eB+Lzu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201296; c=relaxed/simple;
	bh=bFVW/RuIqqJ912UF9I/1n515OpJO2dZTtCasLs70rdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQmD32Yp4OBGXPXJoPI74ifDEBgq2pA6rYIuvGYn9s/2Y6Qiv1UIAq8wUP5WwVqhZ6fEJshi/TsMk/Dotc5MT2E3t0WJ9x44wSSFnzJYUxrDcOWvdWQKQDcktyU0VdrlJJH7lzQOw8JMplsNBE2jzTsrD3bdr7tQs7Pogxp5CaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YH78lAO6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YH78lAO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D52F1F000FF;
	Sat, 12 Sep 2026 08:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201294;
	bh=MaCrZFfsAEet04AtPnAGcMEa2DiyWpFEqD4vReca//4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YH78lAO66Pq+xsoZGhw3+KFUXvX3089IlnhgvXqlkqQSmc4GVKBNQhCRBZTPqZhyF
	 RObNx5z36gvhpvywxPJZfotqEEc7aGwrDzGnhRQngW7TnC731Z7UolRBVgX1z9USqM
	 EU1yBU4alXo54TFnnyJNY/TzFmOun0ZH4M3rtbbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0968/1815] perf build: Fix a build error on 32-bit x86
Date: Sat, 12 Sep 2026 08:45:18 +0200
Message-ID: <20260912065711.701024129@linuxfoundation.org>
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

[ Upstream commit dbd2505061349bbee9c3282472f14ae27da8adfd ]

The commit d7507a94a072 ("KVM: SVM: Treat exit_code as an unsigned
64-bit value through all of KVM") added "ull" suffix to SVM exit codes
and it makes the 32-bit build fail like below.

  In file included from util/kvm-stat-arch/kvm-stat-x86.c:4:
  util/kvm-stat-arch/../../../arch/x86/include/uapi/asm/svm.h:137:32:
             error: conversion from 'long long unsigned int' to 'long unsigned int' changes
                    value from '18446744073709551615' to '4294967295' [-Werror=overflow]
    137 | #define SVM_EXIT_ERR           -1ull
        |                                ^
  util/kvm-stat-arch/../kvm-stat.h:131:17: note: in definition of macro 'define_exit_reasons_table'
    131 |                 symbols, { -1, NULL }                   \
        |                 ^~~~~~~
  util/kvm-stat-arch/../../../arch/x86/include/uapi/asm/svm.h:249:11: note: in expansion of macro 'SVM_EXIT_ERR'
    249 |         { SVM_EXIT_ERR,         "invalid_guest_state" }
        |           ^~~~~~~~~~~~
  util/kvm-stat-arch/kvm-stat-x86.c:12:45: note: in expansion of macro 'SVM_EXIT_REASONS'
     12 | define_exit_reasons_table(svm_exit_reasons, SVM_EXIT_REASONS);
        |                                             ^~~~~~~~~~~~~~~~

As the exit_code was unsigned long, the compiler complained about the
truncation.  Let's convert it to u64 to suppress the error.

Fixes: fac520e43a60 ("tools headers: Sync KVM headers with the kernel sources")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/kvm-stat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index cdbd921a555f4..104f59262ec90 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -69,7 +69,7 @@ struct kvm_events_ops {
 };
 
 struct exit_reasons_table {
-	unsigned long exit_code;
+	u64 exit_code;
 	const char *reason;
 };
 
-- 
2.53.0



