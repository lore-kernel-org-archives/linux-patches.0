Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ED3145B12;
	Tue, 27 Feb 2024 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043246; cv=none; b=V39igBLAY1ynnE8Rf+83YORbd3aXwe7iT7TYMtrqf56916OG3Z8pATnElxfc2u6HNzPODJecoOdZHWTXJkCEXHp+J3t1AWy+z5Fic4Ed9QD4JvFqbNGpPfNz1fI5TdtUZkWBC/stw5pdvd4qGO4is0dVno8YGii7aVuqDIu+9w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043246; c=relaxed/simple;
	bh=IetuZnkCMQH7VeI7bdgGji5i9jrwEab0J9P60QL6VHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMWNKzIWGxPWPW69jS1g6wwKjVjJQyJjiDdmrLh53r25e1Q7SG4do1Jx4f2Mj0t9hlqOlXTGo+ZiyJdwKtyJXm6XsEZjOuS4xchironE9iU3cVC5BQFDwdLUhcHaThrXW3X0WpzjnLRyEKmsw8iHBP5eLFFzl+8u7RY9N2tAxic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h24G/j4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h24G/j4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2391EC433C7;
	Tue, 27 Feb 2024 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043246;
	bh=IetuZnkCMQH7VeI7bdgGji5i9jrwEab0J9P60QL6VHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h24G/j4QRIommy3q2bW98wDXikQIv21ueEe6Hr6xA7O3Urku43c1f0Bx1URQGhfCT
	 hkAItVrMThuRuHrNszbxAh9E8OGGU938i7F95cFtpKpfy3O3mDNKYlux5R8s4d0O3+
	 96z017rqb3IwZhpqMNDIi53lXCS/+Win70hqz4Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/195] cifs: open_cached_dir should not rely on primary channel
Date: Tue, 27 Feb 2024 14:24:31 +0100
Message-ID: <20240227131610.742166482@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
index 6f4d7aa70e5a2..fd082151c5f9b 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -149,7 +149,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
-	server = ses->server;
+	server = cifs_pick_channel(ses);
 	cfids = tcon->cfids;
 
 	if (!server->ops->new_lease_key)
-- 
2.43.0



