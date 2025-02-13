Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEDD24292C;
	Thu, 13 Feb 2025 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458634; cv=none; b=GREaBCHe/oCQgBJ1p5RR6B/VDjm6363Cd5DyNRgIcROG3pgpiLwW43z16PdThTZDqd+fHabwedFu+wg20E/cMbmM9HluFMl32Oi0FnvUotTvHO/H9mwlMEV3qQywkh48+ryx5FP5S+BlB11wOJkKCDWUpbEnWN7pZ9a98wssGEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458634; c=relaxed/simple;
	bh=q+FEjk5AZCRqSg1/HjCKWnHoPAZ/LyL7Dzsh4iAj4Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quIa+xcEL+03ZyGBp9Bigp+vlbiPID0VYrtZY0yIHulREhy2+O3cW9GDZjM7UavX/CuzJKe1WOkKrl8/rUhfXWMkZdJuzqF/QhJgb3LTyxx9kdJcanWV+gHfpIBA51kwKrtO+vAsZg3sIW7B63IGDIf9aMLeMhsC+krpBly4aFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+jeI29D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+jeI29D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF97C4CEE5;
	Thu, 13 Feb 2025 14:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458633;
	bh=q+FEjk5AZCRqSg1/HjCKWnHoPAZ/LyL7Dzsh4iAj4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+jeI29DHFkDoO7hKS03z7wPChBu7x9DWaeGvGy3NXv/uegHrESgepXad35cyyM33
	 aDK2LDvY0203z4AatYMUkh9sO/jV5YoU+YG6c13Ki1GpALjEzFQ25tV1yysoSl88LM
	 +LiNafm6a+8bRZyyuS4pQokaiZTuYWQkdEbAUqXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 008/443] s390/stackleak: Use exrl instead of ex in __stackleak_poison()
Date: Thu, 13 Feb 2025 15:22:53 +0100
Message-ID: <20250213142440.941404117@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8761fd01a9f09..4f8d5592c2981 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -163,8 +163,7 @@ static __always_inline void __stackleak_poison(unsigned long erase_low,
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



