Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C5A1EB5B;
	Sun,  1 Sep 2024 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210088; cv=none; b=C97DjW63tN9ek54mEqzJVj1Lj86WU9xy1on5sjQBvtEjFh/lX/ydKPoAJHicSn92ZnyLLT4HeRQy3nUedDrRAAOOfEJrkRhyqSvug8WcQy8N2DRaBqn9C+JGpRyO3hOfoVb024d2IWUIRqkTPcWibK+MY7zFP7Rq6zu8Q0v14+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210088; c=relaxed/simple;
	bh=VB+DBQBf/VpF0cfWACyQdWS1Ed1dfGHC0IE6wjyvlxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsBJ4Vfuc7XfaN7rhoRa6tvJtgSWbA4xS/DB1TkOAAyGbBsly+jjxI0AuXb/mF+A2j6fB5pL9ZN/qrt+JJVjn5cotGlTRh9b3NQpDLRTR1U0SYqlyhhVFXMN5AbiRtUSFOSn9xgNF/7Rum2Sx6u3uWNKv0Z2l0PnvIbQPReI2Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNUIZA9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNUIZA9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B57C4CEC3;
	Sun,  1 Sep 2024 17:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210087;
	bh=VB+DBQBf/VpF0cfWACyQdWS1Ed1dfGHC0IE6wjyvlxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNUIZA9a7M/teuHX5SerWskbZ/24dKuEZWaTgRzJljoz7GsxpGpJ8sphofE3wCqH+
	 YVGFd8quQfCaKyxoQzjMOsE8M+RXRsaexdxwyh39Cljd+GETuGXseJQTqeWgQhjghj
	 sDAA11zEGw+3nFJU8BkQOTAajRRnXK23IAbl9rCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/215] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Sun,  1 Sep 2024 18:16:37 +0200
Message-ID: <20240901160826.569263920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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



