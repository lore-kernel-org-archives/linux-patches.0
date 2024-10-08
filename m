Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA79718C333;
	Tue,  8 Oct 2024 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393608; cv=none; b=rx/T3mt3nrGXW2oS5STa2I6K14zYRBE3vWWEoL/pRvVLFl5y9VXHAHxgAyQRjON721KfUwF/8hRxRAo+M90qzd8MD6i0RhM5LbTcWl4sTK6PRVFrg8oKkwzLJuh35CuEdVE8wBpy+dYDe3Re5uhAj5m/1kOsBwgi2vkAqU9RqzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393608; c=relaxed/simple;
	bh=odu0cmUwUdgUo9c8DK1/hEEuOLFjL3uqSMPUHe2Splk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcJw3t/uD9Y6Ukw8XCXnwlKvpdH0GclZG7LvAuApmp9zkp5w/zIe3USHdQGXNT8n3t2gay+eYH4z1NzhyBLFvS/yf7o1eOZvUW5g0wWJt+1ObMuLD2QHp+m1SzrgJeMc2ksKDdU6HfcTDXUl0qusZaT5oeznUf7pbILY+U/YS1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/8pfA+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/8pfA+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6210FC4CEC7;
	Tue,  8 Oct 2024 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393608;
	bh=odu0cmUwUdgUo9c8DK1/hEEuOLFjL3uqSMPUHe2Splk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/8pfA+hPKqBj15bavsxZTXNoBI7Ph4aRv+NhtTHg2j+2znI0r0SM8pqLNsGdgk7X
	 +3MvwUO+uOjIyeUxTH0etc97Ff4qYUMQppbt5hqIu+xIXZLPhIqXqmngPqKttBToRJ
	 A1/Lcb4IRigC1TYYfhVjofWfK9xqdJm8AvmG8BnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/386] selftests: vDSO: fix vdso_config for s390
Date: Tue,  8 Oct 2024 14:07:28 +0200
Message-ID: <20241008115637.395631706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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



