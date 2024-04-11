Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC3313A244;
	Thu, 11 Apr 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712859076; cv=none; b=EOP6QrlGjMzQ305MMc0lUxKvhHh8nQnf14EIw3YCtvtBjpYoa6PQwrMo/Bqs87fNY/E/rzZJae8VqkrvbpXDWyxhgrUcH1YAd2yeUAnXKfGG2Ei7LzfnQX4yybc4gNBynpgjZAIJAUHYxOS6bzJ4p/251aNIBAsPR2wLrPkHypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712859076; c=relaxed/simple;
	bh=E+pCb+Z9vLlU9oGTaDGgpHqqUQ1HPT9OB7NM+MDiKXY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gDeyOvHbuYtoqFI5i4k9eWL5XVcM8kiB3IgR/hVeQm6KKKEhCevGUlTw1uhkbh1bgo14Utu/bY4wRwcd9xONvGS86XaDLkSkrjFICsl3OhNieuE1iebaUDf5Q8iM8NCp1nngUuR7eFmv8JaZso5fOgQ6TuaH87pyF7FTUXBrkjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0ZmNJJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0ZmNJJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FF4C113CD;
	Thu, 11 Apr 2024 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712859075;
	bh=E+pCb+Z9vLlU9oGTaDGgpHqqUQ1HPT9OB7NM+MDiKXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=R0ZmNJJBImlFVDvKD9xX12UGfrx0f55HtfBhVghYoLbITC8CZGQsvtJM4rOU0q0lm
	 1ehyCQZ9HV+EdC3RPsgIOv8sB4Q5yeKsIIIbYtFzMIM2ypkrTepVsIaaejP0VtjeY/
	 eYlPuGAGP3RC320f2aU3hIPEJveX2x0wYMkmPEIP5/FPZhIkyP+bHpyvgxUqGm4pQJ
	 2NT7XtJrRUZhHaJyXvkxavKKu7vwfZQndze1nl/LJ26Ww3VUFrh0e3XavtUozHI2RZ
	 u+ku0J6Tw76+fp4lHpPEl+RW+zHO/ws2SjB4SAl5nap2Wa4HhpVnEW3wRnsJ/zOi94
	 PDE0imHgcF4Lg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 11 Apr 2024 11:11:06 -0700
Subject: [PATCH 1/2] configs/hardening: Fix disabling UBSAN configurations
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240411-fix-ubsan-in-hardening-config-v1-1-e0177c80ffaa@kernel.org>
References: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
In-Reply-To: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
To: keescook@chromium.org
Cc: gustavoars@kernel.org, justinstitt@google.com, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2244; i=nathan@kernel.org;
 h=from:subject:message-id; bh=E+pCb+Z9vLlU9oGTaDGgpHqqUQ1HPT9OB7NM+MDiKXY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkS6ociY/bfrViVKCR77eH8n3zu+oenRspM0bu7sXLhF
 wmZnx1XO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEPh9h+J+U8O+KRvXOKd7N
 2tve1p7qfxF9KbWB96K390zu62x3/vUwMqycrnrM2txoc1Hy/MhG5a1r7NfP0q3KS3s2OffLlFi
 B6VwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The initial change that added kernel/configs/hardening.config attempted
to disable all UBSAN sanitizers except for the array bounds one while
turning on UBSAN_TRAP. Unfortunately, it only got the syntax for
CONFIG_UBSAN_SHIFT correct, so configurations that are on by default
with CONFIG_UBSAN=y such as CONFIG_UBSAN_{BOOL,ENUM} do not get disabled
properly.

  CONFIG_ARCH_HAS_UBSAN=y
  CONFIG_UBSAN=y
  CONFIG_UBSAN_TRAP=y
  CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
  CONFIG_UBSAN_BOUNDS=y
  CONFIG_UBSAN_BOUNDS_STRICT=y
  # CONFIG_UBSAN_SHIFT is not set
  # CONFIG_UBSAN_DIV_ZERO is not set
  # CONFIG_UBSAN_UNREACHABLE is not set
  CONFIG_UBSAN_SIGNED_WRAP=y
  CONFIG_UBSAN_BOOL=y
  CONFIG_UBSAN_ENUM=y
  # CONFIG_TEST_UBSAN is not set

Add the missing 'is not set' to each configuration that needs it so that
they get disabled as intended.

  CONFIG_ARCH_HAS_UBSAN=y
  CONFIG_UBSAN=y
  CONFIG_UBSAN_TRAP=y
  CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
  CONFIG_UBSAN_BOUNDS=y
  CONFIG_UBSAN_BOUNDS_STRICT=y
  # CONFIG_UBSAN_SHIFT is not set
  # CONFIG_UBSAN_DIV_ZERO is not set
  # CONFIG_UBSAN_UNREACHABLE is not set
  CONFIG_UBSAN_SIGNED_WRAP=y
  # CONFIG_UBSAN_BOOL is not set
  # CONFIG_UBSAN_ENUM is not set
  # CONFIG_TEST_UBSAN is not set

Fixes: 215199e3d9f3 ("hardening: Provide Kconfig fragments for basic options")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 kernel/configs/hardening.config | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/configs/hardening.config b/kernel/configs/hardening.config
index 7a5bbfc024b7..d6f6dc45628a 100644
--- a/kernel/configs/hardening.config
+++ b/kernel/configs/hardening.config
@@ -39,11 +39,11 @@ CONFIG_UBSAN=y
 CONFIG_UBSAN_TRAP=y
 CONFIG_UBSAN_BOUNDS=y
 # CONFIG_UBSAN_SHIFT is not set
-# CONFIG_UBSAN_DIV_ZERO
-# CONFIG_UBSAN_UNREACHABLE
-# CONFIG_UBSAN_BOOL
-# CONFIG_UBSAN_ENUM
-# CONFIG_UBSAN_ALIGNMENT
+# CONFIG_UBSAN_DIV_ZERO is not set
+# CONFIG_UBSAN_UNREACHABLE is not set
+# CONFIG_UBSAN_BOOL is not set
+# CONFIG_UBSAN_ENUM is not set
+# CONFIG_UBSAN_ALIGNMENT is not set
 
 # Sampling-based heap out-of-bounds and use-after-free detection.
 CONFIG_KFENCE=y

-- 
2.44.0

