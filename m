Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22251616E;
	Wed, 30 Sep 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784565; cv=none; b=tFEw1V7+cr6BlJr1kyyT4E3qdlgkBLPjO8hOrWom/ZtCc406hjX7bMk6EgW/i0mh93Hbor3WWBEujF3iBlSOYa5+G/O72GUaACIVoXrGELLCtOG+6WG4yp2G1tRp+xf8k6Or4EhL2P/J70rf2mGNu5lU6Lt1qdUdDvtF9woYZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784565; c=relaxed/simple;
	bh=r3sli3YZnAGog/O+JAlmXrrrvDNvwhzGIcqQpeoA6iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc3HZtHmMOqoNnMZTC9dbPoVHYWY90x6szOqkseHckcR3yjwmbA7Qpii8CDgeuI4e0uZdf/TgGTpfqk6d/sCu92rJTOENnuS3XaTF40j4H4G/9Uzua8Z+60NenBMbFQrbvgDKPfLAVKwq9mY0F7T9MBzbRRzsvKK5t5wnpReqE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGq7DdMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGq7DdMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C807B1F000FF;
	Wed, 30 Sep 2026 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784561;
	bh=AbbekaMY3KWZmFdyQlGAzPY9JLIPtOXekznVcrkHP/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGq7DdMXkKWBKdVanwWUj7iKcvbCjvuLv7WPFEY5250qB9DEKrahzjdPscvZ+eirr
	 /lk1BOvFm97Ausph7qSgzsfZlGeDy1Q8apBmeg8adA8iXt/pAxcMkhsm6HAGZMeis9
	 6jlcsOHhIhB4q4hKV6er2za3P1wBhhPEV/d8P1i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/982] fuse: set ff->flock only on success
Date: Wed, 30 Sep 2026 17:15:34 +0200
Message-ID: <20260930152421.065668563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 71947173cef279be5eed209ec28f8c11f9d73159 ]

If FUSE_SETLK fails (e.g., due to EWOULDBLOCK), we shall not set
FUSE_RELEASE_FLOCK_UNLOCK in fuse_file_release().

Reported-by: Li Yichao <liyichao.1@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 30da0d0397f23..56774b31d5ff6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2668,8 +2668,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 		struct fuse_file *ff = file->private_data;
 
 		/* emulate flock with POSIX locks */
-		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
+		if (!err)
+			ff->flock = true;
 	}
 
 	return err;
-- 
2.53.0



