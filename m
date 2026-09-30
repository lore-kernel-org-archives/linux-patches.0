Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3041407CEF;
	Wed, 30 Sep 2026 19:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796824; cv=none; b=Y0S++C8hl15mCa2KOt0dniao3qagBrMpkyD9xlUQUE51R3oe8sjDmzhV0zmvw+au+ORLNwv59fLuTyqfHJd97mBCibI/crgncEaKVLifhHG7MUB9PWwOYLoyfQy+2gDNUPWyfjiRorUuo8jw1Uv5NcpWe2Tpn3tzO/rCb3sjyu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796824; c=relaxed/simple;
	bh=ad+LcVBHo0aMyMQZ+fOvynga1fWu4qHSftLAPqRzIeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOFXY1qk1qfrLNjZ1cIIJIm91JkkCo39PV+4yFR+Rzosr+rW66873fe0VWeYyHtvbqoYFg3Br/rlNZ4jTdNa2+X7wK+vii9rRGoya15kdxONlqYz+CGYnGbblsxqKVf6QfUA4n+5g2TFVhJCA0vvNAfhtVaiTBE7/FSxZGAtWik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBWyHO55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBWyHO55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE0F1F00898;
	Wed, 30 Sep 2026 19:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796822;
	bh=rrhVxAu41fS8fcOxEIMWzhrPqjPcZR4oy1tYPW3ijmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBWyHO55ih195a+FvFj8t6fzvL1yskO10R2jbRqMZOwB6RFXM2chl15RDMsF4p0h9
	 da2NQqnuNUbRrlCgLTDl8FIU3gsBvidAiQlJsKr7Ar1TL1FtJP1uRz1L9Q5SYnIWi2
	 7c56qSk/qsTwczeC5ZALqG1nGRtefiu0LgB3+On8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1003/1193] net: gue: reject invalid REMCSUM offsets
Date: Wed, 30 Sep 2026 17:28:07 +0200
Message-ID: <20260930152456.525404010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



