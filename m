Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1A62B9C7;
	Sun,  1 Sep 2024 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208861; cv=none; b=TWwiKuW5y1Pw2q4B6usuW1iJyRLRxY1gbiYpb+PlnN+iMBwLTjFT1COemjmLa3H82UYe0gvIOAj8kpb5aQCF9hCBy67UNOWiXpaa2s1aKts2x/SjlXVhqou5rubcHJ3a21fvvX/GI419vx8CRf0fymiCxxi9PQhxNZDbnGaRGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208861; c=relaxed/simple;
	bh=r6r39Oos/hOv2HKZWhZnPGu2Dw9lFIpNOqrtwsnF2I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhnBLzhaQxiu/s9ykf5bsclrbnjJytzDfRvVlXQcdXN+WCPTtPMz/9UOIaVhh0vQ40bTma86WgIg6FGgckwPR6mAyuNOcdQBTJkjCe/WjNXUKvimpzc1AVVJb8cBgHtN4/rsRhc9r8Rt4XtD0uk6wvf7MAq4rGIO+hCA06aQeKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjLgqh1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjLgqh1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD9AC4CEC3;
	Sun,  1 Sep 2024 16:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208860;
	bh=r6r39Oos/hOv2HKZWhZnPGu2Dw9lFIpNOqrtwsnF2I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjLgqh1YvsrUUGQ2JbSS7IdIb/Cp0N8105qEfqh2zc3zhFAp7UiI4KD8ratNxcB43
	 NGSPxlbDTrUpUoIAH09MThRxmCww9efQhFpjRSxr40c0FZ2T6cilTQwkxLuBkMmYtz
	 G+wDnHGKoCN29GRr2yp9G3Cn0ioLKtphO/zgE2Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/134] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Sun,  1 Sep 2024 18:16:40 +0200
Message-ID: <20240901160812.141282107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li zeming <zeming@nfschina.com>

[ Upstream commit 69b0194ccec033c208b071e019032c1919c2822d ]

simple_malloc() will return NULL when there is not enough memory left.
Check pointer 'new' before using it to copy the old data.

Signed-off-by: Li zeming <zeming@nfschina.com>
[mpe: Reword subject, use change log from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20221219021816.3012-1-zeming@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simple_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simple_alloc.c b/arch/powerpc/boot/simple_alloc.c
index 65ec135d01579..188c4f996512a 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -114,7 +114,9 @@ static void *simple_realloc(void *ptr, unsigned long size)
 		return ptr;
 
 	new = simple_malloc(size);
-	memcpy(new, ptr, p->size);
+	if (new)
+		memcpy(new, ptr, p->size);
+
 	simple_free(ptr);
 	return new;
 }
-- 
2.43.0



