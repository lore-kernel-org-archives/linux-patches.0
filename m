Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9462222DB;
	Thu, 13 Feb 2025 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457124; cv=none; b=kNnkp2Fb97qPrzTLwbcuHAPq8bE8wFLtBCU2WX1iT5rB/3voaCVKXwCnBAceHIPu716IbunoPtwHKLn6N3ZGTh8bkCbXZY6lDj+UK3/K/pLxliXKUHd2Fr91nTRZzZsKCIzSZRYvhd3e6CIQrIg5Bff9IJMHgrPxM3qT9ngPLkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457124; c=relaxed/simple;
	bh=vIgYoy+w621l+67KOQHNZox2u7gJaZvQWRgpaffiQdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeKsbrwQKj+GRvsS6DNAAieiw38fP97iYAS8DK3vbG307KzqvaE6Kiu63gzXJLZ6imSg/TbwJLVt2+x3W//CFFOrMlwPLNPlIO807xI3wszuY7JjE8VmWSf8NiKW2FXtMegNptJOX0Mkl6uFInOZGdDyX+potHdQWN4hMAXTOmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkUaYm3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkUaYm3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874FDC4CEE4;
	Thu, 13 Feb 2025 14:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457124;
	bh=vIgYoy+w621l+67KOQHNZox2u7gJaZvQWRgpaffiQdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkUaYm3imMNvISh06d0GXsBP4JvSJYnxemAoFW+9mjJlw4NoGcUvrWlm17NTmSCvb
	 Qougj4WsmNDGIGC27pqpshGvosajCvSr7uuNxGQUoDVW2kPou8UQJhdFyVy99xBpeI
	 939dL1p6+ui4I5GXXjd91yPCSMjP/YDypYjuwO6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/422] s390/stackleak: Use exrl instead of ex in __stackleak_poison()
Date: Thu, 13 Feb 2025 15:22:36 +0100
Message-ID: <20250213142436.708506695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9a5236acc0a86..21ae93cbd8e47 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -162,8 +162,7 @@ static __always_inline void __stackleak_poison(unsigned long erase_low,
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



