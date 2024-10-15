Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02901D4154;
	Tue, 15 Oct 2024 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994063; cv=none; b=WEdUMagak+8CfFk6ZZJZhuPuYgPymbUJzFDq2nr/en5z4Th/sAWnf87sr94kfBLqSCQc1WbzNfMd0MtIoZYA7XFsUKsH8NfBnZFBSzFKLl1UIlp9E/C+SIrPtYRQiFwCiW8wzMQJPkO+MI2N7A2VuovFGSCTEs7tXFj/whuXjsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994063; c=relaxed/simple;
	bh=mABcYNRSReBcp5HWVcZ9cGMHS4wu2v6gLPzX4fOO4/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9GoEGyViNxfIOP9qGFz/A3t/vFGJkIEWlTp/wTLGhXHQLvq0j0S45wUSTs0NO3KoaTK4PTG8sqWNB1gJNM24Ke1qMhQrtvo7wUfl7huuSmHqFqc0DEqfQ5C004l8wX4DVXfQOcgyoja3xsbfMGqKkPd+9neNyj2mDfy8NErGuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2gf8mI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2gf8mI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202BEC4CEC6;
	Tue, 15 Oct 2024 12:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994063;
	bh=mABcYNRSReBcp5HWVcZ9cGMHS4wu2v6gLPzX4fOO4/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2gf8mI1Mii9MqaYKl/3kG0sEOIvoynEQqmVZ50dxpTni2uK7Zm1ob2rELtfLs5ib
	 eRq3lPi1/uHyey/5A3QE2HtWaR+weMtdBCBYbdxJa/njojEFlFFbZJ2wrKfTfGS98g
	 Ppcrl384pPCjNsSDgI6wRXy3+K/v5q8zs0nCbxy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 597/691] s390/facility: Disable compile time optimization for decompressor code
Date: Tue, 15 Oct 2024 13:29:05 +0200
Message-ID: <20241015112504.038495286@linuxfoundation.org>
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

[ Upstream commit 0147addc4fb72a39448b8873d8acdf3a0f29aa65 ]

Disable compile time optimizations of test_facility() for the
decompressor. The decompressor should not contain any optimized code
depending on the architecture level set the kernel image is compiled
for to avoid unexpected operation exceptions.

Add a __DECOMPRESSOR check to test_facility() to enforce that
facilities are always checked during runtime for the decompressor.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/facility.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index e3aa354ab9f46..bd7dc6fc139e6 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -56,8 +56,10 @@ static inline int test_facility(unsigned long nr)
 	unsigned long facilities_als[] = { FACILITIES_ALS };
 
 	if (__builtin_constant_p(nr) && nr < sizeof(facilities_als) * 8) {
-		if (__test_facility(nr, &facilities_als))
-			return 1;
+		if (__test_facility(nr, &facilities_als)) {
+			if (!__is_defined(__DECOMPRESSOR))
+				return 1;
+		}
 	}
 	return __test_facility(nr, &stfle_fac_list);
 }
-- 
2.43.0



