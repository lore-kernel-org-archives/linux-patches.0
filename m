Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2C223A188;
	Thu, 12 Dec 2024 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022028; cv=none; b=Cy4WDSg1TVIqYV5sMWBuT3kxzkfL19/rW4C7t6enOUHFTeAej2BjkwOOHa8yQ37RnUzNFtohO/V/e1XYzOxOTLvIBS3tWl6K8S4TjPGaa8LJrAVMSp1Ub/aMNV2Vk6hGYo9iXLt+xBLGfcEPmHLUIkVHnWX5kz0yVnD2DecXmyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022028; c=relaxed/simple;
	bh=YhvozduS5iSL3zWMqHyQcy+K5NaOf89InAEmYWnI/b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOJ1LAZ1K94URI9kErU4Tm4idhRXyaHZxqf4wxoRJ2CO1NpUKGXeeYPK6hmBCeFPmWiW4t4EFnSWkoN2720rZl5VOnJb2gntlOP5qSNZnv1zT4fwShw1A1511ToygTTiHesrpnaY/7UmVl5y/YKC5pTvxkxU9eFubuG31xh8nF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzzTi5Au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzzTi5Au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09A0C4CED3;
	Thu, 12 Dec 2024 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022028;
	bh=YhvozduS5iSL3zWMqHyQcy+K5NaOf89InAEmYWnI/b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzzTi5Au6NnIi5mz5WwZGdaw3yGppY3dSBZGmH/zIDfXjdbfGVsFsje3RV7HwLd+/
	 MxbT9vrxEeNpQUHVkFAJ58ok87VlanTtNdg6cn14V7xpSl9oCMtQ4aK8H7NjBVMgAK
	 JudiTApCELADoVEAqdaVn6rWbZUeIt1yu3lzR7p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/565] arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG
Date: Thu, 12 Dec 2024 15:54:42 +0100
Message-ID: <20241212144314.925666398@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 184abd7c4206e..7bedadfa36422 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -258,6 +258,9 @@ SECTIONS
 	__initdata_end = .;
 	__init_end = .;
 
+	.data.rel.ro : { *(.data.rel.ro) }
+	ASSERT(SIZEOF(.data.rel.ro) == 0, "Unexpected RELRO detected!")
+
 	_data = .;
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
@@ -309,9 +312,6 @@ SECTIONS
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



