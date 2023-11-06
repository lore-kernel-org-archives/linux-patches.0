Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20420316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0Pl2z69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3657FC433C8;
	Mon,  6 Nov 2023 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276500;
	bh=axEDK5O55io1zjgoyJkO3wYFHvu0kWRfGUn1ENXepYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0Pl2z69GompLPubFf+So5knnz6nf3Tq6NnMA4S4SCwxe/1k3M2tq/thr4HbtmTp0
	 NoZoQp1VjLU9AktLlS1pdbz59r++pG5JoyofwQfrx/1P4C1ivIH+BY+mO+EJQY48Qe
	 GrY0U8aQYBffeiDHUsGnZBaG3rKjc6SVDEc1ZqnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/62] ceph_wait_on_conflict_unlink(): grab reference before dropping ->d_lock
Date: Mon,  6 Nov 2023 14:03:45 +0100
Message-ID: <20231106130303.230455325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit dc32464a5fe4946fe1a4d8f8e29961dc411933c5 ]

Use of dget() after we'd dropped ->d_lock is too late - dentry might
be gone by that point.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f6a7fd47efd7a..82874be945248 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -709,8 +709,8 @@ int ceph_wait_on_conflict_unlink(struct dentry *dentry)
 		if (!d_same_name(udentry, pdentry, &dname))
 			goto next;
 
+		found = dget_dlock(udentry);
 		spin_unlock(&udentry->d_lock);
-		found = dget(udentry);
 		break;
 next:
 		spin_unlock(&udentry->d_lock);
-- 
2.42.0



