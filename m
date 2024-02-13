Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B025F56B;
	Tue, 13 Feb 2024 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845191; cv=none; b=sMSgeI0a3NHBHpKWVKyLYWiDkCs0OsHd5WjElbssdtSyyPQl2Jmfl8/OOhVBVso7j3N7/svppodxc8hhiP6jz8wO/zrlltIwZO+9RrTmazyRpr8OAnzfhNW0xwMzec1HOIqECy9RhQVCVQm+tSDA+d7TIYMBnpgpAQximH4dYQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845191; c=relaxed/simple;
	bh=RfXyzkYmCxD56I0c0OxIt8MdL9lP43BZeY7axMCxVgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwY/zBHziDsym6hfS36Q7Sk5F33WU9rzyUptevD82O4Q3Bo1DvuqnNoqyp6i1tKbt8jlylsNRKR3gE1jFU2OaCuZSo4587r6TSdHFf0upf/+7CH6WIwKU+gKYV7oYZjyy9WJuQd0kv6/OKBdNkiW2FNWosvqE3yvm2VgJ3uQwlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpzUnTMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpzUnTMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA5C433C7;
	Tue, 13 Feb 2024 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845190;
	bh=RfXyzkYmCxD56I0c0OxIt8MdL9lP43BZeY7axMCxVgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpzUnTMz4ifzJRARzN5uDRhkw5HdN41GH0oTmttrKcGtBm7rgkkN7TUw1Bok5/kd+
	 mCYFqsXC1ZS8/UD2YPyvISKrAc3dv2M5gJjxQarCLBWNSGOdjVDwN/yF+YNjpNFsmt
	 YLH01/t547ZVZZoLIliScg6uFpzSbq+sfpKpTMXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/121] cifs: avoid redundant calls to disable multichannel
Date: Tue, 13 Feb 2024 18:20:19 +0100
Message-ID: <20240213171853.258037716@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e77e15fa5eb1c830597c5ca53ea7af973bae2f78 ]

When the server reports query network interface info call
as unsupported following a tree connect, it means that
multichannel is unsupported, even if the server capabilities
report otherwise.

When this happens, cifs_chan_skip_or_disable is called to
disable multichannel on the client. However, we only need
to call this when multichannel is currently setup.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f5006aa97f5b..5d9c87d2e1e0 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -410,7 +410,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		rc = SMB3_request_interfaces(xid, tcon, false);
 		free_xid(xid);
 
-		if (rc == -EOPNOTSUPP) {
+		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
 			/*
 			 * some servers like Azure SMB server do not advertise
 			 * that multichannel has been disabled with server
-- 
2.43.0



