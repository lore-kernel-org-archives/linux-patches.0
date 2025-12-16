Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E88357709;
	Tue, 16 Dec 2025 12:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888190; cv=none; b=hiGDqQx5fdcnPxIM5l7ag6SAvFEtAzpK9U6JxnNVDAR+//KaQHJsqTSDdEYUf+Jo15lvI5Axiny130wN1Nr5XoMZ7Y8QBYaeUF2lRMN6XN/T+VAeLsOy3uu95GRfbsU4XzeosgLc2JXqbx4Q0oGT3cmJEWpSMX6Z68aW2VaAleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888190; c=relaxed/simple;
	bh=GHwrdCvjoAFGtN+QX9II4+/ltq0YhId4F4P7Ew4r7yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc6H/wA0XHeI2rTBMkEHscppNuvFQA+BvmYYCTcgLIC3vHysjvSlhK+wOtcdyGLqt0w0+lju3Qn5ilAMN/9inE5Gq4yF5Ii9npLTBCshfmARMI15GuNsPtZQjizifLpIWpUg1Tfbdadx2WzX3k88DzIH1K68t9+wMwV2XYe/WGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aboV35aE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aboV35aE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40790C4CEF1;
	Tue, 16 Dec 2025 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888190;
	bh=GHwrdCvjoAFGtN+QX9II4+/ltq0YhId4F4P7Ew4r7yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aboV35aEWcQyshaDNxhMmz9RmwbIwZuUlbkkoP3C49+9ynuuWXRh2ugx6zNedco1L
	 r3qtWtVwmQOVpWvVoFMwj2C4FPVlIV982EYO5UMp71v8k8ZaGKYnL9Hq1kGRYDLf6k
	 BSvt8xfnfO4wJaeujYRJYoC49EYGtUypK9CXdOj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/614] iomap: allocate s_dio_done_wq for async reads as well
Date: Tue, 16 Dec 2025 12:13:03 +0100
Message-ID: <20251216111416.444147046@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7fd8720dff2d9c70cf5a1a13b7513af01952ec02 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 143160042552b..6317e4cd42517 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -728,12 +728,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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
-- 
2.51.0



