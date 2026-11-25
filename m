Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622454;
	b=NcODn5gUoJWiQZZjIom/ZYk6o0zgsP2nMiYiVxh++CivRmDSJkn84yEMGO1v+xtoXRNI
	 pbN3x7qYTtSpXx4emiZzvaSYwklnciUavfTnHsnAb5IAYFRrNW3MCDDvplAbpqe+JN5GM
	 hIEpONgRJyFwHodOmD1UEMhJvLhiqdZzaPXE6RRKGQK5CcEnmgkIZi/c4kR6dhjkm55Zu
	 vlSw0Xc2V/bWPi3i/dsIyBD0TiP3ie8X1Mmm+5vKxUsd/fauhADKs9NYbdg6K6DJWM34G
	 RUbbNoCRNwUIKOf2jtdIWqzl267HQzYvRQMIj+keKkFKTqbJEqAuivG8GaMHSvQxXIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6IcZTZMhQTMcJU+6JA6jYg9PHAN66cRLiR5xhFJeBtk=;
	b=txszyLRGiAfQoCULHSDIc7wBP9zIphBHgOEL43GtKSa2aEiTgsVcDMdRfKaq9VhW2uSU
	 qIF4xkT1vnw3ZG6LUoxaQ+64MDdtnaxzWq1KyEbvk6wGcOLnIMNwHerrnOjmhdBp/UA6T
	 qpv/ETFewRlhBA6guG7zgMtvK+TlrP3qlSP7ZRlO20PInINRIYoJuYOs210FdryrvQjMd
	 UmNmfjeEwNC+xSohb1TobLM559NS2SKSR3389gZ7YA2ffi8JJzKua0iPXU43dfwd3uSfC
	 dNMppxVBmT+9S3btqs56ap3icOYtyrG9Ztt4huLQa1CO4+lWArUsNqIhLT2BXnLpnUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0yu3u8L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690F3606A31E;
	Wed, 25 Nov 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0yu3u8L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4851F000CF;
	Wed, 25 Nov 2026 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622453;
	bh=6IcZTZMhQTMcJU+6JA6jYg9PHAN66cRLiR5xhFJeBtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0yu3u8L6TzNN5eCIKv7CHrYEwWWqgJ51wsTRCitJE44vXihKLe46FKFwvBCgj2EN
	 NYwrf+OVGq9WLEAkIo0E8/IrREZBpWZeNbHxnMAXrArXdRwd6NwKndGImObBlJjfNC
	 JEdPqltxBCAwhBQrLc8O+gExcPM71nmwfAawN9LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 541/990] fuse: zero the correct range on a short read reply
Date: Wed, 25 Nov 2026 15:31:48 +0100
Message-ID: <20261125143834.768501547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit d0a079b5b94bf5e10f1c00bd092eda0333782037 ]

When a read reply is shorter than the requested range, fuse_copy_folio()
zeroes everything in the folio outside the copied bytes. However, for
folios with block sizes smaller than the folio size, this can clear
blocks outside the requested range which are uptodate, or dirty and have
not yet been written back.

Move the zeroing logic into fuse_copy_folios(), since descs[i].length
needs to be used, and clear only the tail of the requested range that
the server did not send.

The range is also no longer cleared upfront in the non
cs->skip_folio_copy case. This is fine since a failed copy leaves those
blocks non-uptodate, so the uncopied bytes are never visible. This also
matches the pre-existing behavior in the non-short-read case (a failed
copy doesn't zero out the range in the folio). This lets the zeroing
logic stay the same regardless of whether the folio copy is skipped or
not.

Fixes: a4c9ab1d4975 ("fuse: use iomap for buffered writes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Kanishka De Silva <kpskanna1915@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: Moved zeroing into fuse_copy_folios() in dev.c, kept fuse_copy_folio() static so the dev.h hunk is dropped, and omitted the skip_folio_copy/folio_zero_segments logic that isn't present here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c    | 32 ++++++++++++++++++++------------
 fs/fuse/notify.c |  2 +-
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 0f9ef3ca9824f..56bc4381c2874 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1129,17 +1129,10 @@ static int fuse_ref_folio(struct fuse_copy_state *cs, struct folio *folio,
  * done atomically
  */
 static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
-			   unsigned offset, unsigned count, int zeroing)
+			   unsigned offset, unsigned count)
 {
 	int err;
 	struct folio *folio = *foliop;
-	size_t size;
-
-	if (folio) {
-		size = folio_size(folio);
-		if (zeroing && count < size)
-			folio_zero_range(folio, 0, size);
-	}
 
 	while (count) {
 		if (cs->write && cs->pipebufs && folio) {
@@ -1156,7 +1149,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 			}
 		} else if (!cs->len) {
 			if (cs->move_folios && folio &&
-			    offset == 0 && count == size) {
+			    offset == 0 && count == folio_size(folio)) {
 				err = fuse_try_move_folio(cs, foliop);
 				if (err <= 0)
 					return err;
@@ -1197,10 +1190,25 @@ static int fuse_copy_folios(struct fuse_copy_state *cs, unsigned nbytes,
 
 	for (i = 0; i < ap->num_folios && (nbytes || zeroing); i++) {
 		int err;
+		struct folio *folio = ap->folios[i];
 		unsigned int offset = ap->descs[i].offset;
-		unsigned int count = min(nbytes, ap->descs[i].length);
+		unsigned int length = ap->descs[i].length;
+		unsigned int count = min(nbytes, length);
+
+		/*
+		 * The reply may be shorter than what was asked for. The full
+		 * descs[i].length is reported as read, so the tail bytes the
+		 * server did not send are about to be marked uptodate and need
+		 * to be zeroed.
+		 *
+		 * Only [offset, offset + length) can be touched since the
+		 * rest of the folio can hold blocks that are already uptodate
+		 * or dirty, and clearing those would lose data.
+		 */
+		if (folio && zeroing && count < length)
+			folio_zero_range(folio, offset + count, length - count);
 
-		err = fuse_copy_folio(cs, &ap->folios[i], offset, count, zeroing);
+		err = fuse_copy_folio(cs, &ap->folios[i], offset, count);
 		if (err)
 			return err;
 
@@ -1835,7 +1843,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 		nr_bytes = min_t(unsigned, num, folio_size(folio) - folio_offset);
 		nr_pages = (offset + nr_bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes, 0);
+		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes);
 		if (!folio_test_uptodate(folio) && !err && offset == 0 &&
 		    (nr_bytes == folio_size(folio) || file_size == end)) {
 			folio_zero_segment(folio, nr_bytes, folio_size(folio));
diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index 7cd63502e124b..f21ba27f0f82e 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -184,7 +184,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 		folio_offset = offset_in_folio(folio, pos);
 		nr_bytes = min(num, folio_size(folio) - folio_offset);
 
-		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes, 0);
+		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes);
 		if (!folio_test_uptodate(folio) && !err && folio_offset == 0 &&
 		    (nr_bytes == folio_size(folio) || file_size == end)) {
 			folio_zero_segment(folio, nr_bytes, folio_size(folio));
-- 
2.53.0



