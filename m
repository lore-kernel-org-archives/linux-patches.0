Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908E3890F8;
	Sat, 17 Oct 2026 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253624; cv=none; b=eN7ecgsxlZ7SJ9EOYWo1bw4UP6n6gkdtp8NUnOnodSJsAirMOctHjLChH6UDQyfEMnEGXdeNFaFuTHhmYsTDYDwzNvBr5El6isYawEmS8kMAYsmmcUtHXvhz92S2OLBlxh54sAG31mo47HDWSb1GiJsvdqjGZDwr9pzeih77FAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253624; c=relaxed/simple;
	bh=/z2zc9d8WWQ14bPE+4CAKFrHB6QpjTJBuDTrbx4Cz20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKarjzodbGiG5Y/ah6Ru68X3LzDzV3fU9/fkku+bneMih6G0c/Gvrmqwpntxw/pkkh+Fb4KE/u6s2CrAYWrH3s91cBeZLZNGNjwrMecp7z96BiNjHMNJxuSbsnOTqrD/+/yq7mxIL1VgszcNmvr3W8MC1QuFvpmiiDpKg2th1Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUjisI/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUjisI/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227771F000C4;
	Sat, 17 Oct 2026 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253619;
	bh=90hPyMXx3fQ51p+yRp7B2qVsdRaxiJ+3oVRHd0RVcfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUjisI/Tw+I335SIMOQw0eiAo89x1T+ksyWri2osIkbdfW6aMOaaPo+ySLqdZ7wuw
	 kAhyBM5Mt1W184RuVuKZ/ZkV7azWFpqGPf7aSEVLnlCN7Jm1U+YEm1K6Hsamo6RvLU
	 atWbTJPlSRRtrD3D4qjlkuw4bdkDFUHoMKQ/714w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/869] stddef: Introduce TRAILING_OVERLAP() helper macro
Date: Sat, 17 Oct 2026 17:50:19 +0200
Message-ID: <20261017160041.617285307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 29bb79e9dbf1ba100125e39deb7147acd490903f ]

Add new TRAILING_OVERLAP() helper macro to create a union between
a flexible-array member (FAM) and a set of members that would
otherwise follow it. This overlays the trailing members onto the
FAM while preserving the original memory layout.

Co-developed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/aFG8gEwKXAWWIvX0@kspp
Signed-off-by: Kees Cook <kees@kernel.org>
Stable-dep-of: 4156c3745f06 ("virtio_net: Fix misalignment bug in struct virtnet_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/stddef.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 929d67710cc51..dab49e2ec8c0a 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -93,4 +93,24 @@ enum {
 #define DECLARE_FLEX_ARRAY(TYPE, NAME) \
 	__DECLARE_FLEX_ARRAY(TYPE, NAME)
 
+/**
+ * TRAILING_OVERLAP() - Overlap a flexible-array member with trailing members.
+ *
+ * Creates a union between a flexible-array member (FAM) in a struct and a set
+ * of additional members that would otherwise follow it.
+ *
+ * @TYPE: Flexible structure type name, including "struct" keyword.
+ * @NAME: Name for a variable to define.
+ * @FAM: The flexible-array member within @TYPE
+ * @MEMBERS: Trailing overlapping members.
+ */
+#define TRAILING_OVERLAP(TYPE, NAME, FAM, MEMBERS)				\
+	union {									\
+		TYPE NAME;							\
+		struct {							\
+			unsigned char __offset_to_##FAM[offsetof(TYPE, FAM)];	\
+			MEMBERS							\
+		};								\
+	}
+
 #endif
-- 
2.53.0



