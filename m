Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4771DF740;
	Wed,  6 Nov 2024 12:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895490; cv=none; b=C4tdmXniKG3C453JkxmkYei2+u4gFvxxNyt2OVXB+gLoj9orVhWRwPMAvaKfM+a8i++74FDYixCYHTc4YpFMuUxoetEImlx/IM5RYcm5gn/4ou6vYB1frf1ot/2sPcW9+pcUEdJLqH74SSnh7/YibgnfXqI8XkKPq2FmKtZIy+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895490; c=relaxed/simple;
	bh=/9MJTLCIvmESFAgzDwPA2HHUp1vnXmpTxu3kAbsEMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfrEtxuHZf1Jz62niSaYVVPRU5gMHSSqXeK6UgpsOCz+7gQGQaSn7KHKkQiYsIOvFXqbLBSZcehybbdo6YR/6QFHOMlsWGGgImTBxwk4E01nV48a75rlqjNOsMrYSIkxARkXmL46xIOnZN/UxgGz0qxAJRRCm+UGKkh3tKG7n2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN+uXwC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN+uXwC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F07C4CECD;
	Wed,  6 Nov 2024 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895489;
	bh=/9MJTLCIvmESFAgzDwPA2HHUp1vnXmpTxu3kAbsEMUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BN+uXwC0vXgzvqgwolqHfqVNHhZ1S7ccdHG9l9hDVtrv3KfHw/QmMq4kfbeFxDYWd
	 6c1BE6nXLy/JuBcL+LhQMrw46IGxBHSEWjI6mhihI4F4tRPmA5JMziZ48j7hhhc7YD
	 wPMSq94jridD/gAQ85fTPFJvrYFR18QnhFVzpBOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/350] s390/facility: Disable compile time optimization for decompressor code
Date: Wed,  6 Nov 2024 13:02:43 +0100
Message-ID: <20241106120326.767687776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7ffbc5d7ccf38..79730031e17f3 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -53,8 +53,10 @@ static inline int test_facility(unsigned long nr)
 	unsigned long facilities_als[] = { FACILITIES_ALS };
 
 	if (__builtin_constant_p(nr) && nr < sizeof(facilities_als) * 8) {
-		if (__test_facility(nr, &facilities_als))
-			return 1;
+		if (__test_facility(nr, &facilities_als)) {
+			if (!__is_defined(__DECOMPRESSOR))
+				return 1;
+		}
 	}
 	return __test_facility(nr, &S390_lowcore.stfle_fac_list);
 }
-- 
2.43.0



