Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5942018E35B;
	Mon, 28 Oct 2024 06:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097172; cv=none; b=TPVhuwsqMrHqP6xNg2WrCqr1CP0uohbjGECHiRjR62oz2NtdZiW5HjZ/N5ptnO03QymDJ4Io3edW4MNrg6Ypu+o+JnMbHk/3ud8AONd/PldQS40f0YuVLXU3Fdff0CKlX4ruOJWKepo/1asWF0SYvHGz90j7cmMs1NEkI9XJdSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097172; c=relaxed/simple;
	bh=iwQ8mBaV1ZGjSeFerRx7Lgbp8o7hqaWc0hDlh6ptZrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXxaAK5uXXRX/DihZYtLFBx8ZzaL5KZ/n5SfRH/9a/SxpsbMvs0wFs1QWvQmLoxmnCcOLeKeo4DEG4t/QypZLzy82anWNmaU3ksFH06gOE5AxtLQzKfWsFZ5qmZh/mf2Mja6oJOQHJEGFsEFT5CM4S5QTY4F7W5U8uBLy4u9KbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRhZKrTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRhZKrTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2690C4CEC7;
	Mon, 28 Oct 2024 06:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097172;
	bh=iwQ8mBaV1ZGjSeFerRx7Lgbp8o7hqaWc0hDlh6ptZrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRhZKrTEHuypsvl1N4PQm7EPyU3lvmUOCt271CbVd5ViJIEUYAokCPHDrroALAvZE
	 H67dxNf7QQqBeEUMNFUfge5/p7nfpBJ1piO9AtYCd5kON2xG3vwp/k70VwMmSNgFqe
	 2CjbB9RRJW9Yj6oo+Uwjj6JhCYw8XQ2oI1FACs4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/137] selftests/bpf: Fix cross-compiling urandom_read
Date: Mon, 28 Oct 2024 07:24:12 +0100
Message-ID: <20241028062259.148686932@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
index 3b57fbf8fff4a..b09205d925114 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -171,7 +171,7 @@ $(OUTPUT)/%:%.c
 ifeq ($(SRCARCH),x86)
 LLD := lld
 else
-LLD := ld
+LLD := $(shell command -v $(LD))
 endif
 
 # Filter out -static for liburandom_read.so and its dependent targets so that static builds
-- 
2.43.0



