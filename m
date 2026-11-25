Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623037;
	b=JgvMH7QRjRf/fnb9Y6CxxxBhUSLMC25Ro+1Cy/buJFst1GUlT7UK1IlA3tQ0EXWk7bO4
	 WPwILHePpvCnw43EmvVNT9aC+gyYrk2c7vX1fVQucgQ3MjmLgA5UErkLnoQe112m4d2cs
	 YKgt/pk6GZBrdnLvx6ETc9d96blQcL9Jr/hYXmFRA83rvGv7t9seBSlACMRAthi3uQSTn
	 Cr56K++lCHxPMmcHQpq597H2DLwzftp6Gyczy6AiL26MzKWZM2Cgd9bjEZKJPHZqIlngU
	 9TrwZjG8S4c5i4XUfB5nlP2h/toSp80Co9q+zorWBAfoetVAH3fpJLfbCFf9UL/U7og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=48e9GXF7nIvz+22kj0F9nRgz7nRgUzNulpiXqDhL9/8=;
	b=DZOrlT/eVxph07q2KdKXGZST/kaARD/vfiakn78Bn6TqLWEawfVmmAa17IuL0fG30jQU
	 TuDj/yTeW7LOhPifSnJ5+XRy9w0ypfgMF8/bbhD0GzTdnxkCLV+A6ZxM3J4/ZXbMCsMI0
	 qtBGqtbjpqj+H8Vsz5sBDHzEhEIJeMrics4fNQcCrf6So3duAn2P0ZjaK964uh22r58PO
	 p6HAD8xu+6R/8vC+LfAcL3o51YVM34GvBI6Sp4zr4QR2WOGeu7qm4BlHybspZHE8Mkd5u
	 //7SyV1rd7mKMww/qX6/buD9Kwz4Llig9nfYJjcIeVd0FK/raoKvgTIYWph8Svmlf7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=triJvMo9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF17F606A323;
	Wed, 25 Nov 2026 16:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=triJvMo9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAF61F000C6;
	Wed, 25 Nov 2026 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623036;
	bh=48e9GXF7nIvz+22kj0F9nRgz7nRgUzNulpiXqDhL9/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=triJvMo9K3xJfUrUNIbumG+75jVjJLsu8u3XCm3MzlEi+r0GmuUtW4eSfvOfGWMrC
	 K5Gb8Ead+nXwNOyD75xjsJ5a+4tx9JfP5YbR1K0wpNFTo6SMkhDlmZViXInq1FVrGM
	 aKrvRo7ykCMpcrnMGOR4dhCihQhX1SrP4tz+bml0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 727/990] netfs: preserve prepare_write errno on reissue
Date: Wed, 25 Nov 2026 15:34:54 +0100
Message-ID: <20261125143839.103564801@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit 62869ecb3aeca670b86058387e7533a33524b95b upstream.

prepare_write() may call netfs_prepare_write_failed() (FAILED + errno)
before write_retry calls netfs_reissue_write().  Clearing subreq->error
to 0 for a clean I/O reissue (82e8885bd763) then makes
netfs_do_issue_write() terminate with 0.  The collector copies
front->error into stream->error and mapping_set_error(), which ignores
0, so writeback failure is silent.

Skip clearing error when NETFS_SREQ_FAILED is already set;
do_issue_write() already terminates FAILED subrequests.

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/write_issue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -252,7 +252,9 @@ void netfs_reissue_write(struct netfs_io
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
-	subreq->error = 0;
+	/* Keep prepare_write() errno; do_issue_write() terminates FAILED. */
+	if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+		subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);


