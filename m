Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEA519E7ED;
	Mon, 14 Oct 2024 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919137; cv=none; b=n5O7AoLO3WnEtfHK1ntZENIu1BoZ/ObtgoJhWk6T7WTCP0lzxouLreelTaenaOgrMXBkJQeog9B+4HE/w+2rUhbESLTBwBmR0W3PSa3hPEdawRGL4hFQRhx4NSZaU9xrvRR8G3BlTj03S7C/K5ogqyW7T/1Cr0PacVOKAPJe5Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919137; c=relaxed/simple;
	bh=MwTW+hjFnGmEIqI5aXDqN8awfYh327Rk3CXfiL0f16Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJwLRWtqWOv6zD3DB9o58u5BwaL22CzTNpv6GJ3H2GoqXTYDWQLsSgnSqtzbAjir1RhjFOmzm3DU3I8FMp6JnUxDyoTx/xmUYhlZnwk6CYcnxloa25vOVs32D8AVmDR6nSqD60VNz0ik7XycYrCvZdXmILYcohIXPe1sWr3FGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K63UPZOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K63UPZOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D93C4CEC3;
	Mon, 14 Oct 2024 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919137;
	bh=MwTW+hjFnGmEIqI5aXDqN8awfYh327Rk3CXfiL0f16Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K63UPZOqwFv6VxHlL1LYCL8X24Jhzdmn8YuZD699AcTUGLdC5WaaR22rlmhm0pkW6
	 CfxAH6yuKgNRE1jMKMJeRAiithGhoc65zv9tOVNCGe2VXei1zISAgdltLy/UuA7hnD
	 0xE1jkO0Q7rF3JpyX8MUcPFr46jbGQc/QxAL5BKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 522/798] selftests: vDSO: fix vdso_config for s390
Date: Mon, 14 Oct 2024 16:17:56 +0200
Message-ID: <20241014141238.487276711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit a6e23fb8d3c0e3904da70beaf5d7e840a983c97f ]

Running vdso_test_correctness on s390x (aka s390 64 bit) emits a warning:

Warning: failed to find clock_gettime64 in vDSO

This is caused by the "#elif defined (__s390__)" check in vdso_config.h
which the defines VDSO_32BIT.

If __s390x__ is defined also __s390__ is defined. Therefore the correct
check must make sure that only __s390__ is defined.

Therefore add the missing !defined(__s390x__). Also use common
__s390x__ define instead of __s390X__.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Fixes: 693f5ca08ca0 ("kselftest: Extend vDSO selftest")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_config.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_config.h b/tools/testing/selftests/vDSO/vdso_config.h
index f9890584f6fb4..72de45f587b2c 100644
--- a/tools/testing/selftests/vDSO/vdso_config.h
+++ b/tools/testing/selftests/vDSO/vdso_config.h
@@ -25,11 +25,11 @@
 #define VDSO_VERSION		1
 #define VDSO_NAMES		0
 #define VDSO_32BIT		1
-#elif defined (__s390__)
+#elif defined (__s390__) && !defined(__s390x__)
 #define VDSO_VERSION		2
 #define VDSO_NAMES		0
 #define VDSO_32BIT		1
-#elif defined (__s390X__)
+#elif defined (__s390x__)
 #define VDSO_VERSION		2
 #define VDSO_NAMES		0
 #elif defined(__mips__)
-- 
2.43.0



