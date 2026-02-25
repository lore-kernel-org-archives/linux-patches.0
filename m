Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3934C2BDC03;
	Wed, 25 Feb 2026 06:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002763; cv=none; b=fSi/1Ye6GIGYBLTlsjUzbP9lTmLf/ZHfUkH14vW0qJvmsfN3JfauhOMRjFFebL1Ev5LOY/SHwVirlCi5CNQAS6HfGMi0Ta/PT0v9e2r6wNKnJUJtfEZ8X3muMHE8inbQLoMLnlW8uz8C7aALQBPHrJm16vAgMDUtWvrjFEXeU9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002763; c=relaxed/simple;
	bh=2fctJEa6om/HmzV7bEs0QVHGQbyqaRrtuoAlKQlxAyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RznrP8OiSXB5EZ07iQyq3PFi6uB6tzuNNAjbwSD6HzDj+axBNzyyfB7yAVCVRnOZo+VlXbloxskiRQuN437PnpPyWxSmbxBpBmcCc09L7SBlgcMBoRHo41/O1wG2Axfl7tofNpGcrdBztMmIURE/JKVJKqQRzuMNP7r1zUaRrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqbST/n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqbST/n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EB6C116D0;
	Wed, 25 Feb 2026 06:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002763;
	bh=2fctJEa6om/HmzV7bEs0QVHGQbyqaRrtuoAlKQlxAyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqbST/n4a4Lg/mqbrlCBrKSGJXecJTsadp0s6J3XUHMquWM6XnumBh4O714FwpHYa
	 5pmc8R/ZQxXNjshkFdgxIt5J6Amq/mc/VFfTuNmjCwRppc/HLbg1pPFFu4TCP8BsAG
	 hmDMpR261g9VkedZW3wQNAVTgEqPaz02DLYlevcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 566/641] apparmor: Fix & Optimize table creation from possibly unaligned memory
Date: Tue, 24 Feb 2026 17:24:52 -0800
Message-ID: <20260225012402.238896596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



