Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB22144C4;
	Thu, 12 Dec 2024 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023149; cv=none; b=ASVAERi60T8O73RZ7rc5zvEUt0YDIe3jzhqR8NiZaVk/fWhRNtO2Tcm8YW8oqPngvB/MXJwvaVargzwI7u1/VQ9heeISZjnpY4w+mNVYGj0cCgP3sqwKCwT6g/SCvmYMz/jWYN3glU7Rl+/RiL97lXk1NdcnNWaaU6UItrjnbbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023149; c=relaxed/simple;
	bh=HZCkwDR9dvV74Kr5mhlUoUKhZLdcjYb59doHeFLib8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8AbCsflkMKGCGvc7zcFb7iJLew9NCuop3aUakxDeqpRl5PhA+wv55jkOExX2GahUz4h/7llZwM71p4/iefyxETyDW1f2nasH3Sgurhtx6OzRlQLMnY2obIa+9F1g0y9B/Cm5sthhUJtfZukmsjkGASFvE6fRNgPc/Uj2SOOR9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzUOtaih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzUOtaih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D94C4CECE;
	Thu, 12 Dec 2024 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023149;
	bh=HZCkwDR9dvV74Kr5mhlUoUKhZLdcjYb59doHeFLib8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzUOtaihrmyqPe7Yktim7PEzLjWHlxDMcpKh4jc2Ck5d0yTUjkENCA9j8fOpmdr8h
	 1mhS+7gagGIrGgXCJE2dAXrgV8DSzlehHTqXBJPhiXv8iReD2tpud9Aj+JaGT4f8mI
	 I5MjnGfhts1GWdoByaoCpQiUmVXprULZrXoepRHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Quentin Monnet <qmo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/565] tools: Override makefile ARCH variable if defined, but empty
Date: Thu, 12 Dec 2024 16:00:34 +0100
Message-ID: <20241212144329.036861769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit 537a2525eaf76ea9b0dca62b994500d8670b39d5 ]

There are a number of tools (bpftool, selftests), that require a
"bootstrap" build. Here, a bootstrap build is a build host variant of
a target. E.g., assume that you're performing a bpftool cross-build on
x86 to riscv, a bootstrap build would then be an x86 variant of
bpftool. The typical way to perform the host build variant, is to pass
"ARCH=" in a sub-make. However, if a variable has been set with a
command argument, then ordinary assignments in the makefile are
ignored.

This side-effect results in that ARCH, and variables depending on ARCH
are not set. Workaround by overriding ARCH to the host arch, if ARCH
is empty.

Fixes: 8859b0da5aac ("tools/bpftool: Fix cross-build")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Quentin Monnet <qmo@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/bpf/20241127101748.165693-1-bjorn@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/scripts/Makefile.arch | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/scripts/Makefile.arch b/tools/scripts/Makefile.arch
index b10b7a27c33fd..de3f2806b8a89 100644
--- a/tools/scripts/Makefile.arch
+++ b/tools/scripts/Makefile.arch
@@ -6,8 +6,8 @@ HOSTARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
                                   -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 
-ifndef ARCH
-ARCH := $(HOSTARCH)
+ifeq ($(strip $(ARCH)),)
+override ARCH := $(HOSTARCH)
 endif
 
 SRCARCH := $(ARCH)
-- 
2.43.0



