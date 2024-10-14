Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE8E139D0B;
	Mon, 14 Oct 2024 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919719; cv=none; b=kuc6uwstFSyvLzk2bdKffhqE7HE7j5QlrcrdoSuYUMT7iCgTL+k9NwG/N0ib+umAOstqDYaX6vB6DQt1B0vxYrLpFsQkrfPqBcN7uB+ILBhTicsKNC5wi5Fs0kyjSAtacgwtJ1bz/bEHFXVa7hFt2RZccbc7PTpBHhhHFDjh21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919719; c=relaxed/simple;
	bh=69ndTRQtemZdZek1AAZ4riucCBNEB/6rVdyn2Xi5vMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X//aVMhZHDwnssH6eS2fPxmsN9yeMg8Z2r+mqV2OZXGfaRyTxLlreOYlZspfaI3kklMI3XaEyb4DbkF4YY2iHtBG+XjPK2VA3597ArG/UIA+A9BECUjjgqEDPcNAPoO/UK57CF6VSo/Kz8cD/HsIEhhc3kLEg3KkoRzB5Lk7pAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIwlYxPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIwlYxPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA2FC4CEC7;
	Mon, 14 Oct 2024 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919719;
	bh=69ndTRQtemZdZek1AAZ4riucCBNEB/6rVdyn2Xi5vMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIwlYxPZoSIeGEYXeaJgOSZqQjfzNqNuyjjZ/d9vQOQ25W2uCbgj3PEYNWIl1us6r
	 m8a/5nrWTJGC6AbkacseR0VBIavX0JRrwT6Vgevfw/ZGg9OL0ONlz2/ODnFgG1M1+e
	 djeHQcYRokkASOeZnoeY0bLiJIu5uSp09p6XJlc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 688/798] s390/facility: Disable compile time optimization for decompressor code
Date: Mon, 14 Oct 2024 16:20:42 +0200
Message-ID: <20241014141245.101826484@linuxfoundation.org>
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



