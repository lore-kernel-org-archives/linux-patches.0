Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC36B466B64;
	Tue, 16 Jun 2026 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633867; cv=none; b=lZ6x8VJKFSL0YSOfsEpclEuRBD3TtNkhhiCBdvlA1rcHv6CFEqL2ZWiZYdUff+6qgQZdEmwtVQDwZfRM+KTc1EYmM+nIT6+M2q7dSUJ9tRMGO73cSk74x3XddVY5ai0vI/zTvgKNhGSCKtQFIijz22roOGobSBD+AM3mvmSuHHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633867; c=relaxed/simple;
	bh=PaO6698SMxV8jN8I+BVdEdldIIdCaKzpRwo8tGSegJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kni/vpbC2Np9wsiEau7k2TddyLMecY7ccGVTTzajV9rsXRh+NdyMX8ZiyyU1qvDXPiX6iDsIaraJfBO/UlFznOwBy/vXjSDXs5XKC4v2c4Ndfk7Q4S0KhFspt6J04rFhaNfXwDjNLWejX9KBHuN0sUhtl9mCmVlAXNwzDTiVeT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwXyft48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwXyft48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C9C1F00A3A;
	Tue, 16 Jun 2026 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633865;
	bh=lM8g5j70UJSKI/ULSz0LIseQBvdFqIKJk8clK2YHuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwXyft48A7mUxmciKingYqWDYi+tyvVWm6XvV31HuPfY09fdCQe/h8JE5PMSpsEZj
	 C4IhP6ft+GPSa2ceZYniFHVFFL9t+4dW5FCEUvUCbCqM3an+vssL+Dp9om0McV6T7t
	 ZBr3nUIe9UntjSobYmeG4mZskUwm1zmAfCIuk30I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 125/411] thunderbolt: property: Reject dir_len < 4 to prevent size_t underflow
Date: Tue, 16 Jun 2026 20:26:03 +0530
Message-ID: <20260616145106.967685265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit de21b59c29e31c5108ddc04210631bbfab81b997 upstream.

On the non-root path, __tb_property_parse_dir() takes dir_len from
entry->length (u16 widened to size_t).  Two distinct OOB conditions
follow when entry->length < 4:

1. The non-root path begins with kmemdup(&block[dir_offset],
   sizeof(*dir->uuid), ...) which always reads 4 dwords from
   dir_offset.  tb_property_entry_valid() only enforces
   dir_offset + entry->length <= block_len, so a crafted entry
   with dir_offset close to the end of the property block and
   entry->length in 0..3 passes that gate but lets the UUID copy
   run off the block (e.g. dir_offset = 497, dir_len = 3 in a
   500-dword block reads block[497..501]).

2. After the kmemdup, content_len = dir_len - 4 underflows size_t
   to ~SIZE_MAX, nentries becomes SIZE_MAX / 4, and the entry
   walk runs OOB on each iteration until an entry fails
   validation or the kernel oopses on an unmapped page.

Reject dir_len < 4 on the non-root path *before* the UUID kmemdup,
which closes both holes.

Also move INIT_LIST_HEAD(&dir->properties) up to immediately after
the dir allocation so the new error-return path (and the existing
uuid-alloc failure path) calling tb_property_free_dir() sees a
walkable list rather than the zero-initialized NULL next/prev that
list_for_each_entry_safe() would oops on.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -174,10 +174,16 @@ static struct tb_property_dir *__tb_prop
 	if (!dir)
 		return NULL;
 
+	INIT_LIST_HEAD(&dir->properties);
+
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
 	} else {
+		if (dir_len < 4) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 		dir->uuid = kmemdup(&block[dir_offset], sizeof(*dir->uuid),
 				    GFP_KERNEL);
 		if (!dir->uuid) {
@@ -191,8 +197,6 @@ static struct tb_property_dir *__tb_prop
 	entries = (const struct tb_property_entry *)&block[content_offset];
 	nentries = content_len / (sizeof(*entries) / 4);
 
-	INIT_LIST_HEAD(&dir->properties);
-
 	for (i = 0; i < nentries; i++) {
 		struct tb_property *property;
 


