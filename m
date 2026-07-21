Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A554415F10;
	Tue, 21 Jul 2026 21:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670059; cv=none; b=tZuPJaUl+fmYr85swq9+vxJMq0Bd0+LkFvpmrElbYe/EwLfdA8cV9Nr8pxbX1qV3p3iwa1bqqPSt/52+OfVJEUm05NvTp0fkfA7qYUzO5TZ3Y7dQi0/4xLW8pSSXtdGsu27phxJhF6B55CPkRUoMX0rnXEC5hjMrIHsdQIOif38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670059; c=relaxed/simple;
	bh=Zpy8Al1HB/9WeNbu8QZ6QLWjcFVQ5aNQ8yXnJS5PRkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRacx1vIbb908qXzQLklRJvKR2eJCc96leT1zgh8KW5htpmesGx1IIccYYzH91BaeCpJ7hacEe+r7MW/akDyTGEVZPSULMdNXjBADFyASwXPAy3CV5l2+XjkKEkCi4jQt8TOdaEpqY+LioOwsCUxMGvTqD93tOisi5GQw14hQgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0Yyerup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0Yyerup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5E41F000E9;
	Tue, 21 Jul 2026 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670058;
	bh=XuI6t+m7XlQY8WMONBIk5D5qBvbjUOIvivzz45FVfDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0Yyerup6dzKH3a9mgZnDZP1DbBSNREX6M3CvwpBr79w1VSki4uzRMFAHDX24+h9P
	 ypdoJ3Ur3DRXTr2yGo4dUDe4BECYAN0Exu7vW9Rrj+ZFqHAAtsubL/LEDRBu4YY+UU
	 LUbBDv667xgyB0m6xAAyA0/P517B9RM3xDCAi6rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0787/1067] fs/ntfs3: bound DeleteIndexEntryAllocation memmove length
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152442.172173575@linuxfoundation.org>
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
@@ -3577,9 +3577,23 @@ move_data:
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


