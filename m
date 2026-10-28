Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214915;
	b=kghT1mSALrISThX0BXudG/t+aqwKkIR4Yg+DIritrKoSMPpSSs4HrKQUnQ0SmGIQLjf5
	 GTFHqzgFOdLDBV/oaRoxC4RucCRYgzCxRDbh92VCExBdHKN1IFeYlJgeTQ4y73GOMZtDV
	 4W3086jtCxnJjiqUQLnuDEzSHTf7H4WJx6+UhQ7fivNoWXIA1A0iEsXetG7D+HVFnDSRH
	 tp//FiTS2wZ03difC+Iia3Vg9cLXLsw8fADcJDOMSz73K0W3z+ZCwSl44M+Kh8wwmlvyh
	 tVsXTs1PtH9Lx0npahTUiquBNMbOJDdbGMNV8wxGBv42DT9BhwxsV3c4UUdl4M9nwPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9TtkSYnhveD/H0CVOirVL9Qy1etIe/lXxyN3RQuMmA=;
	b=w90/HDpbYLK47qXzJ6qHGQeWIUPRUJOSpQzQ64Da+ki6vP58gcNebsx1vOd7CKtRmuSl
	 67CBmeBOUlMAclOg3USB+R/WE1JYx6r+i3nblcFgEDuZOvMgyx5N0vMYuSjTqSriHEvOb
	 RTGL8HhF6hXOnM6VhSlukMEIJfEnaNtBbeWGSSDpERiKvjRMfo/U7bofr30UQsRQyWXPH
	 NrlttvO1s07OxTwiYAg96FuELR/fPidRxxbPduJ7gSV5/+XRpty97eFh8xNhrWaV2T7OP
	 UxYCggaJWT0Z3ZE2wTDMtUyR7PoYbt5U5rlScGHJkTX2S1b8jRAqypRRJA3TsHHpV/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1WBPXAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189D5606A326;
	Wed, 28 Oct 2026 19:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1WBPXAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680081F01825;
	Wed, 28 Oct 2026 19:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214915;
	bh=b9TtkSYnhveD/H0CVOirVL9Qy1etIe/lXxyN3RQuMmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1WBPXARF3Lz7AwNER7hEmQgVIl1TAmKUjOzS2076y7PRNeD1BC+HONYcfaaggDVs
	 45m2jh792NmQ+yrKyn3nNPvvOmnaSW1NXbbC1t+1gyJwT1jW0tCeYpnWZd78gzz12h
	 CqN5adEdQmZbmkPdd8r2CUFeY4D1bqJpLwLGUZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1026/1887] apparmor: Fix & Optimize table creation from possibly unaligned memory
Date: Wed, 28 Oct 2026 17:52:02 +0100
Message-ID: <20261028170522.763156420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@kernel.org>

[ Upstream commit 6fc367bfd4c8886e6b1742aabbd1c0bdc310db3a ]

Source blob may come from userspace and might be unaligned.
Try to optize the copying process by avoiding unaligned memory accesses.

- Added Fixes tag
- Added "Fix &" to description as this doesn't just optimize but fixes
        a potential unaligned memory access
Fixes: e6e8bf418850d ("apparmor: fix restricted endian type warnings for dfa unpack")
Signed-off-by: Helge Deller <deller@gmx.de>
[jj: remove duplicate word "convert" in comment trigger checkpatch warning]
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h | 12 +++++++-----
 security/apparmor/match.c         |  8 ++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 611ae908469be..72562aaab9aea 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -105,16 +105,18 @@ struct aa_dfa {
 extern struct aa_dfa *nulldfa;
 extern struct aa_dfa *stacksplitdfa;
 
-#define byte_to_byte(X) (X)
-
 #define UNPACK_ARRAY(TABLE, BLOB, LEN, TTYPE, BTYPE, NTOHX)	\
 	do { \
 		typeof(LEN) __i; \
 		TTYPE *__t = (TTYPE *) TABLE; \
 		BTYPE *__b = (BTYPE *) BLOB; \
-		for (__i = 0; __i < LEN; __i++) { \
-			__t[__i] = NTOHX(__b[__i]); \
-		} \
+		BUILD_BUG_ON(sizeof(TTYPE) != sizeof(BTYPE)); \
+		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) \
+			memcpy(__t, __b, (LEN) * sizeof(BTYPE)); \
+		else /* copy & convert from big-endian */ \
+			for (__i = 0; __i < LEN; __i++) { \
+				__t[__i] = NTOHX(&__b[__i]); \
+			} \
 	} while (0)
 
 static inline size_t table_size(size_t len, size_t el_size)
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 8972d1b57b7a6..93d54dd7a065d 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -8,6 +8,7 @@
  * Copyright 2009-2012 Canonical Ltd.
  */
 
+#include <asm/unaligned.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -110,14 +111,13 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
 		table->td_flags = th.td_flags;
 		table->td_lolen = th.td_lolen;
 		if (th.td_flags == YYTD_DATA8)
-			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
-				     u8, u8, byte_to_byte);
+			memcpy(table->td_data, blob, th.td_lolen);
 		else if (th.td_flags == YYTD_DATA16)
 			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
-				     u16, __be16, be16_to_cpu);
+				     u16, __be16, get_unaligned_be16);
 		else if (th.td_flags == YYTD_DATA32)
 			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
-				     u32, __be32, be32_to_cpu);
+				     u32, __be32, get_unaligned_be32);
 		else
 			goto fail;
 		/* if table was vmalloced make sure the page tables are synced
-- 
2.53.0



