Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF17155C90;
	Tue, 18 Jun 2024 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715520; cv=none; b=VRArwI3xgztPVEgzMSNIYmXdpmytigFokj60G3eKO18QprvDT1ICdyLbFY3NugJ4HF70w9Tq0cRBBirATuNcszDv12F6WHmOmpTcPff0EAaadzQlNQqpp5SYFlxKCic7tHtiQ/z/5uVnG6qjuk8lfW0BG+jaRfoH7ajQ0gXLCmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715520; c=relaxed/simple;
	bh=SFkQNi0+zBSQMq1tFpmFWm+IRycoMwJeKHuMuCq//rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8qBVG3UWKN9+d29nlzk3aKh1vOio2bF5QXYKHtO1SLdNwwrZJvT2KMeypeh40z5T5pT8DLJDac+XzeIjkcrtql5n5gI/nIgUAE+RJzGVR4B/NUWdIqZBGE3ijUppHTK2x0etTDb5ZPEIHgyKvB2W0qOC8Wl1T3SUjF4iaI4cnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gKUrASf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gKUrASf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5896C3277B;
	Tue, 18 Jun 2024 12:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715520;
	bh=SFkQNi0+zBSQMq1tFpmFWm+IRycoMwJeKHuMuCq//rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gKUrASfrukHya7OWwg6NNgC2+7cf4Xy/tK3UZDGo3Ur/FpumRhzknpYgiaaTLHVM
	 8TaYKJvTlZ4+lILMxhDFZE+JEve7fg1oJAdYzD6Vk2VhqeExnrHtM2T72b8e+Y908S
	 DHe6my6fs/wDHfgSxadf38D/O5ZK0Nx4JqCDMxJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/770] fsnotify: replace igrab() with ihold() on attach connector
Date: Tue, 18 Jun 2024 14:33:09 +0200
Message-ID: <20240618123420.238263157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 09ddbe69c9925b42cb9529f60678c25b241d8b18 ]

We must have a reference on inode, so ihold is cheaper.

Link: https://lore.kernel.org/r/20210810151220.285179-2-amir73il@gmail.com
Reviewed-by: Matthew Bobrowski <repnop@google.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/mark.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 7af98a7c33c27..3c8fc77d3f072 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -493,8 +493,11 @@ static int fsnotify_attach_connector_to_object(fsnotify_connp_t *connp,
 		conn->fsid.val[0] = conn->fsid.val[1] = 0;
 		conn->flags = 0;
 	}
-	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE)
-		inode = igrab(fsnotify_conn_inode(conn));
+	if (conn->type == FSNOTIFY_OBJ_TYPE_INODE) {
+		inode = fsnotify_conn_inode(conn);
+		ihold(inode);
+	}
+
 	/*
 	 * cmpxchg() provides the barrier so that readers of *connp can see
 	 * only initialized structure
-- 
2.43.0



