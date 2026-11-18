Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031478;
	b=oTDnzdezimmWhzZ7EVL/ZfMnP0PlgTcDh3/dtHbkjVSsYI7RF0+4mMIbHTpzZBWnRxzC
	 fzXWwbPyWXN6OdXiujzp42b6c7QmErCGLj225ghdYIzNnTJKvKyalkh8LW74E5I803PHP
	 XSdErTpMruMm9BQExAQBoi+l7tuNW37r2QuC7jREQ5S6SkTyvezVZcGfS0/0HRuEydCjW
	 YygNPeUrmaLsuFt+rek63O9Z7rTx6WTH9L8d70RD0NhEIRq3ZOHjlWL+/qkHYvJRvlpEG
	 +aPVOSXqdCkRKsnqHgioJ9mD+O0NOBOGHGGtUv72LOLj4cKOGeP0TvUb/Ztuclg3L7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/poD49yD5KkWXU3d6kQjQoTixZ0PB1SLAAXSRpKnl58=;
	b=mzBUFTJcbER1uibgflR0mrvvkIug3uKm149J1lPeIyS4y8s1Ee41+eVR4VNvvzNztLtT
	 10aDs6DpZO3FXNfhHTRi/WjSrMDm+SklZE/wxhmScv0Vp0l6H5Qb3plCC11NC6NdvuJvn
	 62414KFtwud29a+A842d0U+8SUMniGuM3XucUYO+jDL4n7xi9VHVCCzGq03ah2H8vpZam
	 YYbR6trQrlAik3pf9QcENO+MZFamnWgYzcVdMGT8b2yu1vjnHIHaTzrFoCiQwday5/b/a
	 Aew8IkVm+5PugvUkc4BeqxdBkIZSvNmU7dNcYHpQxbOID9mzsgY4gBzXaHp7aZBqvMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HQWOLd/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED17606A31C;
	Wed, 18 Nov 2026 19:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQWOLd/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9166F1F000C4;
	Wed, 18 Nov 2026 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031478;
	bh=/poD49yD5KkWXU3d6kQjQoTixZ0PB1SLAAXSRpKnl58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQWOLd/ZhjphC8JpiXkoLumA8DVhvnTHrpRNvXiqM07+mq8n37U4QJPP7pnz1mxeu
	 NDrLWY27pefjDOg11q/IXhTxo8D6oWGDTf4PVEcA98qHUQltTIOeaI5XYQcPCA5xOa
	 NWUUsnux47F0814xM1aSyimRmklJ7zSLwpoo2n9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1074/1756] btrfs: accessors: inline eb bounds check and factor out the error report
Date: Wed, 18 Nov 2026 15:53:21 +0100
Message-ID: <20261118150052.993963256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit d5a87dbd958398c1926dd35a328ccf89a410cbd2 ]

There's a check in each set/get helper if the requested range is within
extent buffer bounds, and if it's not then report it. This was in an
ASSERT statement so with CONFIG_BTRFS_ASSERT this crashes right away, on
other configs this is only reported but reading out of the bounds is
done anyway. There are currently no known reports of this particular
condition failing.

There are some drawbacks though. The behaviour dependence on the
assertions being compiled in or not and a less visible effect of
inlining report_setget_bounds() into each helper.

As the bounds check is expected to succeed almost always it's ok to
inline it but make the report a function and move it out of the helper
completely (__cold puts it to a different section). This also skips
reading/writing the requested range in case it fails.

This improves stack usage significantly:

  btrfs_get_16                                         -48 (80 -> 32)
  btrfs_get_32                                         -48 (80 -> 32)
  btrfs_get_64                                         -48 (80 -> 32)
  btrfs_get_8                                          -48 (72 -> 24)
  btrfs_set_16                                         -56 (88 -> 32)
  btrfs_set_32                                         -56 (88 -> 32)
  btrfs_set_64                                         -56 (88 -> 32)
  btrfs_set_8                                          -48 (80 -> 32)

  NEW (48):
	  report_setget_bounds                                     48
  LOST/NEW DELTA:      +48
  PRE/POST DELTA:     -360

Same as .ko size:

     text    data     bss     dec     hex filename
  1456079  115665   16088 1587832  183a78 pre/btrfs.ko
  1454951  115665   16088 1586704  183610 post/btrfs.ko

  DELTA: -1128

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
index 2e90b9b14e73f..a7b6b2d7bde22 100644
--- a/fs/btrfs/accessors.c
+++ b/fs/btrfs/accessors.c
@@ -9,20 +9,15 @@
 #include "fs.h"
 #include "accessors.h"
 
-static bool check_setget_bounds(const struct extent_buffer *eb,
-				const void *ptr, unsigned off, int size)
+static void __cold report_setget_bounds(const struct extent_buffer *eb,
+					const void *ptr, unsigned off, int size)
 {
-	const unsigned long member_offset = (unsigned long)ptr + off;
+	unsigned long member_offset = (unsigned long)ptr + off;
 
-	if (unlikely(member_offset + size > eb->len)) {
-		btrfs_warn(eb->fs_info,
-		"bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
-			(member_offset > eb->len ? "start" : "end"),
-			(unsigned long)ptr, eb->start, member_offset, size);
-		return false;
-	}
-
-	return true;
+	btrfs_warn(eb->fs_info,
+		   "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
+		   (member_offset > eb->len ? "start" : "end"),
+		   (unsigned long)ptr, eb->start, member_offset, size);
 }
 
 /*
@@ -56,7 +51,10 @@ u##bits btrfs_get_##bits(const struct extent_buffer *eb,		\
 	const int part = eb->folio_size - oil;				\
 	u8 lebytes[sizeof(u##bits)];					\
 									\
-	ASSERT(check_setget_bounds(eb, ptr, off, sizeof(u##bits)));	\
+	if (unlikely(member_offset + sizeof(u##bits) > eb->len)) {	\
+		report_setget_bounds(eb, ptr, off, sizeof(u##bits));	\
+		return 0;						\
+	}								\
 	if (INLINE_EXTENT_BUFFER_PAGES == 1 || likely(sizeof(u##bits) <= part))	\
 		return get_unaligned_le##bits(kaddr + oil);		\
 									\
@@ -76,7 +74,10 @@ void btrfs_set_##bits(const struct extent_buffer *eb, void *ptr,	\
 	const int part = eb->folio_size - oil;				\
 	u8 lebytes[sizeof(u##bits)];					\
 									\
-	ASSERT(check_setget_bounds(eb, ptr, off, sizeof(u##bits)));	\
+	if (unlikely(member_offset + sizeof(u##bits) > eb->len)) {	\
+		report_setget_bounds(eb, ptr, off, sizeof(u##bits));	\
+		return;							\
+	}								\
 	if (INLINE_EXTENT_BUFFER_PAGES == 1 ||				\
 	    likely(sizeof(u##bits) <= part)) {				\
 		put_unaligned_le##bits(val, kaddr + oil);		\
-- 
2.53.0



