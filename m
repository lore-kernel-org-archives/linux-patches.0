Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6101F7550;
	Tue,  3 Dec 2024 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237901; cv=none; b=fBNX2qXbuLY/QG8Ix4aWHsEfjds3scIw5Zt5r+aMVyMMSDGFYCRMQdVD5wfm1/VfKXHNkzngnb/q2DUyGn3hm7g2PlqnmG2pUXCicY+yawaYLvoQjGYU9MQeqhZ8eEDhpSuDoot9rf8oTc4TVxlmNEiCAHz16X0xqYKPUOpqExo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237901; c=relaxed/simple;
	bh=VEJ/n+iOM0IVS9OVUO18QOccQmCffkCMUBWNtIefUV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCUyeilFEOBw3Oye22b5PuzBI0Ee+3beTIOVQEsthBMv+o6Zl9JXIBfb4V0eqnxkFTfQNd+PZTJtw135WPjcxu4Iamksd9fFwnRybaRk2WN80qo2BUo3xizrPqADccZjuk0oImuoCmZ1W42nE363JaUvZVMq2zSdSru2cqXfJ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj6nVPdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj6nVPdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B52C4CECF;
	Tue,  3 Dec 2024 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237900;
	bh=VEJ/n+iOM0IVS9OVUO18QOccQmCffkCMUBWNtIefUV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj6nVPdw7jLg/Ts18P/8IIfp4fd/qf1JiYB+gnE+tKuMkHSQy0cTKR7Q+z14+Q+EP
	 DXPzzdiPe7mShiZz2iPadW1PSCixKlilg4tC8dVvtzVP5ZW23hrQqXqTbLmMAJXJDJ
	 Cbi8qwTIbsCEydvaY6A1bvPStCqQD2jPQP+HFKJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 070/817] arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG
Date: Tue,  3 Dec 2024 15:34:02 +0100
Message-ID: <20241203143958.421146807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 55a8e310ea12c..d294c1ea8391b 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -288,6 +288,9 @@ SECTIONS
 	__initdata_end = .;
 	__init_end = .;
 
+	.data.rel.ro : { *(.data.rel.ro) }
+	ASSERT(SIZEOF(.data.rel.ro) == 0, "Unexpected RELRO detected!")
+
 	_data = .;
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
@@ -344,9 +347,6 @@ SECTIONS
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



