Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3B825B0AB;
	Tue, 21 Jul 2026 22:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672406; cv=none; b=rTV4RqEw5yZ1cYkZwe8sR2ruGIQBxOGOwN5Dv6+b0Mcbj1TEPLEQQbW6a5y9E8QgMHVUHrBNER60BSqN/F0P2fGoqeo4gXvRix4z7FeUfG/uDfwh8cc7/mwRAipOfcYrycc1LZtfy1vxN460B5b99/p3TXseyfISJ9fbcoNl1/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672406; c=relaxed/simple;
	bh=E+uh6EE6PFKB4WA+VUqGEk1Xlz0sRtTAQ6eZ5bdAlKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhkNHPihnahdf/DCyq16jFydbXEaEVWzIr8hhjrFIwJ0T4g4n5TPI5lmNJ9oQLJM03BY6CcUULF5tp02k6A9m338EERLL5O5PJZZn/5govRCRAnZu/jystE8hbd0He387oSIbLgLEBblRl9xiYg95oRrypxrGiBfKwxqFhh6r2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQ+on03v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQ+on03v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1330A1F000E9;
	Tue, 21 Jul 2026 22:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672404;
	bh=4P1Ieh1rC/DSmcpEk7rnjbHCAYmO+02OLMNIMjKk7SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQ+on03vyXm7P7IIsr8yNS21llQ284kA3PCguX/cDkB6E2XTwXUmERtOHM//sYd7V
	 mg1qPhBECVjl2l66oqJu7m5w1fv4jL8TUy0SFsO/SiNOHJX6vqXBFi4OXuiBTWjZWG
	 pjkyA4HtDnoTYJcBw1+PQBHZSoAPL7mgEo1qlo84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 612/843] fs/ntfs3: bound attr_off in UpdateResidentValue against data_off
Date: Tue, 21 Jul 2026 17:24:07 +0200
Message-ID: <20260721152419.821310110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


