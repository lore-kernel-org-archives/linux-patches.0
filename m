Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C30538DC7;
	Tue, 27 Aug 2024 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770290; cv=none; b=S/4oJ+lKq5S5jA0L3sKiGzW5epXzx7sy0/hs7wtDrL2EqzUA/rUrivC42M7C27AbUDOAv1s35gAPK+HnqfF+L310yVku0q7+79X6yqldFTA2Ihp6v8I8lYVez+P4Hsyr70nEHf+bnJ/glsjVa1t88wpb95BIIcC7EuQ+vur3HuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770290; c=relaxed/simple;
	bh=izTJHPAfHoaAKQXOVNPkNbZEFLy3G2CnHlX6avC1tNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGGbD8Yww86ijWA+6Mwap1tUVqYEWB/iKsqirBpQFx7fK4O9V3eJqim8h/WhlM6Ly4y5u/tkHxguNh7vhvc/cOt22aYlLYTwlKG0xFy/QaxrYXH9r44HeKTrWd9JTL8nWRfrfG1hRT65IbyPlSU7PG8zFQ3KxBf5XmMfNJNBdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV0E9RFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV0E9RFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE7CC4DE03;
	Tue, 27 Aug 2024 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770289;
	bh=izTJHPAfHoaAKQXOVNPkNbZEFLy3G2CnHlX6avC1tNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV0E9RFb8iYOT403SGwz9Rr0Cte+6fqlW5ElLi8wHPIij3fVO5MlkifgTi8Dyh4zO
	 7pOVgI8OM2HP1ONlOVG2TZkChASHCHTQJTa1UQES8a4RxdufbUpi2eaBAv3XU2/jlD
	 ncH9BqMWpounic8azZp1GlsF2gHPG0T7b0bb6FcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/341] powerpc/boot: Only free if realloc() succeeds
Date: Tue, 27 Aug 2024 16:36:54 +0200
Message-ID: <20240827143850.376737128@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f2d5bccaca3e8c09c9b9c8485375f7bdbb2631d2 ]

simple_realloc() frees the original buffer (ptr) even if the
reallocation failed.

Fix it to behave like standard realloc() and only free the original
buffer if the reallocation succeeded.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240229115149.749264-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simple_alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/simple_alloc.c b/arch/powerpc/boot/simple_alloc.c
index db9aaa5face3f..d07796fdf91aa 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -112,10 +112,11 @@ static void *simple_realloc(void *ptr, unsigned long size)
 		return ptr;
 
 	new = simple_malloc(size);
-	if (new)
+	if (new) {
 		memcpy(new, ptr, p->size);
+		simple_free(ptr);
+	}
 
-	simple_free(ptr);
 	return new;
 }
 
-- 
2.43.0



