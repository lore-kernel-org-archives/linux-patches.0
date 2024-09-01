Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37108183CA3;
	Sun,  1 Sep 2024 16:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207645; cv=none; b=S8a8ojj7fctWCxsYWonRzWBhEn24yjzYSu2flXlQDyRcIYUp7bwKbKvFhp+aACWKG47PwDvxf5osI+Z+NwE5/27fMrbzeM8Ty7HtmMEfqYNh7ogI4ygXSGCyCBPGrJKDKTXl2AU4f5yvM7qS8L/n3Yw5D2aCq/5AWOfBnZxCQ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207645; c=relaxed/simple;
	bh=kOZ+fnJPh/d7IDRRdnsAvBpXGxmuPs5rg0rtSxbqENk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzViiwGxiDUOk4K1S+CqsGbfR+8MWIu63WHmwvEReEdU3oOQsdofZJvIfrESjywKhBP+Fm2/5dZ7y/GqJsC2xwh/OtUpcUIdS2gBoKdXy/UnbcnaPD/NgObCToz4wYWjgfRnL3MVKYxBvB4H9OOHEkyzcUkE7MtSjFZSH0tBMkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTJ1F7IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTJ1F7IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE24C4CEC3;
	Sun,  1 Sep 2024 16:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207645;
	bh=kOZ+fnJPh/d7IDRRdnsAvBpXGxmuPs5rg0rtSxbqENk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTJ1F7IX5Ppi27h5pm2/okzB1ksw3AkAgpiiCJdgC/AUZkZgWOpDp82RCZi5noY5J
	 IhROzgH85WcYUAGuN+rRbsDNQUVpmuG9v9HQwA767Tx0p97VYkO1oZt13a2pLZXzFd
	 vuHjNaK1/zd89a9kftErIthZQht/g7+wu0gCuj50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/98] powerpc/boot: Only free if realloc() succeeds
Date: Sun,  1 Sep 2024 18:16:05 +0200
Message-ID: <20240901160805.022637025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



