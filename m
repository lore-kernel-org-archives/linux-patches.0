Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC9715E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KowUHl3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4979CC433C7;
	Mon, 23 Oct 2023 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060602;
	bh=8knGkJumqiZFbwTKkwE2HCfYKJE3370k99y6c6TAzHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KowUHl3QmzG8okc2DIpbDCzrmZOfun7QpufiRYieYy5tSHwO073VApeZZPfvRMmj9
	 RBG95lD73fZtw6gjifQjpEltGVYPcs8UVsXUH6+0edtJp+wkNS3UG7sqzDjHPB0rd4
	 Nsh2Le0qMpclqXB3JJJHSo+2QttVz1QleIquK9Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.4 030/123] ceph: fix incorrect revoked caps assert in ceph_fill_file_size()
Date: Mon, 23 Oct 2023 12:56:28 +0200
Message-ID: <20231023104818.753397615@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

commit 15c0a870dc44ed14e01efbdd319d232234ee639f upstream.

When truncating the inode the MDS will acquire the xlock for the
ifile Locker, which will revoke the 'Frwsxl' caps from the clients.
But when the client just releases and flushes the 'Fw' caps to MDS,
for exmaple, and once the MDS receives the caps flushing msg it
just thought the revocation has finished. Then the MDS will continue
truncating the inode and then issued the truncate notification to
all the clients. While just before the clients receives the cap
flushing ack they receive the truncation notification, the clients
will detecte that the 'issued | dirty' is still holding the 'Fw'
caps.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/56693
Fixes: b0d7c2231015 ("ceph: introduce i_truncate_mutex")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -619,9 +619,7 @@ int ceph_fill_file_size(struct inode *in
 			ci->i_truncate_seq = truncate_seq;
 
 			/* the MDS should have revoked these caps */
-			WARN_ON_ONCE(issued & (CEPH_CAP_FILE_EXCL |
-					       CEPH_CAP_FILE_RD |
-					       CEPH_CAP_FILE_WR |
+			WARN_ON_ONCE(issued & (CEPH_CAP_FILE_RD |
 					       CEPH_CAP_FILE_LAZYIO));
 			/*
 			 * If we hold relevant caps, or in the case where we're


