Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA82114A098;
	Tue, 23 Jan 2024 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969195; cv=none; b=KtD+q5iUvOia4xtKKM+5EheWwAO36jL+woFmjFkxDrXSgKkbWPlZkiaxLgYGQUcuoZz70G/nJFltkAzeM49qUCut0FFoDkMoKjZtzjkF3i+nDEhCtechql4j1d1ImQGb9kgrdrQiQgKHgPdjoZtpIHZZlgF46iq0YKPuACHwFPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969195; c=relaxed/simple;
	bh=Oa2uWNFmcQyXek/gStqqnYcxTJ2SS/bBa8+MM0XVksE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd/s8xB1WcJ/msAtwjZj9FzJtj5Je2yhNLTunjX4VBqOLXuzHDmc8+nJyXF6vc5u20BEOQpI/xvcPVOjBRxByeuhHP3z6q4+6hhez+3BKMSpwg9Bym+qa312Bl6+16fQ5Z5FxHqUYFBSaKZ7v9CDRyYl+/SdiRVqP+SQyUlyd4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pha0dZm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pha0dZm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B643C433C7;
	Tue, 23 Jan 2024 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969195;
	bh=Oa2uWNFmcQyXek/gStqqnYcxTJ2SS/bBa8+MM0XVksE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pha0dZm7FoMXQy1ITGXMvf8HJyOJvYujCldEWi4jYtnzBQhm8lNySnxHwqyuRbB3d
	 ECz94krpQg6N2B1lT0xIIHzW9/n1OBO+bk8GEZB1sv9q/84FJom4HpIyZCvadGVQa5
	 riR+Db29rHOYDrMCgpuuUFkVa5abFvZBkrSFMLrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McKay <david.mckay@codasip.com>,
	Stuart Menefy <stuart.menefy@codasip.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 091/641] asm-generic: Fix 32 bit __generic_cmpxchg_local
Date: Mon, 22 Jan 2024 15:49:55 -0800
Message-ID: <20240122235820.881634191@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David McKay <david.mckay@codasip.com>

[ Upstream commit d93cca2f3109f88c94a32d3322ec8b2854a9c339 ]

Commit 656e9007ef58 ("asm-generic: avoid __generic_cmpxchg_local
warnings") introduced a typo that means the code is incorrect for 32 bit
values. It will work fine for postive numbers, but will fail for
negative numbers on a system where longs are 64 bit.

Fixes: 656e9007ef58 ("asm-generic: avoid __generic_cmpxchg_local warnings")
Signed-off-by: David McKay <david.mckay@codasip.com>
Signed-off-by: Stuart Menefy <stuart.menefy@codasip.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/cmpxchg-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index 3df9f59a544e..f27d66fdc00a 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -34,7 +34,7 @@ static inline unsigned long __generic_cmpxchg_local(volatile void *ptr,
 			*(u16 *)ptr = (new & 0xffffu);
 		break;
 	case 4: prev = *(u32 *)ptr;
-		if (prev == (old & 0xffffffffffu))
+		if (prev == (old & 0xffffffffu))
 			*(u32 *)ptr = (new & 0xffffffffu);
 		break;
 	case 8: prev = *(u64 *)ptr;
-- 
2.43.0



