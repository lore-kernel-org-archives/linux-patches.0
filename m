Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B6208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs1PtCYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C60C433C7;
	Mon,  6 Nov 2023 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276670;
	bh=dku8PJKIIUHgxpu9MT8zwtrHwArmYpXzoIuBQolG9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hs1PtCYbj8ADDjcgz1Eaa4OTpF3ixgTDCXu37SreghbwaYzDqqGDCb837KIKJE0nB
	 ArdYegDt5hbHHnDT8uSlzHhbk8vuC4N2GPr5Ba3RzYKuGIe4aJwW9laRzvOrJnrgdm
	 RBUIZ376m/53Ge+MVthk2MjDxrpU4eDQQ5CJG5so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 59/88] ceph_wait_on_conflict_unlink(): grab reference before dropping ->d_lock
Date: Mon,  6 Nov 2023 14:03:53 +0100
Message-ID: <20231106130307.977491036@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 4b0ba067e9c93..e40aafbfa7b9f 100644
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



