Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5338B46A5E3;
	Tue, 21 Jul 2026 15:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648864; cv=none; b=tRzju0n9oqmPsXkhtHvvWN3IsPfbzBwbXoyKFw1bpxDpeAugTSdDCganwII+ocNWlSH+hG3T0FVI50f6vNONStDBOZIoSQiDoF7K6H/ddRh+ttCxtZ2zR6mpJePOpt0myiUsy1N28Co5lwsEK53zgnsHjwmVpvzhaTSPJEUfU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648864; c=relaxed/simple;
	bh=jcBlLR46SVZDR6AXPaWoL9ga/QK8njxp7ATHhiXrf0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKJc/TKyv8WmdUryZl9IZ3FgYn5AjrOS2MZns6GAdpU/cWqxWhrRXqGZrGPMCR/99lwVFmx+1u0hp+12hgtlI3HXRwbk+SqxkAsfH82P0TtBz+RAhx3UVOU6CxgN5Xpg6M48jgctNrCmQsCYx6h3MWRRuzeHJAqGWurAU+08h2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7FS1wqV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7FS1wqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9FA1F000E9;
	Tue, 21 Jul 2026 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648863;
	bh=LheUsqD5113vB69QVF8oQYbgwUocHuG096ua5XBVb18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7FS1wqVPpG3E/iOPZG/s95ilN+o/ZRPYtcR4LK/N82NM//s9gcrvySRYNyKwaUSC
	 o8Syzrr2nJ+ZML+ujX6zP77DS2W+3hojDr8aouO2BkUs16jPXeR3kny6pZ9LW3uhpQ
	 yCzzijHN8b7myJx+iU36rHBskh3ZoGa/tF2fAoRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0358/2077] lib/base64: validate before writing in decode tail path
Date: Tue, 21 Jul 2026 17:00:31 +0200
Message-ID: <20260721152601.133476204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

[ Upstream commit cae29a5787e38ce7ec7727a87ac7e393a85cb1ef ]

Patch series "lib/base64: decode fixes", v2.

Two small fixes for lib/base64.c:

1. base64_decode() writes a decoded byte to the output buffer before
   validating the input in the trailing-bytes path. Move the validity
   checks before any writes so dst is untouched on invalid input.

2. The @padding kernel-doc for base64_decode() was copy-pasted from
   base64_encode() and describes the wrong direction.

This patch (of 2):

The trailing-bytes path in base64_decode() writes a decoded byte to the
output buffer before checking whether the input characters are valid.  If
the input is malformed, garbage is written to dst before the function
returns -1.

Move the validity checks before any writes so the output buffer is left
untouched on invalid input.

Link: https://lore.kernel.org/20260324223210.47676-1-objecting@objecting.org
Link: https://lore.kernel.org/20260324223210.47676-2-objecting@objecting.org
Fixes: 9c7d3cf94d33 ("lib/base64: rework encode/decode for speed and stricter validation")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/base64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/base64.c b/lib/base64.c
index 41961a444028b6..20dacee25f6508 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -168,15 +168,16 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
 		return -1;
 
 	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
-	*bp++ = val >> 10;
 
 	if (srclen == 2) {
 		if (val & 0x800003ff)
 			return -1;
+		*bp++ = val >> 10;
 	} else {
 		val |= base64_rev_tables[s[2]];
 		if (val & 0x80000003)
 			return -1;
+		*bp++ = val >> 10;
 		*bp++ = val >> 2;
 	}
 	return bp - dst;
-- 
2.53.0



