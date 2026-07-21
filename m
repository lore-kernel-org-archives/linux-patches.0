Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830CF44AB8A;
	Tue, 21 Jul 2026 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670064; cv=none; b=O6lZmjanV/QS8wobZP/b5JhoSmrLXigfXRHAbc9a627iv8kewCHlx/tWaKABEcz1dNMJqvIB1wwl5PfNMOcjSFuRQe4P1OQZd9TbynUkuzt/1EvGOUEPhOei54m9sbR3Nef1g2sq7k8Tm+WrAoJEEm3wDJWDXvHerKJuJYK+orw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670064; c=relaxed/simple;
	bh=9ZpqPXnDq+7OaGHYwvplmT9gJZr2XzcvNDPifGicCx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et+r06LWdI4mBCT9nx3nwSfsfKBS7Lp8Aw6EmTzFyw2e1Alaia/9qrYnuynVSlR0wLTp4ZHLnvIop3DQXrA9jX78uB2z6V+wOVI7iHBub1wKiOx/kc9SdDgT/ekBJXtpm5ixHEN+YDT5+f0Nx7mjgpsZYHGDovEszF0vYicVh68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKksffOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKksffOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99971F000E9;
	Tue, 21 Jul 2026 21:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670063;
	bh=77l9bfYuYzsTZkY2EvcWuoeRd4oaw3I6ebBKTzfRDpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKksffOC18+kCY8bO3ZiDMYTGmLuhT3JwgmC3I+7e3o2wokLhGRkJanggqLPlpzoN
	 WN1Dt3lPDLdAPdz1jflVCuzWboEd7BY1ddD48/Newk/O5euOjs96NdqFwqPpsYUx0N
	 OTKHagHJG8mOczr1gjBXigt5hsddGge5kPijZtak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0789/1067] fs/ntfs3: bound attr_off in UpdateResidentValue against data_off
Date: Tue, 21 Jul 2026 17:23:10 +0200
Message-ID: <20260721152442.215244961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit d1570c48f49a693974d000251030370ee2e83539 upstream.

In do_action()'s UpdateResidentValue case (fslog.c:3307),
lrh->attr_off and lrh->redo_len come from the on-disk LRH.
When they satisfy aoff + dlen < attr->res.data_off, the
assignment

	attr->res.data_size = cpu_to_le32(aoff + dlen - data_off);

underflows to ~4 GiB (e.g. 0xFFFFFFF9 when aoff=0x10, dlen=1,
data_off=0x18).  Subsequent code that reads attr->res.data_size
to walk the resident attribute payload would then read up to
4 GiB past the 1024-byte MFT record allocation.

The existing mi_enum_attr() defense in fs/ntfs3/record.c:287
catches the corrupted data_size on the next attribute walk
and fails the mount, but only on the path that walks all
attributes.  A read site that picks an attribute by name and
reads its data_size without re-validating is not covered.
Validate aoff against data_off and asize at the source.

Reproduced under UML+KASAN on mainline 8d90b09e6741 via
pr_warn-only probe: with aoff=0x10 and data_off=0x18, the
post-assignment data_size is 0xfffffff9 (mount then fails
at -22 from mi_enum_attr).

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
[almaz.alexandrovich@paragon-software.com: clang-formatted the changes]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3316,6 +3316,17 @@ skip_load_parent:
 		nsize = ALIGN(nsize, 8);
 		data_off = le16_to_cpu(attr->res.data_off);
 
+		/*
+		 * aoff comes from the on-disk lrh->attr_off.  Forbid
+		 * writes that begin below the resident attribute's
+		 * data_off (which would overwrite the resident header),
+		 * and forbid aoff + dlen < data_off, which would make
+		 * the data_size assignment below underflow to ~4 GiB.
+		 */
+		if (aoff < data_off || aoff + dlen < data_off ||
+		    aoff + dlen > asize)
+			goto dirty_vol;
+
 		if (nsize < asize) {
 			memmove(Add2Ptr(attr, aoff), data, dlen);
 			data = NULL; // To skip below memmove().


