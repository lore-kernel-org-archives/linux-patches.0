Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E4D1C57B1;
	Tue, 15 Oct 2024 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993793; cv=none; b=O/ws2n3X8t2J6aFLXE6bSxk1Sd4KFfHC8DfmpSK7uU3wcPzDs4K188e5KpuN4RwQjAZUYXjQNZeaV1RO3HznX/gUZeLBNEks+blSYNTig0kk5r/TxHnldH2lg9OMtaNhuhLSYLRz1dXXr7zLMcNpq4L4gL7ofUoZBbG5ca+I1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993793; c=relaxed/simple;
	bh=43hebsbqv4hMEYOeGYlJfkoHW5/PBJOd4fiZCyU05Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsk46qlkClDAh4yhfNeVZS6hqfT0h2klKaIUamDgUOoHWc4r/kIyZOdibrGrNpDm6MSD0G5qdREk7TQSln8eUooplj6zi/7srdHLp9vjKZJ9+iJsGrUM5pFB6PErM17/p1gMYVxxYAn+hnilUpDRcrpx3jrp7tcvuNFKbtjhELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLRCDRUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLRCDRUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA1AC4CEC6;
	Tue, 15 Oct 2024 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993793;
	bh=43hebsbqv4hMEYOeGYlJfkoHW5/PBJOd4fiZCyU05Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLRCDRUhDVrt9ackcQSnca0mCSynUhrfEhoMexwjQeABv74Iia2lRlaunWLOnhGGd
	 9UG8xNOPlnIr2jHXw0bagoQgzILSjtepOluNeaFn6Q6ZZW48mzYwQtBRIN7iQeI2RX
	 92ysP1ccqV1pRYwRRAZBSgmvA/mvUSueAla/tFfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 487/691] selftests: vDSO: fix vdso_config for s390
Date: Tue, 15 Oct 2024 13:27:15 +0200
Message-ID: <20241015112459.667490381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 446eb9737273b..a6868ca0e4f89 100644
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



