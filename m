Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2531C68C;
	Sun,  1 Sep 2024 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208896; cv=none; b=Ku3ligTbknVnUYQ3g34mUAj7paSqPmz6t8CiiSiy/VVOUP0jRB5bDt2zQYw5sPwH+onkc8j76+Zw2NNY7f43LBdK4S4CZd1bE6o8Yh68VCbEvwLYP2H+t+LnWpKfEH/zr+6GKcbDVrMvLS5LGP3Bhw3Dzg2XE1AMeVTryRKEL5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208896; c=relaxed/simple;
	bh=DJu42gCL+nzYO3HHGn2B9anzRzO/mNev1OPqSlZ6+44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXqkkLgjs6II7bVQhFuTNJBCHLzkK3jhXaIodfqbUIZj3+Jga54Sh6JBw3eRPQHqtRMQNqeKsBZ3kWkKhX+TCbRK/CT32+ItIjhD3LSTiwemWQ6KRs4YxKWsu4AQQA5DbOvzebgaE7cd8BpEeM6+BE3trHDpVpCy9CtywbgZUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYwtGM4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYwtGM4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1CDC4CEC3;
	Sun,  1 Sep 2024 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208895;
	bh=DJu42gCL+nzYO3HHGn2B9anzRzO/mNev1OPqSlZ6+44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYwtGM4gogyzsT+3Y9nMtr7+W5t/LBO1M+yl3HCdSn715XAe4kWIjTf3jufZUlf1k
	 TNbNs2zv4MtHJXVPf+fHlC9YcTCqE9MED7lx1V+1oE1qyjrullyLuTRoj5ETURbwxn
	 LR+oGsgbWh4IBptjnCNZexeKlVGqEl9IZKNIXEGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/134] powerpc/boot: Only free if realloc() succeeds
Date: Sun,  1 Sep 2024 18:16:41 +0200
Message-ID: <20240901160812.178149626@linuxfoundation.org>
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
index 188c4f996512a..bc99f75b8582d 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -114,10 +114,11 @@ static void *simple_realloc(void *ptr, unsigned long size)
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



