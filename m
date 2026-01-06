Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE2735C1AE;
	Tue,  6 Jan 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721563; cv=none; b=S8oYIGrIemCg5BgIo4WDKWBSF4HEQFHLveZ8CA2Ifd5aXxOnObdMs6rGoGdWsWpIwXbmj8n3ILyRO/1g6kmYSed7N9iyj6LLVGjLeApyc8Q255sWJW5NkPZbkU6xXt/EQMnQA88k9j4vTcQljfvHwFkqfMcg9pNl1dyVIvmGZeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721563; c=relaxed/simple;
	bh=cMLUsIgpdySYd2Vr0cQoh9mAAnD7p29+zQwaQLKN9KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPXvlvov9s1ZPJqCbqvp2d73+mjLKpSWQTySGrp8FdwFb8Yp+XQ+9MgVvUoIshz3SofMRfWRQezkgf5q8SL6TnAaqv2HWFLx/AzzrqJw2/f2P9d+Ybi3dJEP2Gxq9H2l85SzOVHWIEyQzQ7BZecPQS1I3mZo/Vp1M02mN0lqidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EJZHuif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EJZHuif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037E4C116C6;
	Tue,  6 Jan 2026 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721563;
	bh=cMLUsIgpdySYd2Vr0cQoh9mAAnD7p29+zQwaQLKN9KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EJZHuifXbj23eIyDKT9osdvysL6glg4UgcDU6gmy+x3giJQvZJk4uVOPzkY8txt3
	 R3A1HWH53jZ6VCiHQ4Pq+n21gfcCveWbmwKEXbH+0VmyZPIaXut6Yo6H31oKvAxbdQ
	 GPy1uik+RLY6odoPF4E/8aoLQcaw+2eJ5lnRrLTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 566/567] iomap: allocate s_dio_done_wq for async reads as well
Date: Tue,  6 Jan 2026 18:05:48 +0100
Message-ID: <20260106170512.373761031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 7fd8720dff2d9c70cf5a1a13b7513af01952ec02 upstream.

Since commit 222f2c7c6d14 ("iomap: always run error completions in user
context"), read error completions are deferred to s_dio_done_wq.  This
means the workqueue also needs to be allocated for async reads.

Fixes: 222f2c7c6d14 ("iomap: always run error completions in user context")
Reported-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20251124140013.902853-1-hch@lst.de
Tested-by: syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/direct-io.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -674,12 +674,12 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 			}
 			goto out_free_dio;
 		}
+	}
 
-		if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
-			ret = sb_init_dio_done_wq(inode->i_sb);
-			if (ret < 0)
-				goto out_free_dio;
-		}
+	if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0)
+			goto out_free_dio;
 	}
 
 	inode_dio_begin(inode);


