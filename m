Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6491DDCE;
	Tue, 16 Jul 2024 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146314; cv=none; b=UeV0uQskje6KORSwBJ8RGffzErlnPqEZGiuLdZV1n/6nNX3Lczdoo8IL4df5QjE0LSOMmDirZFcLJMPVNhhwePbXIvtjGsf/z/Gb3GWGlzs3FsXvzkdxJ4anOchgl9Kyk45iW7112qBEzs08YBo3uNJZ7dJeXuZQTcpdjk4cUQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146314; c=relaxed/simple;
	bh=z5b+3iMVNgrKFuAEXTeAJZOTPsg2Yk/vYH16W1liTZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXxCCpZ27o/Belf07tysjRW8F5d6H/WDWorgKyAR3rEQuYKCR9QjG2+ScxjHumJSWq/Kdu2Qr58VQYnVWH6xKohkMKsSZIfqpudqfIVEhxVngRVz2z2BUS6eWZm05/UbxR4sycph5VcLJthCc3uNB/+h4YLrZvQLUJgJe2oMWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBDYb3XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBDYb3XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907A7C116B1;
	Tue, 16 Jul 2024 16:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146314;
	bh=z5b+3iMVNgrKFuAEXTeAJZOTPsg2Yk/vYH16W1liTZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBDYb3XItz37DhNQ41bsaaRjrNMhSJ+ca22w+WKvcatwOtbwpwDJgyF6+cibkha3w
	 1xsbgnB1eAyY4Ze9Np4Sv0EWmLtzuBiIhPtwn57GHOrX0kS0m/Z4lhC+P0q7law+WR
	 1PKfqg3sk6kxlYYVmZPNC9VzGA+QB5oR9mAJa0ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/144] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue, 16 Jul 2024 17:32:44 +0200
Message-ID: <20240716152756.191577728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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
index d7ca76bb2720f..2ba16e67c96d5 100644
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



