Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3E332EC1;
	Tue, 16 Jun 2026 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631126; cv=none; b=RtPlx7VuHwdAjXPS5BO2vsenuoWpY6+oSt349n+P+ss1TX3tNL6pMevtcX7GFl/izdcetesrbThhQZpheG6DX69HNIlT/kZTwru7f7eMXHuzfuzsZt1JFic3LL2/bORBl2WVetlGF/+sl442e4u1h55Z+mOIG4JRqswjrcpePzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631126; c=relaxed/simple;
	bh=jtsedPWDCB/9zy6+JgKeGHp7xp5pnxCFqpi3sPPqMJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq2sXAIAgf9mJ0iPh4A5izoJ1IORXactK7UNTMGxUSMXaHsJjad2Dj+nHfYhfHq3TiqXkrMxCwcoOtLY0vMVHZeSTMf448qHuUbWMOEjWV/MTBt2ElexG9O+cxph/uz4o/hSG6yyPGXOiaH+v/rh7KIN/kp3GaY7HvMc4vvXVdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM7zw+jZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM7zw+jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99931F000E9;
	Tue, 16 Jun 2026 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631125;
	bh=OwWkQnehEBUujvOferkga6UNI+p4gwoWD2b6yIckoL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM7zw+jZ1hsM1s8qcG4LmTNlAwHZMSkSL1KsgCuhn++qL9X9/gsiMKP/rxn9ZMxtt
	 6K0iOweOaR3wRIR1G53P4qXNbOVZvoy22ndqoVSZo2XLnDklHd+L4ci4gm5O3YhGBG
	 sukKsRDIk5ivjba3T+3dTO0Iugc/+YTVvYjjv5sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 161/522] thunderbolt: property: Reject dir_len < 4 to prevent size_t underflow
Date: Tue, 16 Jun 2026 20:25:08 +0530
Message-ID: <20260616145133.663159198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
 


