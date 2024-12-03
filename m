Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203DC1FC115;
	Tue,  3 Dec 2024 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240111; cv=none; b=AjFcu0XmSg26w04MGBE9z60TUHWdb0ZL0zxF+XwwRZnhEY7WVGSmQGWSVX3i3BKms386yO/mi4BeGbMjN1oYlEyFxc6XHEwXfmkHRmpe0vOefEKpzyRl23Kb4YYm6dwVo5ghRnhK/odA3qu7CiXHa8j2X0PLN6ElrJxZ9LJnP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240111; c=relaxed/simple;
	bh=mS6MGpCFdzNHJkpi0rQhpB+i+tVflsh158PJ6cF9PJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te02cIejr1sR6ri73ZHXuxOfCyKe7kCf4j9uF6sPCzvDTqPPuX/odCwiW2koqbcpTsy7bPZCXN5uRoetkecWXcAEx13tRgT9kA1aREymgAiqPt1DniRjVFtGTj8gyaEnaN5eBvk4ksl/6BBYvW7RPBlJV6Rzoct5pJZOP+gkMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRDe0n5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRDe0n5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F80DC4CECF;
	Tue,  3 Dec 2024 15:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240111;
	bh=mS6MGpCFdzNHJkpi0rQhpB+i+tVflsh158PJ6cF9PJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRDe0n5mr6wD3IfzdvrCccnjaKIQF7VTbD69wLyyw4xex//hEacK+NEIgHbQu/k4U
	 Pfad9zbNeX0IdncGJWKy4Qmjrnw5giI+EQlJjsnNlrydgGBeuESJPJYRmPrRAKbikC
	 KIbn8Srq9VAFmTWowXcFM+9XYywE3fJAHe5F56+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/826] arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG
Date: Tue,  3 Dec 2024 15:35:53 +0100
Message-ID: <20241203144744.481385884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 340fd66c856651d8c1d29f392dd26ad674d2db0e ]

Commit be2881824ae9 ("arm64/build: Assert for unwanted sections")
introduced an assertion to ensure that the .data.rel.ro section does
not exist.

However, this check does not work when CONFIG_LTO_CLANG is enabled,
because .data.rel.ro matches the .data.[0-9a-zA-Z_]* pattern in the
DATA_MAIN macro.

Move the ASSERT() above the RW_DATA() line.

Fixes: be2881824ae9 ("arm64/build: Assert for unwanted sections")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241106161843.189927-1-masahiroy@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/vmlinux.lds.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 58d89d997d050..f84c71f04d9ea 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -287,6 +287,9 @@ SECTIONS
 	__initdata_end = .;
 	__init_end = .;
 
+	.data.rel.ro : { *(.data.rel.ro) }
+	ASSERT(SIZEOF(.data.rel.ro) == 0, "Unexpected RELRO detected!")
+
 	_data = .;
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
@@ -343,9 +346,6 @@ SECTIONS
 		*(.plt) *(.plt.*) *(.iplt) *(.igot .igot.plt)
 	}
 	ASSERT(SIZEOF(.plt) == 0, "Unexpected run-time procedure linkages detected!")
-
-	.data.rel.ro : { *(.data.rel.ro) }
-	ASSERT(SIZEOF(.data.rel.ro) == 0, "Unexpected RELRO detected!")
 }
 
 #include "image-vars.h"
-- 
2.43.0



