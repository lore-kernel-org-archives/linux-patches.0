Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2470346EF86;
	Tue, 21 Jul 2026 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663691; cv=none; b=SZRzW+EYNMeqMMUgu3dicBouUU5lrfMV318uCrcG4jAXhzJg28UWIiUzQceNIV1Kzg0H+6hsb8b7/oLBOjz1izxXkGaYTYrN7kHoXQNUb3WAFIMo128S+MPi0i9j/F20Vq8LH7mY4XOlpxhM8PhYOwz9rahuOxmHL3IqBVaje/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663691; c=relaxed/simple;
	bh=USGxlDCg04chkvBdXsV4cdf1v9GsivR1OxOyqWnfSo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/A6amdJ1Ack4NTGjRtYNmWnfRAl9CFjzOqeCKLU7UY9EB93TsWrkbMYNi2X/adxUlbwDVnDkcgfAJ3y4qHR2Mlx4VwbYV8GO2VscOiUqAqFj5LNE/dMLmmGBza91AkqGkzXU4OmL6YRR2nWsos761YWQZhQkjn8p7HOxeWro9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OW215ZGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OW215ZGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0B61F00A3A;
	Tue, 21 Jul 2026 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663690;
	bh=Qz/+BZAxnkQeUiy4HqEKKv8yKy4FQZuIlyLJ2QH1jwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW215ZGsCHvTjzyCtI/X+Ixq9+vi0yE3tkTBWs0/Oo3skPSCp66duPjYN6drIjBJV
	 PApWZGPyBVOWNYXm4lFEYsntxCUjKkXFl0rygRXOT05YzRNb1C1xT+WIlwdentdZd0
	 d+Y8eFuiHoRVorimHpnKukeV0L+HMMvqO8NohmlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 0916/1276] fs/ntfs3: bound DeleteIndexEntryAllocation memmove length
Date: Tue, 21 Jul 2026 17:22:39 +0200
Message-ID: <20260721152506.534629116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


