Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C4D1AB522;
	Mon, 14 Oct 2024 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916768; cv=none; b=U8T/oQSOcJ3K0g6lCgT/jpnRyOBG5PHtyZfiT8knji6ks7hi5XrUHa/Tbr8iG0lbg7ZHfJ5QyYeSSeBlgSv7/cWCAaaup6CySvn3MZkweBgkLMwOgeXVYXWHW3V3SwJINtMsrjAcyBlxE4IzTYHyNV7eLNvtFO2w5Fs3SpCcHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916768; c=relaxed/simple;
	bh=JXScuW6IiIqrBuJB8ILHVb+6h+Ffjx2ayfR5tQr9db4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd2SVljzLmdjesQt7BWjENLP9XQqvpc0UWkRiWVc8upxabzJQF277dZYJVSOTKmw6zPTRbJzCGu/DG1hukQE2QY9m0fS1V8WQBswKKqX5Yb5uecZBUSfmW1zwE2ngqxB2gWkBkq41gBcR/cx05PCheSErUs9W8n/xpPmctGFTH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwPs8me1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwPs8me1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EA4C4CEC3;
	Mon, 14 Oct 2024 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916767;
	bh=JXScuW6IiIqrBuJB8ILHVb+6h+Ffjx2ayfR5tQr9db4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwPs8me1nDzjcNbuOXs/SxI+0cfrKXrni+/9fSL2DahD+gYDuk1CfLEQFVMqQA4gE
	 zjbZF+YSMqTRW9ttw6K9mk374PxcGhnee1XHCaPDrkc1zwrydeX7zmGrVcYF0wEdnK
	 8YLnsGeP1KsIPLw+vrBQIt8EASrEkZkt5sxpA6EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/213] s390/facility: Disable compile time optimization for decompressor code
Date: Mon, 14 Oct 2024 16:19:25 +0200
Message-ID: <20241014141045.294180950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index 94b6919026dfb..953d42205ea83 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -60,8 +60,10 @@ static inline int test_facility(unsigned long nr)
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



