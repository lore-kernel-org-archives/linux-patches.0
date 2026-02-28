Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FBC36920B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300922; cv=none; b=SbaDLLm7jMIro3H/UXGWxuLQwx4Tive6SRALfo8zdHfZqGAr6lr5qfXP5UCB6mWM1NnVfXxGSsOP/pcfQsfvmN9C+Vik2lC5UXxbH+RCAIdXy+MvP7+9ZqjR/nNygCO85RkD4pPZzDLnVrwmeaZkvjZshAB55+Nq6v15ovu32x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300922; c=relaxed/simple;
	bh=wv5ACQbq1QkgwgoM5yFwXDuiRkVMo6nSGmwPBVbVL9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRMboZY/hOcqktzStFz/5dNUJnyiM3JW0i3VYvSKNPehmzxc6VMqHMfBqK44HVrMEqPArGKRlhgsPM6/TL6QTeZ4cL1zmXNwoywbtXznL/WGDpE3ZtFFF5NYqcOGRaRIlUl4MoWnHBtNcNSyf6bX/Qg7o9TmnRwTikrO42DCMp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9aCShpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9aCShpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB651C19424;
	Sat, 28 Feb 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300922;
	bh=wv5ACQbq1QkgwgoM5yFwXDuiRkVMo6nSGmwPBVbVL9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9aCShpbKQVuPn4/0fybteMi8Owi3Z5WDteM5OzpNd23KAUC3KL+VZOmmlLiSkrdC
	 3oAUEhVHSF2+4WXuTf0ZzpjxvmC/SgmXgnTSS+0KS22tv2Y7uxgl778Z+8UiR4zjOG
	 xlwyx48tttSs9nb8xwt7xcBvMOYDV+NoTSV9fInl3a/+yXpn/Sek2QvquG8jKxX2SB
	 1yvhfZ7TS/G0DjF/mGJCB3MBxECSe3OXahP4YmBdVGUm/+dJijtBQhnIo3oNYf1RtA
	 eflik1UkfVsQ5rCTOPmzF8vA9n1foJtEQ60u6dx6h8vTzDjq4iZbuF+0KTEfzdwQMG
	 A9gLcJjwqsY4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/752] smb: client: add proper locking around ses->iface_last_update
Date: Sat, 28 Feb 2026 12:35:50 -0500
Message-ID: <20260228174750.1542406-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit e97dcac3dc0bd37e4b56aaa6874b572a3a461102 ]

There is a missing ses->iface_lock in cifs_setup_session,
around ses->iface_last_update.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2f94d93b95e91..d96d23a8f4903 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4267,7 +4267,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		ses->ses_status = SES_IN_SETUP;
 
 		/* force iface_list refresh */
+		spin_lock(&ses->iface_lock);
 		ses->iface_last_update = 0;
+		spin_unlock(&ses->iface_lock);
 	}
 	spin_unlock(&ses->ses_lock);
 
-- 
2.51.0

