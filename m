Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F004333443;
	Mon, 29 Dec 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026050; cv=none; b=TuX8ebQWCbtB79TLrriaox72S8sVSuZkGx7XC4phrGc7/0taBEIuS3yba6jfbkE6dV3FvBnWP/pMxCLAFym9ByrDDVeEhbRYXLf4NHuh530aWZT9ZF/dgzLcY3MRf/KOnRIn0hKC9vLxPTXbDK01RiwQcUntO8GFRlF7dN8igVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026050; c=relaxed/simple;
	bh=2XzZyBs039k4/L/tjlMkoChO3rvZD2MMpTMNaz5ywCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBA2wqUVnq04NVMEtMubTRdkKJ3mz7Qw0fzmPjUdhd+FnmFZU+uUOjzL028wbpMYHYIZCRNAlVcbs97463PDK9Su3tN7fwewuJuOH+MwXNmG5q876EXPMAiyATjW+Vm5CuAwl98ntrLu2mU5d67WG5u8JcoVIFY8rEDY5GI+HDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCH4IDSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCH4IDSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628BC4CEF7;
	Mon, 29 Dec 2025 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026050;
	bh=2XzZyBs039k4/L/tjlMkoChO3rvZD2MMpTMNaz5ywCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCH4IDSnQfiBSeZXmaCVQtklmkMCABvSv/oxBIfvz8Sy3MUwJ1wBGjjgaCdrU2Ox8
	 tc2VXNY+WadxinbQOKXpEfsK5Mq6q5fZS116z7/O/zWwZB9/XsgGiCopmArQ1FsOB9
	 mRmj/XE4HBgDcXd0s9xwCGs5u/ZRU8x/SEsJgbcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ding <cding@ddn.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 430/430] fuse: missing copy_finish in fuse-over-io-uring argument copies
Date: Mon, 29 Dec 2025 17:13:52 +0100
Message-ID: <20251229160740.133906280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Cheng Ding <cding@ddn.com>

commit 6e0d7f7f4a43ac8868e98c87ecf48805aa8c24dd upstream.

Fix a possible reference count leak of payload pages during
fuse argument copies.

[Joanne: simplified error cleanup]

Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@vger.kernel.org # v6.14
Signed-off-by: Cheng Ding <cding@ddn.com>
Signed-off-by: Bernd Schubert <bschubert@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c        |    2 +-
 fs/fuse/dev_uring.c  |    5 ++++-
 fs/fuse/fuse_dev_i.h |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -846,7 +846,7 @@ void fuse_copy_init(struct fuse_copy_sta
 }
 
 /* Unmap and put previous page of userspace buffer */
-static void fuse_copy_finish(struct fuse_copy_state *cs)
+void fuse_copy_finish(struct fuse_copy_state *cs)
 {
 	if (cs->currbuf) {
 		struct pipe_buffer *buf = cs->currbuf;
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -599,7 +599,9 @@ static int fuse_uring_copy_from_ring(str
 	cs.is_uring = true;
 	cs.req = req;
 
-	return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
+	err = fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
+	fuse_copy_finish(&cs);
+	return err;
 }
 
  /*
@@ -650,6 +652,7 @@ static int fuse_uring_args_to_ring(struc
 	/* copy the payload */
 	err = fuse_copy_args(&cs, num_args, args->in_pages,
 			     (struct fuse_arg *)in_args, 0);
+	fuse_copy_finish(&cs);
 	if (err) {
 		pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
 		return err;
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -62,6 +62,7 @@ void fuse_dev_end_requests(struct list_h
 
 void fuse_copy_init(struct fuse_copy_state *cs, bool write,
 			   struct iov_iter *iter);
+void fuse_copy_finish(struct fuse_copy_state *cs);
 int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
 		   unsigned int argpages, struct fuse_arg *args,
 		   int zeroing);


