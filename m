Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB97B158872;
	Tue,  9 Jul 2024 11:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524606; cv=none; b=B0au+GI5yjuwk5pVDrE+5MkhdjRZ5RUh6cfYuV5YVQXcPHlVYmk1MuFDqQUqeOLtUmiLhPnGrZgHxPLnq5X7H59Smw0SXnHIUUUOwzJhuWuBiqtZyEpZxA0N+fmB9Q9ZKKcc5CIOKclV6ZAXeQqqkSw1tLBWHTzwibQernu6Ess=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524606; c=relaxed/simple;
	bh=5pK/tMVTcYSg84XVui0HoXD1gkCHb7FvcWh59nWHyJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhrW+JsE211TcB3u3RpW0MaVy8fSxSXwr5TWrBpY8FdmEdRHQtTC7vg6aJxYkuQLH6ibN4AIthK7CnqPfxAHLkLikB1rNZR9v2v1iQWNYLxPjkGB/I6Qi990eYu0cVi6XsdiZwRYsmREIiMaNF4sgQ/sHsQc7HE5ZoY3TCSF+3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeftsoYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeftsoYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C57C3277B;
	Tue,  9 Jul 2024 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524606;
	bh=5pK/tMVTcYSg84XVui0HoXD1gkCHb7FvcWh59nWHyJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeftsoYOaNyd0elb0qRc5TzM83P1iBMiLOar4cQqZG5B/Lxb1efQPJq+h7UhTNdPD
	 O+f/y7ih3Q94UB1fddYnZrWOJVJpK1kES8VNZ1wDKamYsS4DxyQMo8pYNyW4GkJZga
	 cOEBg+78YVEnq96le337gIRhxWWgljTgvUty2c14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/102] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue,  9 Jul 2024 13:10:02 +0200
Message-ID: <20240709110652.895703661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index c907f747d2a04..26861b09293f1 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -250,8 +250,8 @@ static inline void __load_psw(psw_t psw)
  */
 static __always_inline void __load_psw_mask(unsigned long mask)
 {
+	psw_t psw __uninitialized;
 	unsigned long addr;
-	psw_t psw;
 
 	psw.mask = mask;
 
-- 
2.43.0



