Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BDD2745E;
	Fri, 21 Nov 2025 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731824; cv=none; b=pibRb2WlKyXzdQDSDnxjgk4ZbSzvTRXuDLmDRMiwHCACTOdGUHSDViUxPjQXQgn37vZnReRJVmPaLy95dwoi45h+FwYhgEotblQzvHo2628TjxZ4nIj/Mcz0oplCkRwyT6Uq8q9OQZdwL0hB7ASD0nKtF0nEmOS+9+u8XSwbU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731824; c=relaxed/simple;
	bh=1gjVNsrj3cRqCVOfrdqqsG337gz2cIC7FikyULHnqZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fM4x0oJvwVBvCWnAf1c39qj5qqRtSbI5rLnTMxyAEp7gj4Ws6Xbr3JvzxycHIXZ6pl+ewLBYdmCN/o0QHG8cJ2DJd/MiEu/7Hos+rr72d996u+fhSGu+hCoApw2/qy9JSm413mdooZwdt32in69tPgt/OjXyHUt4NoYTpp3b5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCwTc6gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCwTc6gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4605AC4CEF1;
	Fri, 21 Nov 2025 13:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731823;
	bh=1gjVNsrj3cRqCVOfrdqqsG337gz2cIC7FikyULHnqZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCwTc6gr9dD0OqIg8MGv88PxDLykX0iU1jj1gsQkplIqoLU54nCDGicMgb6dBN4Z6
	 xgPpiG+D+oFHXNs42kuBpNBut36/mzC0av80xKbTvErIzpCf+i79fUgBdMGncoWtJh
	 pX4fXyl9zzvHXHR8/9WKfDaSbfU3uO+72mi0dY48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/185] virtio-fs: fix incorrect check for fsvq->kobj
Date: Fri, 21 Nov 2025 14:12:01 +0100
Message-ID: <20251121130147.260172910@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit c014021253d77cd89b2d8788ce522283d83fbd40 ]

In virtio_fs_add_queues_sysfs(), the code incorrectly checks fs->mqs_kobj
after calling kobject_create_and_add(). Change the check to fsvq->kobj
(fs->mqs_kobj -> fsvq->kobj) to ensure the per-queue kobject is
successfully created.

Fixes: 87cbdc396a31 ("virtio_fs: add sysfs entries for queue information")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20251027104658.1668537-1-alok.a.tiwari@oracle.com
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 749c9f66d74c6..c81f7b888c385 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -372,7 +372,7 @@ static int virtio_fs_add_queues_sysfs(struct virtio_fs *fs)
 
 		sprintf(buff, "%d", i);
 		fsvq->kobj = kobject_create_and_add(buff, fs->mqs_kobj);
-		if (!fs->mqs_kobj) {
+		if (!fsvq->kobj) {
 			ret = -ENOMEM;
 			goto out_del;
 		}
-- 
2.51.0



