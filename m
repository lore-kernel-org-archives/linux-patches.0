Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B684C33D1;
	Wed, 30 Sep 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786382; cv=none; b=mfWMrZI9Gu9vsqqqBVaOu44pPsAEdO+lcbw4uw8W0Fwbltb6zDAZJgngqzSotTAfv7Oa7mlzNignh2VHsX72ueireugehuemVxs8kFNeYOj4GxpdvDXSpJkncykysPA9Sbc/CZRFokfYowhKWJASRlcW9ulzLadatIktO3/mUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786382; c=relaxed/simple;
	bh=umFpNgAYD1bVLnHDILZ7599pA3N9otc3qUvVzE5UG5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxVlMsf+GCsVlAdr+2FyA+VG1odSRWWxxcDT8AGXBkMLmgkctmzTL/dncwwy4uEMbVhVLkAfct9VqheOXV/a6Ff1H+JVnlB6qypw6jEZhMZb7FzouzzXFfBdL7KWxp4rql7LQxxO8x1BehOJrVYKVO4dbiVw33a3GXktoFHLVZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIpaXgEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIpaXgEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EFC1F000FF;
	Wed, 30 Sep 2026 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786381;
	bh=+CpPLTBgJ/RDXcDestkIZqvhbvrLD6LKBSw54ypjMtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIpaXgEtDkFQYBKWE88Re/gaMZiyn19qtrCcNz1aAA0GIitc6c0trQoqFWQ2QS61I
	 +tcJhZ3d35l5qjg0RE60ZZ0kkpLcuaoCiVW1YlZ5WffHyeMsFijaW5mLJls8Cf2Uw9
	 ACNyCyoNRT83dGkI8TmHPFgok++eby4VWZV03iOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 843/982] net: gue: reject invalid REMCSUM offsets
Date: Wed, 30 Sep 2026 17:26:19 +0200
Message-ID: <20260930152434.858107488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 2566866fc30965d915d0b52b5c3323b362619f0e ]

The REMCSUM option carries an absolute checksum start and checksum field
offset. gue_remcsum() passes them to skb_remcsum_process(), whose
partial path stores offset - start in the u16 skb->csum_offset variable.
If offset is less than start, this underflows.

A forwarded packet can retain CHECKSUM_PARTIAL and reach a NETIF_F_HW_CSUM
driver which trusts the metadata, leading skb_copy_and_csum_dev() to write
two bytes about 64 KiB beyond the destination buffer.

Reject reversed tuples in validate_gue_flags(), after the existing length
validation, so all GUE parsers enforce the ordering in one place.

Fixes: fe881ef11cf0 ("gue: Use checksum partial with remote checksum offload")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20260915124806.2852293-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gue.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index caefd6da86939..d377155fd0b31 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -84,8 +84,9 @@ static inline size_t guehdr_priv_flags_len(__be32 flags)
 }
 
 /* Validate standard and private flags. Returns non-zero (meaning invalid)
- * if there is an unknown standard or private flags, or the options length for
- * the flags exceeds the options length specific in hlen of the GUE header.
+ * if there is an unknown standard or private flags, if the options length for
+ * the flags exceeds the options length specified in hlen of the GUE header, or
+ * if a private option contains invalid data.
  */
 static inline int validate_gue_flags(struct guehdr *guehdr, size_t optlen)
 {
@@ -103,8 +104,8 @@ static inline int validate_gue_flags(struct guehdr *guehdr, size_t optlen)
 		/* Private flags are last four bytes accounted in
 		 * guehdr_flags_len
 		 */
-		__be32 pflags = *(__be32 *)((void *)&guehdr[1] +
-					    len - GUE_LEN_PRIV);
+		void *data = (void *)&guehdr[1] + len;
+		__be32 pflags = *(__be32 *)(data - GUE_LEN_PRIV);
 
 		if (pflags & ~GUE_PFLAGS_ALL)
 			return 1;
@@ -112,6 +113,16 @@ static inline int validate_gue_flags(struct guehdr *guehdr, size_t optlen)
 		len += guehdr_priv_flags_len(pflags);
 		if (len > optlen)
 			return 1;
+
+		if (pflags & GUE_PFLAG_REMCSUM) {
+			__be16 *pd = data;
+
+			/* The field offset pd[1] must not be less
+			 * than the start pd[0].
+			 */
+			if (ntohs(pd[1]) < ntohs(pd[0]))
+				return 1;
+		}
 	}
 
 	return 0;
-- 
2.53.0



