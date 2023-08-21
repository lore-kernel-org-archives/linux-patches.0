Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D651171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28BDC433C7;
	Mon, 21 Aug 2023 20:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648211;
	bh=S1xl9s7QHzMAhFxvD89ZNdTJOSpsqrBvmXJi6ZyLEaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oH5DxtYE+FNr1tQq6aP71kNsijF9jPXuduJu5OfftKygi0MLBXiq004kCKaynpk44
	 tiKkxft7ySMMXaWfUrMf9cFLhUOb766knpbUZ4UiBQiIbr+P3No8/o/G0w1iUz98z4
	 9Pxdn2R55bkejkuK7U0dDHtnU68IMyJz+xDvP/ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 066/234] ceph: try to dump the msgs when decoding fails
Date: Mon, 21 Aug 2023 21:40:29 +0200
Message-ID: <20230821194131.690965436@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 8b0da5c549ae63ba1debd92a350f90773cb4bfe7 ]

When the msgs are corrupted we need to dump them and then it will
be easier to dig what has happened and where the issue is.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 83c4abff496da..5fb367b1d4b06 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -645,6 +645,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 	err = -EIO;
 out_bad:
 	pr_err("mds parse_reply err %d\n", err);
+	ceph_msg_dump(msg);
 	return err;
 }
 
@@ -3538,6 +3539,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 
 bad:
 	pr_err("mdsc_handle_forward decode error err=%d\n", err);
+	ceph_msg_dump(msg);
 }
 
 static int __decode_session_metadata(void **p, void *end,
@@ -5258,6 +5260,7 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 bad:
 	pr_err("error decoding fsmap %d. Shutting down mount.\n", err);
 	ceph_umount_begin(mdsc->fsc->sb);
+	ceph_msg_dump(msg);
 err_out:
 	mutex_lock(&mdsc->mutex);
 	mdsc->mdsmap_err = err;
@@ -5326,6 +5329,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 bad:
 	pr_err("error decoding mdsmap %d. Shutting down mount.\n", err);
 	ceph_umount_begin(mdsc->fsc->sb);
+	ceph_msg_dump(msg);
 	return;
 }
 
-- 
2.40.1



