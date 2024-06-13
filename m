Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4221448D8;
	Thu, 13 Jun 2024 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280771; cv=none; b=uspUYPG9mBWICIb8DCReNFSFujN8WqFAKEWXGdukX4KzvUVZ9stXiMe3FUa3FlbCwZPV1o+3WdATw0RxqJFtwMIoqSVyzEVw0dtoih7Ic2Np4YE2fFU0XkYxoOSK9Eht3MW47FEWLG+YFifvG32sC4YHtR5hWE1zdJJ9LQlcjeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280771; c=relaxed/simple;
	bh=GgSuZcAyofVRip0pOGM/N1XhcKp4qNH+TLt1hvTdGNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+B9TQMPNCTDUicJUPIJb4TuES42xDXeavrx3U+SUUeU/aLunPXotOxpKZRS7OKMpdy3BHm+xRcbdX/Mz+2tBatrw6/wK3RVtvGtYN43yBUN5d9KZ76yLC6cL2x1QmBmShJE/g/iLgADRh3BDs0ePD8dqruQwCi8MmoofG4jE5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiagIZxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiagIZxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81883C2BBFC;
	Thu, 13 Jun 2024 12:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280770;
	bh=GgSuZcAyofVRip0pOGM/N1XhcKp4qNH+TLt1hvTdGNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiagIZxy2Cm5Tq3dTcxjjtXuP4Ykh+4gnEYQCJB9+oF86RwWVkl4GQX6g9uodwAQv
	 rOoIqYrnLDyPflQjcW79vFGsauq9PhOB7Iipa1Ua9mijFwC8hhuITh5kB8d/Dy4qOd
	 4vm0an76o3gbjJr8nrTrdqX/Tpe3nDak4Say8Nd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/317] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Thu, 13 Jun 2024 13:30:46 +0200
Message-ID: <20240613113248.629382074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 57ce8a4e162599cf9adafef1f29763160a8e5564 ]

Since sha256_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: d34a460092d8 ("crypto: sha256 - Optimized sha256 x86_64 routine using AVX2's RORX instructions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 3439aaf4295d2..81c8053152bb9 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -711,6 +711,7 @@ done_hash:
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
-- 
2.43.0



