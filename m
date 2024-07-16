Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248D1DA4D;
	Tue, 16 Jul 2024 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144771; cv=none; b=B8O6+i81JmcpQsC2b7ZSJ7HOMVYJZFM2pxe3yqwKDaPeATmWPnfhf0vOEj+39Wa1ZgVM+ZNa0+uapA6rn4oVlAWv/Rzb8zN/qyPgR4z62TNZWTntxQSyV8cdpEOBTW3i6nH34fSUlhSyUjUFczst1hRMadvN+Ov4bUXm5t+cs24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144771; c=relaxed/simple;
	bh=aQj+Zyg1JBcHBpLWK9QoO4EWwQCWDndVgVM/RESOU64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQMn6EQJxEQmcnQC81etc2c0n1/NvSkt+sV6l22U3scDrGMpTlrwWRrUWAAs89cYVPAXIf0tte5obg/sq0/sblAUsq+qdH6my/ubItJgj4FyEvHPqXn/fLal6ogJ0ujq/M8fUWee3XqYeqhj9deuUsFdzZoCpuPh3KDJBfa8+qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bA4Aj9dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bA4Aj9dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4975FC116B1;
	Tue, 16 Jul 2024 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144771;
	bh=aQj+Zyg1JBcHBpLWK9QoO4EWwQCWDndVgVM/RESOU64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bA4Aj9dJbXQjnfmZ67u9TeRKfrXfzwB/oWe+CrICWlCBp3Qfy3+wLQoeKYpBevWxV
	 GCist0E5miKNz2hxL+0fsQMZMVGjPFZKbXh2D9jTZBjo1qXxZwfpihFOEADw7QA5Xq
	 7RQeDm7eaJ/AjRlAVklrVgrUs66+MMEZZ/SfP1Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/108] s390: Mark psw in __load_psw_mask() as __unitialized
Date: Tue, 16 Jul 2024 17:31:25 +0200
Message-ID: <20240716152748.670825915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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
index 0987c3fc45f58..95ed01a3536c6 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -252,8 +252,8 @@ static inline void __load_psw(psw_t psw)
  */
 static __always_inline void __load_psw_mask(unsigned long mask)
 {
+	psw_t psw __uninitialized;
 	unsigned long addr;
-	psw_t psw;
 
 	psw.mask = mask;
 
-- 
2.43.0



