Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9504D26AC3;
	Fri,  4 Sep 2026 05:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498299; cv=none; b=EhwklGCFvQflV6VwuDr+8x6J6W1R2SE6L1xd+U1/HCYABcyKW8UIn/Roo55OS06nzPZ1NM/Y7LFoJVHnZhaDDk46/emSBqMO8punsvoV2gOHD2AFEKd8nnEQFdPSa+Vk4+p1muLVWrCNeuMb4pwAAMnHMcdjDpb192MhaZQ1wkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498299; c=relaxed/simple;
	bh=wkAWGywlH328iBUCZnlerF7R3TFvcRDFSVJMUls46NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekPGMSimOIwfGGpgp7SU+Sfx8lk76bDpte+gClXK8jDoR0hIdIpby9fVAHfuVpMPid2Y78jbyS2WII6jmHkdBloqcmJKbAhC+oN1JssQ+KMicstKsjvRZDBInCmgNo1YWdS+BK6I/XYBzFrN0F0nI1fVuo2kJPo+YqTXvfo76no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/7B6fwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/7B6fwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF151F00A3D;
	Fri,  4 Sep 2026 05:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498298;
	bh=JXaJUq5/VgE/ZeeF18+z3odpa6db5D8/KJwYVf6fDI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/7B6fwYKNqiQqgVvjnq7YlhivDCpa4RBG/t4NPUUdNcq0RkL3bLmDq5O5SPKNH3S
	 SYmhYBPZBE3NwDUcAmJJKXxaiiEKRfesVZ4eA4OI5OcLtm8uWEsoZjLNGc7HFhqEBW
	 Ro/8oZ1XNKny3l6trjR/aQNmHPDYuh2RyC5ljYVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 014/713] iomap: dont free integrity payload that doesnt exist
Date: Fri,  4 Sep 2026 06:49:42 +0200
Message-ID: <20260904045804.143093570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 8a8685b32c0718cc7b2cb4d6202e5a5b8e0a8e2d upstream.

fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
verification is disabled on the block device.  Check for that case before
calling fs_bio_integrity_free in iomap_bio_read_folio_range_sync to
avoid a NULL pointer dereferences.

Make the branch cover the PI verification as well - while
fs_bio_integrity_verify works without an integrity payload, it requires
one to actually do useful work.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20260804124404.737145-2-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -179,7 +179,7 @@ int iomap_bio_read_folio_range_sync(cons
 	if (srcmap->flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(&bio);
 	error = submit_bio_wait(&bio);
-	if (srcmap->flags & IOMAP_F_INTEGRITY) {
+	if (bio_integrity(&bio)) {
 		if (!error)
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);


