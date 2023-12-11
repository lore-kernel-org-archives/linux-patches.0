Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC776E548;
	Mon, 11 Dec 2023 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2ZJ4Xqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44898C433C8;
	Mon, 11 Dec 2023 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321178;
	bh=cAXtNz5qdw/mtkzv1Isgo8dQqYbtPZ7E5fsuBLQ7tfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2ZJ4Xqri5yNYFkZFYuwcXkiYKWTCZUgJ7NhmDj7o13ihkeoonrIRpTA4QEJybRnX
	 2p3MWG4caI1zvceRQixN9N2+72msO3bI9JrccJtr6rARTWNxM9DaA2bfNoW8oypp9y
	 C+ttI9pyDR5SO6s0wBgCgHNXMgnERk9Yc4caVkIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/141] smb: client: fix potential NULL deref in parse_dfs_referrals()
Date: Mon, 11 Dec 2023 19:23:18 +0100
Message-ID: <20231211182032.656086152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 92414333eb375ed64f4ae92d34d579e826936480 ]

If server returned no data for FSCTL_DFS_GET_REFERRALS, @dfs_rsp will
remain NULL and then parse_dfs_referrals() will dereference it.

Fix this by returning -EIO when no output data is returned.

Besides, we can't fix it in SMB2_ioctl() as some FSCTLs are allowed to
return no data as per MS-SMB2 2.2.32.

Fixes: 9d49640a21bf ("CIFS: implement get_dfs_refer for SMB2+")
Cc: stable@vger.kernel.org
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d8ce079ba9091..7c2ecbb17f542 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2926,6 +2926,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 		usleep_range(512, 2048);
 	} while (++retry_count < 5);
 
+	if (!rc && !dfs_rsp)
+		rc = -EIO;
 	if (rc) {
 		if (!is_retryable_error(rc) && rc != -ENOENT && rc != -EOPNOTSUPP)
 			cifs_tcon_dbg(VFS, "%s: ioctl error: rc=%d\n", __func__, rc);
-- 
2.42.0



