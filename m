Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C000216606;
	Thu, 12 Dec 2024 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016100; cv=none; b=VBrLAdZKWTz6580rJfbF7ffELnyuMmoDko6P0QTu1pGwqTp9THWjo7hEC5zT+L+AjH+e+LgTlFxfBKwwiXQ22dl0/W8+RqbegmK/gxEOo4Z8trT8KGeGEpzHtMD/P+XzHL6LElERPGrP2+G56QBG3tLEos7Dcn0GK7Eml9Us2UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016100; c=relaxed/simple;
	bh=wlwqMY4kB3ScDh2YT3T0tfW8Tx2fn2/Ty9vH+1pR5V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4QKwP61ftYrC79UXpf9GygLgEj9D787DdGjhQcVaLDUyk/DGBtlycbMBge45VnE0Y3lZ9X6NhX94YMvwzkhivihW3LeXphGVmmm/MmUMRwTP+KcD83q1ihsYCXxGZ6GEUxgy+oJGkG4/DqqYSoHlln/kClKT7eyfVh5pKnzajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUgJpYzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUgJpYzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E548C4CECE;
	Thu, 12 Dec 2024 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016097;
	bh=wlwqMY4kB3ScDh2YT3T0tfW8Tx2fn2/Ty9vH+1pR5V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUgJpYzC5sVoUGfK/wqIxu+nBgKLj6pZoYYcZpA+MewDRqY4pS/UI3vQ906wNXHka
	 rMtIzjolUzrSi9Voax3f1LgSou641PG58SYS7LjcJ9mC8GjOO5X4y5mIT9C8VepjWy
	 doAEFFv2tPGhzwGM7XyWUYRb+LXiQLOT02R5d6Fk=
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
Subject: [PATCH 6.12 091/466] tools: Override makefile ARCH variable if defined, but empty
Date: Thu, 12 Dec 2024 15:54:20 +0100
Message-ID: <20241212144310.412092666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f6a50f06dfc45..eabfe9f411d91 100644
--- a/tools/scripts/Makefile.arch
+++ b/tools/scripts/Makefile.arch
@@ -7,8 +7,8 @@ HOSTARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
                                   -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
                                   -e s/riscv.*/riscv/ -e s/loongarch.*/loongarch/)
 
-ifndef ARCH
-ARCH := $(HOSTARCH)
+ifeq ($(strip $(ARCH)),)
+override ARCH := $(HOSTARCH)
 endif
 
 SRCARCH := $(ARCH)
-- 
2.43.0



