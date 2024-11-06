Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255631EC00E;
	Wed,  6 Nov 2024 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898772; cv=none; b=ZOf8upTxjiAcwAo+rFX3kah4ZvQqxmb39w/5AxaArITf9AdZjz1bPlsiRMiXlQAHxB9iVkUTPKENXZrJtBTyOWS4n3gOp16BJlUgi2yh+VjkLAvfdtwIhkLQXEMNr2lebJxY0p2RYOqZeV1iPrpqFk3ZMuB5KVn50h2LRksnEE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898772; c=relaxed/simple;
	bh=Exr2DovyX3hWi4+56pTn4H354pWbvCufwbb2Z0bXQg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je0L/0m8bfJgGt+uIqzkXS2zZbm8BOaigE1upa69yVvKQGmj6IGS2q3nb40+YGm/UhmmaaVc3DqQlI5st/VTw9tpwlYIwdHgtP8v1a1PbnFCO1wx2wGy+B693d/79UeUPakpCeemUKPT4EEpdU78A4CsZcHx/c1O54oDRsHb5eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Iw693di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Iw693di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2393C4CECD;
	Wed,  6 Nov 2024 13:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898772;
	bh=Exr2DovyX3hWi4+56pTn4H354pWbvCufwbb2Z0bXQg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Iw693difSPJFcVqGEPGiA5nXNnBwHbZHUz1Csj8J4lVUHKEZzFDmeXjA9FmHFWvI
	 iFemAUx+snpDjBLmNTNoFV6VHW/cdEmqtedqR1vAmHx/ygLGtTkDeMhhTa+Qzr035v
	 yvRYSIQ4FzLZ3h9qk/CieHhOwz/2J2rcHzKffACM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 304/462] s390/facility: Disable compile time optimization for decompressor code
Date: Wed,  6 Nov 2024 13:03:17 +0100
Message-ID: <20241106120339.036279702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 68c476b20b57e..c7031d9ada293 100644
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



