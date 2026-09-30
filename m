Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF243AFB11;
	Wed, 30 Sep 2026 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787050; cv=none; b=iG8VcDO7EauZzWmjl8hoFOpttlacKbU5gTtxKOAF84haq5J7r8MF+J2t7iymAgYTTDnFoQXrtvjeuvBILtEZKt5tZzrsXS5bAcvsyng2wSSPylgBzrhh3bh3ruSi0zxbom4oKS/XUFbygy+szOxhqsb4CV+VfrSfg5uDjbKJmuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787050; c=relaxed/simple;
	bh=p+1ht5K/agsaFh0mpBor8UIrmYtuR/bheIcgeB/Ri/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZtgARhz7IBelbRglz1/ZDgUKNDy0wNdbmqkSfaWEwwGHf7t8tcTCrUoP7ncyrKR7El/5FmBHPv8WnzHAVSJk/Ro7DLnl4dGwW5X2ZDrz2zq0gBh85Aim+adcyK98Kju1Afil/yviKBthgtyW4aiZJix8hma+9u6iwsGQ460RZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzLJxEZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzLJxEZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0B41F000FF;
	Wed, 30 Sep 2026 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787049;
	bh=VS9i91FaJofTsvsZ+RvAfFT3x+sVzgs0ws0QevkiU5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzLJxEZ3r8PXuIMMvh5AIG/qx08EYiNVTqWikGW66TfekZhU/eSVu3LZ/vH6jhyTb
	 j5AOlgpChpgkuC23Gf344UDnUl1krMMhhm9o2mrg1q+oSIDrPkuFQiiOFrVbrm+M0f
	 C4u70TqmfhABjcMTetrR7BTPnTNX6dS38s39x1RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 093/457] net: gue: reject invalid REMCSUM offsets
Date: Wed, 30 Sep 2026 17:23:18 +0200
Message-ID: <20260930152348.056166731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



