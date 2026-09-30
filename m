Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F97511235;
	Wed, 30 Sep 2026 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793011; cv=none; b=ZlKKeRQMVRLhKLnM2KMNA4z1eS4NFS2/ol7yD0/5YbLgd0idVonwHtyeDFZ4yjYvWa2CnxPSnJ911odiL2d63vAyCwDmRMrb+X5M2Iua4lQs6wTehwieV5BXhch3JEnwx9rx+omcRUfgfvpXY1l6XhoM7Avtj8aiNsZ979TnDB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793011; c=relaxed/simple;
	bh=70Bb+ZiPic3EjeusXHqzqWYPwNIL/PSOc3WqmLphETE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xs6RvzSg1BKBGEjvKdiX6swBfJa44qw5ih4VgwnSEUztLnz1WU2t017jDVl0Bf725CxzXRn5sd4XMANHZCaXkEhyeikS7RoarfgTD9hd+a8YIaObUKK+9IOIb/46nkkx5ymABAjLN2g8w66nzqMafyAfFc9jx5GBkCgjTksPa8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq1Ng2y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq1Ng2y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199431F000FF;
	Wed, 30 Sep 2026 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793010;
	bh=25Izg1A0DuPQ6JuCIwQXQR6JCpCNKsLjtfBJn/c45oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iq1Ng2y9TK/abYgbl9V4U3UvbtozBYmqnbg5GQpiXf5MnIQzlj4gJ/70YGgUKG8by
	 AHvLX+dPDtDWvbfURlm04cjLFnAjJdbCTkR7+f25F47JtNw6K8MNKllED0GSh5ckKZ
	 k2NcEx9q2Sx7ub4UYmrzxpkx1NPIaPEni6nttHJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/395] net: gue: reject invalid REMCSUM offsets
Date: Wed, 30 Sep 2026 17:25:39 +0200
Message-ID: <20260930152342.311343716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



