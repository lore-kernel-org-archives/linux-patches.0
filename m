Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433B2D73A6;
	Sat, 17 Oct 2026 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256961; cv=none; b=ILyo0qNm5WzOxHHD6JgycnyxqSoQiOf5tYjhIqtSJzW7kWX+RyAxjnKN4xhTYdZJmlorYGOYQu/5XZr00Apt8PbAP9ClqW9MlUEsRyANbZSmW30WAtYdLbr06qg9qujMDpV74fuZukoOBgHtz+mA9ZJy/pP2tB9LWz/wrQFBe8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256961; c=relaxed/simple;
	bh=tDDkS5n25bP7kAS0BrATB1UcrcOjnMZXvzrIAeBBe84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tviDsNmWsd6tnYYmSzR1m+mquoyWU5TzA/UAGbLS1+cta7Fb4+UFCHH4hU0ZnjZfyBlN/uVk2a6Us5xOSy5RGrsrB5+9H4luM8aQuD9nNmfzaf3Z1MOrZPZTzpxp5JylVmzeJFpRqDW7aMnuaJteqwoADMpVbriAiaTjRIrcoRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKDnHvqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKDnHvqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30391F000C4;
	Sat, 17 Oct 2026 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256960;
	bh=u7msegj1ZMOXk8vAJojuxIGbcJcBEA56OaoY8NImouU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKDnHvqI2z5vLc7XxwjANNf+zD1Ws3cBQwOqxIoQkCOjoUOsneE/Q4sjWo+kF4WjU
	 TEwEmqX43IhKPZ3c+Hc2ppPj+sgWwZVOVLGsoWu/80bkfi0yLLRt/itQv2bbuQvm2U
	 466JzyzFpVUy/LKOkAGlkAapGDDjDqRXcT8wyObc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0407/1674] apparmor: Fix & Optimize table creation from possibly unaligned memory
Date: Sat, 17 Oct 2026 17:44:39 +0200
Message-ID: <20261017160441.567153114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/match.h | 12 +++++++-----
 security/apparmor/match.c         |  7 +++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index a86f74b59360a..14c0401f97c1b 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -102,16 +102,18 @@ struct aa_dfa {
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
index 19b44e705b261..0a3307cd41076 100644
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
2.53.0



