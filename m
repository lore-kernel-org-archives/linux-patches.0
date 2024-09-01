Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A9526AC1;
	Sun,  1 Sep 2024 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210091; cv=none; b=epE8kbyjO6LwgcfbP1KiaWW1Y4qCBXqC+Ey8ZjoVDazx617UA4H8M41mwM85cIJCCqS87JyEYdU80G8UHPnGEVh1leI5YcTXtuGkXrKRV+vTWWRnbLce6QXQnU5V6G5d9zUujsUMgXwukNXTk+PBra2TtBOy0ejPfzFM5/ZNKF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210091; c=relaxed/simple;
	bh=1WtReWD8O1eA2XyE6T2m9EJHg9gtnxM6XjxyyEK5DA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVT07aYtEp66ubgX7IHbh3pzYYd8np3GUYVYXsLhFG1RpdsqPMumg9L/Z4Hx1+0mdWi6ZwHgFC4rNB6KrIOkjX9Kc+0uox9+zW8nVOpp96zi7hwkUxTiEbeOTLJq4XEeRbsi74rYvw62rE5YR4RY3uyI7cPPuZh7fzKhVVgG8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usln91cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usln91cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E04C4CEC3;
	Sun,  1 Sep 2024 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210090;
	bh=1WtReWD8O1eA2XyE6T2m9EJHg9gtnxM6XjxyyEK5DA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usln91cvdUjcoXFj9HWGcTS5BQ6vimpVyM6ozP6OFFqr7SiaTIxECYXIwJZcYWcou
	 OctqKQSmmlQz8RhtDuzHv9atH/hClmidAUCq24GMRXVIHwPpkYF8FGEOD5knsINgwG
	 ODW5bVINQwfaG1YY4Nz66ZEuPb1qScQWBl6pXYJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/215] powerpc/boot: Only free if realloc() succeeds
Date: Sun,  1 Sep 2024 18:16:38 +0200
Message-ID: <20240901160826.606534079@linuxfoundation.org>
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



