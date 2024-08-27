Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEB9148302;
	Tue, 27 Aug 2024 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772315; cv=none; b=rKXWstzx3B8sCEnnN8flh+6g63Qk1IBIopkyRj9DccSu8ATl23+b7n6D/fhgRk3xJuaXiXUVIkFXfGlZWMFUAA+IcSVO3sa0vx/iBWqOw5s5I778gw0KvfJfzVxG5SuNePgoH3Q7KVmO6Bn8VfvUOTr1q6waA2pK4N+CYdQ6gro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772315; c=relaxed/simple;
	bh=KZ6LtXZUwEbpsiy8GWqfBEsAvf1Gg2RWP8Hx8NthBEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhP+3tgBLlxQD1bXA8m+AHlPoIDFx2VvXwMDpua4V7S7r+iLSpeqKS/xJQkT3xLTFn3fcXzb4q/srOGMKdv/cdEsrFXxq1B9CXv1j9cgkBDbw/Lm5wFY9nQ9SPpJFqh6YJqVfF+J7KmEIPm35vlgaV1C2vQftySt28VWCqU+w78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWoeypSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWoeypSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E51C61071;
	Tue, 27 Aug 2024 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772314;
	bh=KZ6LtXZUwEbpsiy8GWqfBEsAvf1Gg2RWP8Hx8NthBEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWoeypSDR9IY7BqUm+FaWcS5ut0Fsen9SHxOentc72/oLem3zupP6i2Fs85dXq7bP
	 IW24UWkzoZpYTj6dKQRm1GNrLoOOtHluygMlJDEIJ2mDM33AhXFUWMTyIiiNQBGvNr
	 cx1wHEvdE/w4LCzLT66iMQaZ1+gU43HjYodtOXf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/321] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Tue, 27 Aug 2024 16:38:06 +0200
Message-ID: <20240827143845.006503867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 267d6524caac4..db9aaa5face3f 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -112,7 +112,9 @@ static void *simple_realloc(void *ptr, unsigned long size)
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



