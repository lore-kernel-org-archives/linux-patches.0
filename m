Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BDA25B0AB;
	Tue, 21 Jul 2026 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672403; cv=none; b=G7NZeaE8IextQ3z2uS3h9ipS61YeDBsPDfncyPcQWxI4KF/FpWhIEGSpfsBuo21jUNIcl0vkx5AB1HqTY8V9v/0nP5o7bc1NhK9hzF9K2GnTZZ01TweZmcTeFISCrDJqWAoFPdjO2jpHwnhG1ZjAdek+YAUlYQHalQ0h8S84DTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672403; c=relaxed/simple;
	bh=wCQQ+BY3gAy7CrBW4al/HdmOrDBpwVNaJn3O188my2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlGZZV+FHRjflsf7H1ibj1Wc+oAdos2YGEeEOeRlukeAKrtElPesQhZSb9f9st3Hy+ZMwqlfUBrrW7UPvY6ez2FTU68m6Y037+nT81wT/0B1EqRpd9L5CUL9/HUvPYG70/eVF/s0UMq8JH+nfGHrBtQNvOgxapkFB2+oyz7Gsy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Vbn31Bw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Vbn31Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6720F1F000E9;
	Tue, 21 Jul 2026 22:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672401;
	bh=qR4hejXiqSBNmJvo3s4ABgJ0utMujvIVP61ssnm5LsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Vbn31Bw1nXI5ikg3yd05wTyblccsB9F6x6t5snW6sDRTSKtuEKoVH9LvBEvShON3
	 sB/PZJqHx/EeOgSEKQ2yQxBdJ3Yc+Du4RI5WfO5o8YrnafiL80xE5tsXj2if3pNNJY
	 JMXtcln9NzpMawn1vHOnI7Y7dYc411WRNlYUTd1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 611/843] fs/ntfs3: bound DeleteIndexEntryAllocation memmove length
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152419.797307316@linuxfoundation.org>
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

commit fc4626bb3656362de8b0ecd56605d47a19ec3518 upstream.

In do_action()'s DeleteIndexEntryAllocation case, e->size comes
from an on-disk INDEX_BUFFER entry.  When e->size makes
e + e->size point past hdr + hdr->used,
PtrOffset(e1, Add2Ptr(hdr, used)) returns a negative ptrdiff_t
that is silently cast to a quasi-infinite size_t when passed
to memmove().  The memmove then walks past the destination
buffer.

The sibling DeleteIndexEntryRoot case at fslog.c:3540-3543
already carries the corresponding guard:

	if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize ||
	    Add2Ptr(e, esize) > Add2Ptr(lrh, rec_len) ||
	    used + esize > le32_to_cpu(hdr->total)) {
		goto dirty_vol;
	}

Apply the same shape to the allocation-path case.  Also reject
esize == 0: memmove(e, e, ...) is a no-op and leaves
hdr->used unchanged, hiding a malformed entry from the
existing check_index_header() walk.

Reproduced under UML+KASAN on mainline 8d90b09e6741 by
mounting a crafted NTFS image: the unguarded memmove takes a
length of 0xffffffffffffff00 and the kernel oopses in
memmove+0x81/0x1a0 on the do_action+0x36a2 frame.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
[almaz.alexandrovich@paragon-software.com: clang-formatted the changes]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3574,9 +3574,23 @@ move_data:
 		}
 
 		e1 = Add2Ptr(e, esize);
-		nsize = esize;
 		used = le32_to_cpu(hdr->used);
 
+		/*
+		 * Reject crafted entries whose e->size makes e + esize
+		 * point past the INDEX_HDR's used boundary.  Without this,
+		 * PtrOffset(e1, hdr + used) underflows to a quasi-infinite
+		 * size_t when fed to the memmove() below.
+		 *
+		 * Also reject esize == 0: memmove(e, e, ...) is a no-op and
+		 * leaves hdr->used unchanged, masking the crafted entry.
+		 */
+		if (!esize || Add2Ptr(e, esize) > Add2Ptr(hdr, used) ||
+		    PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
+		nsize = esize;
+
 		memmove(e, e1, PtrOffset(e1, Add2Ptr(hdr, used)));
 
 		hdr->used = cpu_to_le32(used - nsize);


