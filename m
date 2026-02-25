Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A9A26ED33;
	Wed, 25 Feb 2026 01:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983663; cv=none; b=oHSko5y6yanqzBpcIFDrfOFXIhfaAjVV7IP3dgxsrGsP0Ausc5V9GHn+LVKQnjlC0I/qjbmaV8n2a+3oWhAoAz/wTUQf4OA6g8DP112aPpcdPaje5IBs341neCrCyUP2mIvd61Jov0DEqkW1P9Hm9adbE/4FXmOlBdHlIdbbuGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983663; c=relaxed/simple;
	bh=6LpMv7Fle0eczVYRsF28QfDX7JYRGBoAbDZ5owSLmHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC4BrYZu5CmvgzzroMTBxCPNGZJ/w2APkydHO1k4IxcKdxO9YxMDxlqtqrr+59mSsqPBazeUZw2zbiXxr/jkRHf4RT0PMGHNvgzVpcpz7ifHdg5Ynh7wwz1uAiFc5HfNzUillC3Hc+bVlEUqqiqIjuXXwKsgKclXz0ZwVelgK70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbjXJQtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbjXJQtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4400C116D0;
	Wed, 25 Feb 2026 01:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983662;
	bh=6LpMv7Fle0eczVYRsF28QfDX7JYRGBoAbDZ5owSLmHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbjXJQtvt8QngJgr3DZQw30mCYAiGB4LT4N83rwLJ2Wydk1qpDnh4lfiruqynEXir
	 kIWMe1VRjrttrHBbKeUn5PXAMhqUYMcCJJjBFbH58MUVE2wyXYG32AwoyF/5OkYyvE
	 PER/Him8FdgFNWJEG0R56T3nNSgdzIriz2UmabGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 694/781] apparmor: Fix & Optimize table creation from possibly unaligned memory
Date: Tue, 24 Feb 2026 17:23:23 -0800
Message-ID: <20260225012416.779556702@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 security/apparmor/match.c         |  7 +++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 1fbe82f5021b1..0dde8eda3d1a5 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -104,16 +104,18 @@ struct aa_dfa {
 	struct table_header *tables[YYTD_ID_TSIZE];
 };
 
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
index 26e82ba879d44..bbeb3be68572f 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -67,14 +67,13 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
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
2.51.0



