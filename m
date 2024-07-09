Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314D8158876;
	Tue,  9 Jul 2024 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523716; cv=none; b=o9zFC0O3vY9SpYeA7GvbZQQWV3C8gsRjOmsPkd4ogdoZiuRg65CKqbK9OyNb3JWbed9TMWYd/5FFnwmBu96U3r0sl8hrJ3WIOm879+HMQIiUf/sbo1bXyTKEz4NQLI5HlPk/AN9VGNMC4Zr3duDnjgUJ1O37f1PK19wz7jVxbVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523716; c=relaxed/simple;
	bh=jS9Hd6Zloh0rwzp4Qlbr6WV3KqDmmMCR8Ll6UDiUIqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW2NGvYs5Tq2C3vh54J0JgH0LARBQ2Maol1pLU25izjqB3S31D/aNBl6/eAoe3W8xzfSAyrRuaSA35/ujOqHOdYJT6pkm8/6DZgZVoFwxiTI2AgS1iYnp7PL6Pd2kM6FfkJ9P1wHUIGhzB/xV+Byvbc/aoqBBqxrxcSgutC/Qjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW12hqvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW12hqvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B64C4AF0A;
	Tue,  9 Jul 2024 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523715;
	bh=jS9Hd6Zloh0rwzp4Qlbr6WV3KqDmmMCR8Ll6UDiUIqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW12hqvbdcW5I5/gr4iRyz0DhSc5wmifxuWPTYLeayBGQoL5CHAziLo5L8BtzZycV
	 l/LkMk0C47VG5HY5EbvjJpQGqviQZ4kkTOH7xyLgJdh7cFalh+WpTssMbv336MKCI4
	 RSgsfNwfp8HF7wWrHqTDrtJUo5eI6u59KW5tT0UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/139] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue,  9 Jul 2024 13:09:13 +0200
Message-ID: <20240709110700.219787792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 7278a8fb8d032dfdc03d9b5d17e0bc451cdc1492 ]

Without __unitialized, the following code is generated when
INIT_STACK_ALL_ZERO is enabled:

86: d7 0f f0 a0 f0 a0     xc      160(16,%r15), 160(%r15)
8c: e3 40 f0 a0 00 24     stg     %r4, 160(%r15)
92: c0 10 00 00 00 08     larl    %r1, 0xa2
98: e3 10 f0 a8 00 24     stg     %r1, 168(%r15)
9e: b2 b2 f0 a0           lpswe   160(%r15)

The xc is not adding any security because psw is fully initialized
with the following instructions. Add __unitialized to the psw
definitiation to avoid the superfluous clearing of psw.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index dc17896a001a9..e7338ed540d8f 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -308,8 +308,8 @@ static inline void __load_psw(psw_t psw)
  */
 static __always_inline void __load_psw_mask(unsigned long mask)
 {
+	psw_t psw __uninitialized;
 	unsigned long addr;
-	psw_t psw;
 
 	psw.mask = mask;
 
-- 
2.43.0



