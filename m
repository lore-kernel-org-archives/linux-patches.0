Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2506218DF68;
	Mon, 28 Oct 2024 06:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097571; cv=none; b=Cz/063NRH8hva5NVDwbkWxK8FTuMPUHxej2GCaqilfShak4kvGIHxRW143TT+mY7IRgMbLySBJFXi6QygSdehnRaxdoJT9g60rMvWXBelII9vXJd1QTCx/mDK68pO9QuRzzJ1x3Wze88wIL1AY16DKo8GHNRYiYizzsdFSj/zjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097571; c=relaxed/simple;
	bh=9myZPUUz5d+ExMPGNUnR1jKuMNSGTUz1GTneZchQwMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3WEg1Lsx+IQSifE2sGiR5TfQdTlbRR3rGpDe3RMPtG/HJeETtruYkASqFQk4gf/KazFqGwTSnOmEkF0ZK6erW/cuTDJh+itJKZ/XLm6eEG07Z1U7+UjA20ldqH3AtaYQo6Px5DJFfUKdXw8ZIxpbBud6KNAl0XI+E3Vtw+Jxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whGCk9ks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whGCk9ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FE2C4CEC3;
	Mon, 28 Oct 2024 06:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097570;
	bh=9myZPUUz5d+ExMPGNUnR1jKuMNSGTUz1GTneZchQwMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whGCk9ksqrjbPCGvL3Q5YRlGZIELXd4amsuE5NpKG/5v0FQhdY2/ySutagLXOboy/
	 rKC4R/eCJX1dEgi7JKxzjlhKw9XefaxIAEVm587lG8uVp8TgxKDt+iqx7+N/ja3+UH
	 9XVVsirWcCWKmsYkSGxm1eXWvxvpRePvwcIc7e9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/208] selftests/bpf: Fix cross-compiling urandom_read
Date: Mon, 28 Oct 2024 07:23:24 +0100
Message-ID: <20241028062307.251237297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit fd526e121c4d6f71aed82d21a8b8277b03e60b43 ]

Linking of urandom_read and liburandom_read.so prefers LLVM's 'ld.lld' but
falls back to using 'ld' if unsupported. However, this fallback discards
any existing makefile macro for LD and can break cross-compilation.

Fix by changing the fallback to use the target linker $(LD), passed via
'-fuse-ld=' using an absolute path rather than a linker "flavour".

Fixes: 08c79c9cd67f ("selftests/bpf: Don't force lld on non-x86 architectures")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241009040720.635260-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ab364e95a9b23..f5a3a84fac955 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -200,7 +200,7 @@ $(OUTPUT)/%:%.c
 ifeq ($(SRCARCH),x86)
 LLD := lld
 else
-LLD := ld
+LLD := $(shell command -v $(LD))
 endif
 
 # Filter out -static for liburandom_read.so and its dependent targets so that static builds
-- 
2.43.0



