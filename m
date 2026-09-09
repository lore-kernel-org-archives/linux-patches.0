Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EDC275AFD;
	Wed,  9 Sep 2026 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961644; cv=none; b=r1TP4Pn3/VytOYaFajRggVgc1U864pVvkCFXcwnOitMTZrIzoSD4DSCfc96MY3VyEiZyZFp3vq9yj9uRh1ZKM9lsEo0zNkk16xJEXV35E/1q7gCJKDqoUW41Eq66sQKVivVwjUg/ZVuDsZMc9TCtfikt9RQJX3Xo8hRF9QJ00zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961644; c=relaxed/simple;
	bh=4mcLxdEr91iI6M+BytCot/r2dFUyOJYfnkG9v2RiQJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTa85P217vHnx1BgAvZ40Q3xxUc/LbCjIBGo2m8S0qyFuO05mtO+Zie0mkwvJm5WsbyIWGltGMABwuiXPnsWWMw9IzTBnqgtg78ABJmCn1nRq2i5Lo73QCu4qPVvxyrBg9dUWyLJ+tW+oroYg4hpEDL8bykerDqdw03oa9lbrJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5fDELtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5fDELtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E461F00A3A;
	Wed,  9 Sep 2026 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961642;
	bh=gOqp6Ii1/hw8h0PIIdlaBz1e78AkrAgK39N6y8qKikM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5fDELtZgW+h9zNpZ+jFV5D8ADNhOYgBDBMQ2wxjQp+BOpGwBfaOskm7EM14gWW+N
	 Sl5z2yTr/L42m9iK2mTdVUeKWl1eIlOH+4vZtutG95ljen7Ozz6hgblL5UJIFEs3kl
	 m8WvmDmXxcqDBqHWDik2NB9Ze//PuAIm3+5GPvtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=EF=BC=88=E3=82=AE=E3=82=AB=E3=82=AF=EF=BC=89?= <skyexpoc@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.2 002/556] fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()
Date: Wed,  9 Sep 2026 15:34:42 +0200
Message-ID: <20260909134230.534845681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: HE WEI（ギカク） <skyexpoc@gmail.com>

commit 7c4841e2a62794a3bab7c1ff0540580f387e377f upstream.

ni_create_attr_list() allocates a fixed buffer of al_aligned(record_size)
(== record_size) bytes and then walks every attribute of the primary MFT
record, writing one ATTR_LIST_ENTRY per attribute and advancing the cursor
by le_size(name_len), with no check against the end of the buffer; the
total size is only computed after the loop.

A minimum-size resident attribute occupies SIZEOF_RESIDENT (0x18 = 24)
bytes on disk, but an unnamed attribute expands to le_size(0) (0x20 = 32)
bytes in the list.  Because the number of attributes in a record is not
bounded (mi_enum_attr() accepts arbitrarily many equal-type, nameless
minimum-size attributes), a crafted record packed with such attributes
produces a list larger than record_size and overflows the heap buffer.

This is reachable from a crafted, loop-mounted NTFS image: opening the file
and adding an attribute (e.g. via setxattr) drives ntfs_set_ea() ->
ni_insert_resident() -> ni_insert_attr() -> ni_ins_attr_ext() ->
ni_create_attr_list().

  BUG: KASAN: slab-out-of-bounds in ni_create_attr_list+0xc48/0x1058
  Write of size 4 at addr ffff000008984c00 by task setfattr/345
   ni_create_attr_list+0xc48/0x1058
   ni_ins_attr_ext+0x510/0x7c0
   ni_insert_attr+0x3f8/0x70c
   ni_insert_resident+0xc8/0x3b0
   ntfs_set_ea+0x66c/0xd28
   ntfs_setxattr+0x4d8/0x5b0
   __arm64_sys_setxattr+0xa4/0x124
  Allocated by task 345:
   ni_create_attr_list+0x188/0x1058
  The buggy address belongs to the cache kmalloc-1k of size 1024
  (the write lands at object+1024).

Size the buffer from the actual attributes instead of assuming a single
record_size is always enough.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: HE WEI（ギカク） <skyexpoc@gmail.com>
Signed-off-by: HE WEI（ギカク） <skyexpoc@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -768,10 +768,23 @@ int ni_create_attr_list(struct ntfs_inod
 	rs = sbi->record_size;
 
 	/*
-	 * Skip estimating exact memory requirement.
-	 * Looks like one record_size is always enough.
+	 * Compute the exact size of the attribute list.  Each attribute in the
+	 * record yields one ATTR_LIST_ENTRY of le_size(name_len) bytes.  The
+	 * minimum on-disk attribute is SIZEOF_RESIDENT (0x18) bytes, but an
+	 * unnamed one expands to le_size(0) (0x20) here, so a record crafted
+	 * with many such attributes needs more than a single record_size; the
+	 * previous fixed kzalloc(record_size) could therefore be overflowed by
+	 * an attacker-controlled record.
 	 */
-	le = kzalloc(al_aligned(rs), GFP_NOFS);
+	lsize = 0;
+	attr = NULL;
+	while ((attr = mi_enum_attr(ni, &ni->mi, attr)))
+		lsize += le_size(attr->name_len);
+
+	if (!lsize)
+		return -EINVAL;
+
+	le = kzalloc(al_aligned(lsize), GFP_NOFS);
 	if (!le)
 		return -ENOMEM;
 
@@ -781,7 +794,6 @@ int ni_create_attr_list(struct ntfs_inod
 	attr = NULL;
 	nb = 0;
 	free_b = 0;
-	attr = NULL;
 
 	for (; (attr = mi_enum_attr(ni, &ni->mi, attr)); le = Add2Ptr(le, sz)) {
 		sz = le_size(attr->name_len);


