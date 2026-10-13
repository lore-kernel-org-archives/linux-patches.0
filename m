Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579FC4FDE47;
	Tue, 13 Oct 2026 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892971; cv=none; b=FBCgy3ehj+RideIqctcg4odpsfqOFHuyvi4nD2ATk8OIfL/vEOe3rXpbpzzrwf+pSIf739bQRkGCEZUmMN+7HrNYO+MMaU1p8UGra9pbqqJ+gjxYV5SU8NqYggbrdOKNNLPJ1NzstqyzinOXuPV88FDCBykrCWJW+A9b+0jptyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892971; c=relaxed/simple;
	bh=5AY8bWoBadh6UQ3IjZVacQ+VOSlRvwUpL3yUT3rjAso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiMYB6l0AC8su/ii2bg6qMcirTOannGVkh9TwqXHmp+zqSYObzslYc4F1MaWDhSiBuoSrFnH7+XXy0Oa87vm8QlhwjmCf4GQURerQGSJM5UXZUxQ67uIY+giuy+Xw0FVswDMb70CrSFD9By9+eYItahAXf2w37sSlylzu26WxmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifHy20cy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifHy20cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7079C1F000FF;
	Tue, 13 Oct 2026 12:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892970;
	bh=cdMEzbMMFhb9wOIhyr+1m0auIgwuHQcEqOEKooCCBvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifHy20cyVgTBbRdZ0AW5czH1dsaN7XJUskg/kdgUwy6FudHL7hOOmE1qkd5nOohTd
	 pbqeDmQh/1t3bYmdfVd/XUQP2LfwHtpQJSy+28C4BRB/lGYaw9SpeX7jwzyLBNFFgh
	 sIOCn0rmhR5KkVA9EC4ytKRLvvZIzHOpiHWpgPag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 070/621] dm-integrity: fix buffer overflow in inline mode with large tag size
Date: Tue, 13 Oct 2026 13:31:05 +0200
Message-ID: <20261013112922.518493380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 764b683a6180fd72c931c13fea98d383506a3475 upstream.

In inline mode, dm_integrity_check and dm_integrity_inline_recheck
compute the checksum of each block into an on-stack buffer of
HASH_MAX_DIGESTSIZE bytes. integrity_sector_checksum pads its result
with zeroes up to the tag size, so if the tag size is larger than
HASH_MAX_DIGESTSIZE, the padding runs past the end of the buffer. With
CONFIG_STACKPROTECTOR the kernel panics in dm_integrity_check on the
first read.

Enlarge both buffers to hold MAX_TAG_SIZE bytes, as commit b93b6643e9b5
("dm integrity: fix a crash with unusually large tag size") did for
integrity_metadata.

Note that this is not a security bug because the buffer overflow can only
be triggered by root.

Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: LLM
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2720,7 +2720,7 @@ static void dm_integrity_inline_recheck(
 	outgoing_data = dio->integrity_payload + PAGE_SIZE;
 
 	while (dio->bio_details.bi_iter.bi_size) {
-		char digest[HASH_MAX_DIGESTSIZE];
+		char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		int r;
 		struct bio_integrity_payload *bip;
 		struct bio_vec bv;
@@ -2787,7 +2787,7 @@ static inline bool dm_integrity_check(st
 	unsigned pos = 0;
 
 	while (dio->bio_details.bi_iter.bi_size) {
-		char digest[HASH_MAX_DIGESTSIZE];
+		char digest[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
 		char *mem = integrity_kmap(ic, bv.bv_page);
 		integrity_sector_checksum(ic, &dio->ahash_req, dio->bio_details.bi_iter.bi_sector, mem, bv.bv_offset, digest);


