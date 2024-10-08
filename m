Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AD11D7E31;
	Tue,  8 Oct 2024 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390416; cv=none; b=ZaVCW0BCsQETl8La0rlpL53bU21v4SLcRN5/620Ms9IMi5wrWmAJeVtrJM2QxFRSRnThZc9S0mdACgjVWOgosb25EkxfgyUOmvINm/iYHMAQcTrV24iAAoaNH10AooHSbkRxAZEuV9mR/iHuYpYwZqBEFFxp6JYhLfsVn2W3Z3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390416; c=relaxed/simple;
	bh=Y0zRxrTMjJPf6cmtCEeeGop4r+Rw3TzTDklGHnUE+74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee3CJtRUPsOuMQKH9j65sCg+1Tk8Dci5T4NpflWl5pD1lRmP3StA+abDJRf3yWls1yzznHixaNySfXlp6iRyQ+XV+aqA2jniucdPPnwP3yAK6zojSs4lP3s+6ykR5M6xAwMdOABKbiPIbYFm91amebGy61dLuSx609+7ssmu/K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pos4g30i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pos4g30i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2DCC4CEC7;
	Tue,  8 Oct 2024 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390416;
	bh=Y0zRxrTMjJPf6cmtCEeeGop4r+Rw3TzTDklGHnUE+74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pos4g30iw6etFcKqf89i/AZ4qFTOwMVxL4qe55V217+oTctf+H8otsUexAjj9lsUT
	 brHS5EeZPlyoGiOVIy+xzBjrw4OrjenRvi8i9BPYUkNXnrFYyhGd0Fj+mG2smedX9/
	 pFaMZiA2CLglnSYxr3CWG2jwPonogDdxqAt/I7Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 282/482] selftests: vDSO: fix vdso_config for s390
Date: Tue,  8 Oct 2024 14:05:45 +0200
Message-ID: <20241008115659.377285690@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 00bfed6e4922e..fe0b3ec48c8d8 100644
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



