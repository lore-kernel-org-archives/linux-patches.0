Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211738;
	b=MX94KCvaC8tRCKbW4yNCEdjkysXi8ZlPLO6iJQL5ghIQGS7egyqUmgd6mdpHAWFv8ZgH
	 ABxeoJPxBSmGxegzai3TQp1IsxC3ZpGBE4yb/7/2+1rLmFAlT66knVkuOqYO2Ps6fzjaX
	 juvrmMOtzNQywosWFUS+m17ez5he7SFHpdRxtGOjg+P9nj4DBoSNAlAt4Md1DKfIbJPWm
	 j8UZ6UCK9nrZquXAv32/in0BGItvCWGLjpp0AQKS0YZqifU5xv5Sop7xPyOEELeSQKT0l
	 imKDCtqlljGqUHRY/HK2UeVg06+sTFQp2O6mFmWxqtv+9OARwW+7GCMqmNU32jIafrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ouTNDl0tPWcTWNBI//ClV7hte4tTx3c8Gor4AJQcKVE=;
	b=K/LkuGhAZ3caQ2CMSNM4SU2+SL3eRhojNX3kmsbhWPT4YWeH1J1CMykgG7fRSmoEn+7K
	 i0g5pQBJAurgTzz28lCmSJyskzZswyJvKMSIO7FLZwWLw6GrqBDy6bFn/QGe9f2dAe+km
	 9YKyNT8YlamDmO3/0pVZLcDaTyit1Kn0czdtgnT58lUdwNtFvldCYKDUht+/UHZNh0+36
	 6ddsVma0ka+0j/BJ106nwKjkSu4b9Du5+BNdVuVJnw2r3tIh58jkCqKmcpSDB+M++iXMq
	 3X06cl2fDqqmYNB8O2U+78v3EyKApqMm5RArhooDVky4qQOyX4+dcxzBB9x1vy9iBRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kJWZw/7t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E80D606A326;
	Wed, 28 Oct 2026 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJWZw/7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1D1F01825;
	Wed, 28 Oct 2026 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211737;
	bh=ouTNDl0tPWcTWNBI//ClV7hte4tTx3c8Gor4AJQcKVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJWZw/7tAzoQuAEgzZw02K7ER6BrzlUu8esOx//RFP8fUtuGW5TcQ2v7jCNkEbJYS
	 1NT2Qxnu2IZd3G2gyAmKtPpF75mQINlgHFKiVm45GQSWJY6ygudcvGfc+ZXP9BEMrc
	 gGft0V9wKO5wObp99eNrRBJdkeLtQPq8gMc1Rvmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 483/571] nios2: fix __wsum type degradation in csum_fold()
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028170019.485506609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



