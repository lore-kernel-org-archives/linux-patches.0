Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06A1ADC83;
	Mon,  4 May 2026 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903539; cv=none; b=hkanZ1Y3iGFi5ZVkQwaYkx1I39izuPGbiG9/tJx3IBJ1cfBiITjlP/w19MW3AuyRfDXJiA7JAAlyckqiqM7acB96s62J6Kd3PqelcjHNnM8f58xZgS0A3inlFQNNyJhkVhA8fhDKKDX4H1JcjZVNMKZwuMgmXHVznMpuDuzaF6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903539; c=relaxed/simple;
	bh=IzA9ou30KLzLCCi/ATmoSIhGVksXepwx0KAqu/OGf6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpVIhGIRAiaiMf0x5WoN/o0WrS8TazlIrTM4YB+8inJ+qxMUhaddASje9jOealDnPJ292f/ooyBpx+bC9HWTVrwdbuxVF9B+ETo25Qn4jNlhgUa1ivT8DczY2q2jS4VohBLto0MTny1O2KKXUVoK5b3E96UstVV5I2TXmk6CUdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Suhn4zR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Suhn4zR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15333C2BCC4;
	Mon,  4 May 2026 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903539;
	bh=IzA9ou30KLzLCCi/ATmoSIhGVksXepwx0KAqu/OGf6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Suhn4zR7CwjrSiC3ikEDCpRGmzEx5GuO9r5eMCAdDNaw1+0tNJ4kXpLww3P3FeuqN
	 xml3BZvXFPYHJ08a+jky9U2CkEpNFQLyi94+o2YZaUb+1UkhQLDa26d4gk5NMrUg9F
	 uqIHF5iGfZYivCbjm+hUwTh9b0sxUhl2fOShqsS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 272/307] ceph: fix num_ops off-by-one when crypto allocation fails
Date: Mon,  4 May 2026 15:52:37 +0200
Message-ID: <20260504135153.039404965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Edwards <cfsworks@gmail.com>

commit a0d9555bf9eaeba34fe6b6bb86f442fe08ba3842 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1365,6 +1365,10 @@ void ceph_process_folio_batch(struct add
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
+			/* Did we just begin a new contiguous op? Nevermind! */
+			if (ceph_wbc->len == 0)
+				ceph_wbc->num_ops--;
+
 			folio_redirty_for_writepage(wbc, folio);
 			folio_unlock(folio);
 			break;


