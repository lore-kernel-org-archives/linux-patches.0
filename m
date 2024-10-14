Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88FF19E802;
	Mon, 14 Oct 2024 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915862; cv=none; b=rvKOoG0ZPq/427jN1vLKGjUjxOJpVwEyncnMpQ8oXyYPyK0f3F2wq/KSPu84kx7mXz0NzWdYOcPdihsBuibOTqx0EtSr4pjtQUyxz/ud5sf4IGW6CTlaZka19EA3gy9gkrjUTXyHcpTfjdf+dKoIvVeJwFO0QLpG2C0szkf52kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915862; c=relaxed/simple;
	bh=EaQm//Bi1q8e0ezZjlKl9lHgPdDnIELxRp/6jsDhawA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eexp+cS3VjqJmY6Svl8av1k35gnLn1OCAKb9Xh9QjR8N4LVjjsNLLmARm/KUqYr6xvVhEwB4gzCEg5u/ZwuLx95pxoyo2PkNaKJ84ZVUiJuJmytp4k1hpE5HD6XgddlGuNXLO09QJoR5DGXwSMEfgtnRocRbhiVk2pwM/076fXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8w/Oprt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8w/Oprt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D45C4CEC7;
	Mon, 14 Oct 2024 14:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915862;
	bh=EaQm//Bi1q8e0ezZjlKl9lHgPdDnIELxRp/6jsDhawA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8w/OprtiI/zLjQBmq0+MDJnANGWC3GzRURWG2ZIbNGbw8QRAYXscV9QkY/9kYHbG
	 mGbTug3/lmOLXC58mCscmIyXr6NP4VLNr04PMfowwWe5JnUiuJHJZdM5KeSAWMLMVv
	 0if+6wxzJrRO2+pGZUCDebnjJ8J2EIH0cGbzKLrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/214] s390/facility: Disable compile time optimization for decompressor code
Date: Mon, 14 Oct 2024 16:18:03 +0200
Message-ID: <20241014141045.782077901@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b7d234838a366..65ebf86506cde 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -59,8 +59,10 @@ static inline int test_facility(unsigned long nr)
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



