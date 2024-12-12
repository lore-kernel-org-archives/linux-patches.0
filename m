Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6452210DE;
	Thu, 12 Dec 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018883; cv=none; b=Aab7RLLeQW7/3e4jVrYAIor7e5EVKgvUDDXJvM1fSsF030lTtZCAHQLxd9SdO7z/mPwWE9j+w7oZmF45DRBc6JPYPHieE9qq6r/MLsXNBq15YW85w3tsJhfg40JG9XeWo5E3DmEQ+URzqn8fLTXnTJAD2SV1TdaO7EPKkMx5EY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018883; c=relaxed/simple;
	bh=iI/n5CVPO+3djMn0bPGbH5hEk38kUKo4RRiNvHh3VHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGVyGLJJNfxP2OJW+ew7hA9VR39dHRLlxijdtwgcyD9kzltU1MswA74KFswZRQW/54QRSX+1eHlxzvCZsYNQkqOcjfGTKpM1pN1iakgGu2XFC8VYBKgV/kC3PbrrDq7zmhzA2ADiPadKF49SedHyPQHw25WOEaBaYnttpPgdTNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hk5psoCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk5psoCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58426C4CECE;
	Thu, 12 Dec 2024 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018882;
	bh=iI/n5CVPO+3djMn0bPGbH5hEk38kUKo4RRiNvHh3VHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk5psoCRNW3t0mS9Mre6zRbBg1eJrvXDTvNpF+YLpDk8gr6y7OKvSUkvE7GyN7kEu
	 wzvynC6gzkJi/Ri/AZSeWrkMXCR9W1TQV5c4ovz3pAnBlBnOM8LcAyPtluGpkPlI+s
	 F2x9vP6Uhxt3h1Nz47RefkXHXhpUMSe51i3v55Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/772] arm64: fix .data.rel.ro size assertion when CONFIG_LTO_CLANG
Date: Thu, 12 Dec 2024 15:50:03 +0100
Message-ID: <20241212144352.341137776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 45131e354e27f..b0226eac7bda8 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -272,6 +272,9 @@ SECTIONS
 	__initdata_end = .;
 	__init_end = .;
 
+	.data.rel.ro : { *(.data.rel.ro) }
+	ASSERT(SIZEOF(.data.rel.ro) == 0, "Unexpected RELRO detected!")
+
 	_data = .;
 	_sdata = .;
 	RW_DATA(L1_CACHE_BYTES, PAGE_SIZE, THREAD_ALIGN)
@@ -323,9 +326,6 @@ SECTIONS
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



