Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4DB3BB67F;
	Sat, 17 Oct 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260501; cv=none; b=rIoNq6qFdIccnGIvvzDeCfG00ZbJ+PVIhRDEwpsTDUOis7BnbR2IdxatMzD2JqKgF9lregdEnkNxDYVJj6yspDgQ+m3OCxLrdPKxlxAUupR2Yr69HyATGarDgg9ZXCyW/qX6QsPfYUfBI7humwo/pf+Js/l7QMWcvH7xHBLLVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260501; c=relaxed/simple;
	bh=dz2hyhKpLfAiqkMTnXuGeDood4L8o1AYMCdzwe9navI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hO/+9pW7ueRdGNG5Mlh3oIMYD4IsqYOMnblRbZaLEM5J9ncFVBXIg6hIIpGcYM057FfYui504kEVxcdEgy51iRt8iRZEJGy9MHtWOat1Fcv7bRF2fpwm2Uvlp/q5vsatv5MU8I3yG00Kc+hFOgCYRz9ydRtlYA+RTYcg/43Xyq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMIEqC7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMIEqC7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2E41F000C4;
	Sat, 17 Oct 2026 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260499;
	bh=5MaKxl6faHqUHp1qgQMhJDPac6zbDbHpWtTAKrxVKp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMIEqC7RTa+4nAYLBYi4NLKuW520YDZBUt6mYLMeS7DRZ2Ycfe64DjjLRooJvmpAY
	 conx3UAAgwO+SKHx1wNJWiIdRYOuU2NhunWuULxucZya7GjF19BNyX+82p02NHHUsx
	 Hn68iz6KLREHEgUGXuyH67DD9nbga2KVOcqntew4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1565/1674] ceph: fix num_ops off-by-one when crypto allocation fails
Date: Sat, 17 Oct 2026 18:03:57 +0200
Message-ID: <20261017160511.269885609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit a0d9555bf9eaeba34fe6b6bb86f442fe08ba3842 ]

move_dirty_folio_in_page_array() may fail if the file is encrypted, the
dirty folio is not the first in the batch, and it fails to allocate a
bounce buffer to hold the ciphertext. When that happens,
ceph_process_folio_batch() simply redirties the folio and flushes the
current batch -- it can retry that folio in a future batch.

However, if this failed folio is not contiguous with the last folio that
did make it into the batch, then ceph_process_folio_batch() has already
incremented `ceph_wbc->num_ops`; because it doesn't follow through and
add the discontiguous folio to the array, ceph_submit_write() -- which
expects that `ceph_wbc->num_ops` accurately reflects the number of
contiguous ranges (and therefore the required number of "write extent"
ops) in the writeback -- will panic the kernel:

    BUG_ON(ceph_wbc->op_idx + 1 != req->r_num_ops);

This issue can be reproduced on affected kernels by writing to
fscrypt-enabled CephFS file(s) with a 4KiB-written/4KiB-skipped/repeat
pattern (total filesize should not matter) and gradually increasing the
system's memory pressure until a bounce buffer allocation fails.

Fix this crash by decrementing `ceph_wbc->num_ops` back to the correct
value when move_dirty_folio_in_page_array() fails, but the folio already
started counting a new (i.e. still-empty) extent.

The defect corrected by this patch has existed since 2022 (see first
`Fixes:`), but another bug blocked multi-folio encrypted writeback until
recently (see second `Fixes:`). The second commit made it into 6.18.16,
6.19.6, and 7.0-rc1, unmasking the panic in those versions. This patch
therefore fixes a regression (panic) introduced by cac190c7674f.

Cc: stable@vger.kernel.org
Fixes: d55207717ded ("ceph: add encryption support to writepage and writepages")
Fixes: cac190c7674f ("ceph: fix write storm on fscrypted files")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7d04b301ea3cf..a5b21f4481946 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1160,6 +1160,10 @@ static int ceph_writepages_start(struct address_space *mapping,
 					/* better not fail on first page! */
 					BUG_ON(locked_pages == 0);
 					pages[locked_pages] = NULL;
+					/* Did we just begin a new contiguous op? Nevermind! */
+					if (len == 0)
+						num_ops--;
+
 					redirty_page_for_writepage(wbc, page);
 					unlock_page(page);
 					break;
-- 
2.53.0



