Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1772FE541;
	Tue, 16 Jul 2024 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144245; cv=none; b=KTB+29fVQNRTPCBs6/H9CayrfboNWPAaUMn1z6e/Oh69cFJs9bylx07mrO3DU2YaR7IKyaSWVv8XY2XwtBQBb98yiW9yDfQKdGhZPqu1vhLLmX3GfnVZOTVJbbgzeaBdE/xa2bEJ6TewUqk1aMWZL0Nsw0vTWemSZSoj/FGD/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144245; c=relaxed/simple;
	bh=Ke5j/Krsd8+LYOYTrPH65fGFwcbG4Fh/FfRlrXRilI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlx95KI+Oa9M6Kg92OVQYOgvICnzKmZea48n2TR3bJD9IXSebqOzV5f1a9rH3YxsRkEVX2BYbMnz56xia6/4y40jE6bxUUdJEEEi07o5+G1E63jtY8iP64tYZrc9nq9MXjCaZg6zS1FjYWVkkauipGg7vxkQl6ZtX3aM24b8jeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ5/UIel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ5/UIel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FB2C116B1;
	Tue, 16 Jul 2024 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144245;
	bh=Ke5j/Krsd8+LYOYTrPH65fGFwcbG4Fh/FfRlrXRilI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ5/UIelBTOl/oux/lSxQdccugHeRdhWfhJFeNDw+7BJQJcUZj9JwgfSyt9A3AnQe
	 gehUvJZoz9X6sCceWNYk/XtffewT8xmadbC1qbEH4J0oG6vON+HoD70mbdkIVzD+lk
	 J+PDhzd3HAY1aA77oLxX6GzNZRYMfy00ddHBpkrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/66] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue, 16 Jul 2024 17:31:22 +0200
Message-ID: <20240716152739.963300899@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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
index 7f2953c15c37b..93ba3befd6d40 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -289,8 +289,8 @@ static inline void __load_psw(psw_t psw)
  */
 static inline void __load_psw_mask(unsigned long mask)
 {
+	psw_t psw __uninitialized;
 	unsigned long addr;
-	psw_t psw;
 
 	psw.mask = mask;
 
-- 
2.43.0



