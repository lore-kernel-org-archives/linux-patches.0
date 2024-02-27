Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24DB13DBA5;
	Tue, 27 Feb 2024 13:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040508; cv=none; b=soJz8pMqYy6ddjt4pTrebFdAKwC4cJi6Iq0y0oprl3OXwgkZGPaoFxhSXCtiPZ454CKjClXx5SoP/qtTeBfq/CrjpxJlu8DAgepL6G3e8+L4chvYCU9R/V1WANU9woZf8+Yhdyt6e3J/QzHbxzLlOIJe2CZEmjtMEaoBkl4UX9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040508; c=relaxed/simple;
	bh=2HINXkMeYIyfPtRAjW9OXrq4I/z1qzF+CVfzGwtF1CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP3zVVD+/qrMdOs6hdkw9KKZjG1Jclkh0+P/o3bBHZXK9udI6Xi6rg/lLVqW9c5/Aw7pCxKb9CAaZjQGEaeYl3saUZwBwDgeUnhOrUwCB9rRjL0aRjuGxlmV5xKm9AXo61yklzLB275S5LmiFGgiFnowZ1CJNC0EpHrClSQRD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EO+SIMT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EO+SIMT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F6C433F1;
	Tue, 27 Feb 2024 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040508;
	bh=2HINXkMeYIyfPtRAjW9OXrq4I/z1qzF+CVfzGwtF1CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EO+SIMT9qlGbtiitjtTAF+c3HSzqCS8fY5UwvcjReAJg81yArgwZkJSRB9oBnthwY
	 nI8896HEn0uS54gc0wmHBtbLYqq7mIXqSV8Q9ffZYYDZniLCpNV3/HK+gK9w/8LL/J
	 iyH/UwwH+EFeg0Rh2krruHRJBDR6VENDlmUWGhT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 010/334] cifs: open_cached_dir should not rely on primary channel
Date: Tue, 27 Feb 2024 14:17:48 +0100
Message-ID: <20240227131630.962528168@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 936eba9cfb5cfbf6a2c762cd163605f2b784e03e ]

open_cached_dir today selects ses->server a.k.a primary channel
to send requests. When multichannel is used, the primary
channel maybe down. So it does not make sense to rely only
on that channel.

This fix makes this function pick a channel with the standard
helper function cifs_pick_channel.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d64a306a414be..9718926205047 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -151,7 +151,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
-	server = ses->server;
+	server = cifs_pick_channel(ses);
 	cfids = tcon->cfids;
 
 	if (!server->ops->new_lease_key)
-- 
2.43.0



