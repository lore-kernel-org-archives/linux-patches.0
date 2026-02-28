Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010D44BC94
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301157; cv=none; b=rYfRInqOnQZu6tWNz5dJOxppKweuperw5AQhAm91daOQWhmVn6lVW8hAqQYr/rlEcEEA4QgveKFGNT/zljAB3SI3fucUKqOTtczt8e3ptVtPAj3SaRdrUWbnCHEKPwVyZHXBlm8Ay/ryYoXUTTj9kdtV1kYpXaHK6Z/urlvfnBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301157; c=relaxed/simple;
	bh=ghFaaLmJj1iPLJhplCjQVJwlTyugZcyZZUzRtfbzkyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNzp+Au9BOOd1NWBhQGqyc9Q70HmdspWKN1Hrt6PGw5TF9SIXGUGG716NzaJTTh2zDolwkVIGXfg5ZKx3q7if0s0RNZgw8ZaSjwzMJSGZ6SWAS2G+GGkga6b3B4Y7KNREwEzKUIF5K3H50vji6Xtapcm5mNzNNhnO9UJ5FqN46M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDYyKM3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDYyKM3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D280DC116D0;
	Sat, 28 Feb 2026 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301157;
	bh=ghFaaLmJj1iPLJhplCjQVJwlTyugZcyZZUzRtfbzkyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDYyKM3ElhqfvfDPMcCyg4IbLxGeOM5NVelJjd5WpuxfWX6okUB9G6R7APQe4RLTS
	 RPE4STTuldpBSQq1VV60ZH8G672OfniwSUbJqq2R+qdTjb/PKv4V8at0MD9dorhnHl
	 8+m2Xc4tGJ8TGBplv8GnUGhES65cG9H8cX5dbynJvdM5Pfnw+XOAZVmCeZRlBSdqQR
	 qoV1Vt6OPvoJ4luhZadqeZU4OqyL1WHsrNb4A1+1DMcRXV6iZaWRzRDAs936+tSh4O
	 qwnsqyeAM5PErAM2zPWYicpU6lgBW5qiAtOk9S2OPtwjIOjJIj4nHVYmQ8YTFDpam0
	 ztD4HvU7oSvRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Palmer <daniel@thingy.jp>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/752] m68k: nommu: fix memmove() with differently aligned src and dest for 68000
Date: Sat, 28 Feb 2026 12:40:32 -0500
Message-ID: <20260228174750.1542406-321-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit 590fe2f46c8698bb758f9002cb247ca10ce95569 ]

68000 has different alignment needs to 68020+.
memcpy() checks if the destination is aligned and does a smaller copy
to fix the alignment and then critically for 68000 it checks if the
source is still unaligned and if it is reverts to smaller copies.

memmove() does not currently do the second part and malfunctions if
one of the pointers is aligned and the other isn't.

This is apparently getting triggered by printk. If I put breakpoints
into the new checks added by this commit the first hit looks like this:

memmove (n=205, src=0x2f3971 <printk_shared_pbufs+205>, dest=0x2f3980 <printk_shared_pbufs+220>) at arch/m68k/lib/memmove.c:82

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/lib/memmove.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/m68k/lib/memmove.c b/arch/m68k/lib/memmove.c
index 6519f7f349f66..e33f00b02e4c0 100644
--- a/arch/m68k/lib/memmove.c
+++ b/arch/m68k/lib/memmove.c
@@ -24,6 +24,15 @@ void *memmove(void *dest, const void *src, size_t n)
 			src = csrc;
 			n--;
 		}
+#if defined(CONFIG_M68000)
+		if ((long)src & 1) {
+			char *cdest = dest;
+			const char *csrc = src;
+			for (; n; n--)
+				*cdest++ = *csrc++;
+			return xdest;
+		}
+#endif
 		if (n > 2 && (long)dest & 2) {
 			short *sdest = dest;
 			const short *ssrc = src;
@@ -66,6 +75,15 @@ void *memmove(void *dest, const void *src, size_t n)
 			src = csrc;
 			n--;
 		}
+#if defined(CONFIG_M68000)
+		if ((long)src & 1) {
+			char *cdest = dest;
+			const char *csrc = src;
+			for (; n; n--)
+				*--cdest = *--csrc;
+			return xdest;
+		}
+#endif
 		if (n > 2 && (long)dest & 2) {
 			short *sdest = dest;
 			const short *ssrc = src;
-- 
2.51.0

