Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167C9335BA;
	Thu, 13 Feb 2025 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460158; cv=none; b=rRqz0SLp0ltv6PXaFo1RL8UI1QjfrC2sJkgGDA1MLK3scr7fIV02bzDLriy7iT5/IBOXGb5+sqIg+sDVwxIapbWlHturd6lT7J4v3xO2MOCoUh5PXc+3TvvwvPk1vbj0EiLxiMLtSnCf3stfofi1QJ+WTIex0/XxQ7OFvhQtLu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460158; c=relaxed/simple;
	bh=ucucFfSD1EwT17bLwMDVCTRxCtXsVkC3X35dgl09nxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RImf6WRIr5s+5UzZx95BGuXWYEionYRlJfZPgb9fRBSqnP2O2S4QnkjuI2e2iH7xNg8VXN+Dyxs0FDN6yNiwaA1GNWXaMgM0XNNJVj+/jXtNUIen0YliLdJ2ULVCmFR69ZxjLdRCDuz1ghfECF6WmUXzZenddA5CEez4Z9uqq/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqxJRSTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqxJRSTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5B4C4CED1;
	Thu, 13 Feb 2025 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460158;
	bh=ucucFfSD1EwT17bLwMDVCTRxCtXsVkC3X35dgl09nxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqxJRSTZQyP0TPPi1SA1SQvBsMI9Rs6Y0CYsq5IeXy/JK9WaT1GVX20bARdDGAxjI
	 8jOHpyQnNfMhmJ4mpcBoxrNfqTJzIVbfbliYsXApyL1VvijIjiGnlrlBRDTCeK1loG
	 CXkLYYXN+MFWHCJ8guXzqtxX84RYpqS+lSZlJjAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/273] s390/stackleak: Use exrl instead of ex in __stackleak_poison()
Date: Thu, 13 Feb 2025 15:26:17 +0100
Message-ID: <20250213142407.569845380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit a88c26bb8e04ee5f2678225c0130a5fbc08eef85 ]

exrl is present in all machines currently supported, therefore prefer
it over ex. This saves one instruction and doesn't need an additional
register to hold the address of the target instruction.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index e7338ed540d8f..2f373e8cfed33 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -140,8 +140,7 @@ static __always_inline void __stackleak_poison(unsigned long erase_low,
 		"	la	%[addr],256(%[addr])\n"
 		"	brctg	%[tmp],0b\n"
 		"1:	stg	%[poison],0(%[addr])\n"
-		"	larl	%[tmp],3f\n"
-		"	ex	%[count],0(%[tmp])\n"
+		"	exrl	%[count],3f\n"
 		"	j	4f\n"
 		"2:	stg	%[poison],0(%[addr])\n"
 		"	j	4f\n"
-- 
2.39.5



