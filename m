Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13294340A57;
	Fri,  9 Oct 2026 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555395; cv=none; b=QkmnZkoqtPlHmvZUtZYYcIjOjDLTO9MdSKHG8bt318kOQlmlaZs/BueZowrNaueKomjSTpbnp3ViunKnqBc5Q6i6UJv0rlwKnU1sHnu8ADDM5QT9umH7H0XesBzDbRbmvjJp3wH1VsCuStpZl4CcWhnlzL0FN1SOtVz8Amke5NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555395; c=relaxed/simple;
	bh=f/r9f42gTA0hhQdHrmYFNXB2ry9GJrfNgAjfpfuDRm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM/BSHS8TquvcIOrdJg9v+5eESMpkSAVDvi+3mriDBD2okQqGt0Rjao7se4RzzVjC+fYrMzZyab5AbL0jfZMDC4kXoPVqk/BWWxh6jJtN1cm+aPQSrb2fwZYxNpTUPXBm5cmgkUSFrEtND6Pgq0ZuGTSIXEo7CTA0ysjlVmSVAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt8orbZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt8orbZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D937E1F00893;
	Fri,  9 Oct 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555390;
	bh=nzhQOq2d75vHLVx48lT5Nht/83741YalV8d647g8PW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pt8orbZ6VIyeBCoeMgVTCw3Drm5ChNTmYdSVmuYA332Pt9VFSYeYfPCDLwZoj+ozf
	 9Yx+d4kpFVAubp7jXFi8oYsZaMOdiWet/WB/vzO9oix2Cm1UUGQ24MiV6u0zankMt8
	 YWquMMqy96b0LMiCxywVFBx+4eXNZHFepabmNBjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.18 041/403] netfs: zero gaps in read-gaps folio to avoid writing back stale data
Date: Fri,  9 Oct 2026 16:06:42 +0200
Message-ID: <20261009140953.068835893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit 8db55c5cd831a786a1a2a2d391aa80354535a353 upstream.

netfs_read_gaps() leaves gaps around a streaming write's dirty region
unread on the server side, so a short/EOF response there left stale
folio content that later got written back.

Zero it after the read completes, not before: netfs_wait_for_read()
returns rreq->transferred once ret >= 0, so build an iterator over the
same bvec array the read used, advance past ret, and zero the rest.
The dirty region already maps to sink pages in that array rather than
the real folio, so this can't touch it, and only the actual shortfall
gets zeroed instead of the whole gap upfront.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/buffered_read.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -460,6 +460,13 @@ static int netfs_read_gaps(struct file *
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
+		if (ret < flen) {
+			struct iov_iter iter;
+
+			iov_iter_bvec(&iter, ITER_DEST, bvec, i, flen);
+			iov_iter_advance(&iter, ret);
+			iov_iter_zero(flen - ret, &iter);
+		}
 		if (group)
 			folio_change_private(folio, group);
 		else


