Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E645D6025A;
	Tue, 13 Feb 2024 17:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845631; cv=none; b=jYzplAXBFZgeIgRs8D5UR0H9QsK6EG3zNsJEVMhPwEiQAmww5yeUL8YLYzs/VnwbHBaH7bd+h6I9qimEGPB0t4LQxsLuuMXDuePPS+dFV5Q9bLFZsAW2j+6cIfIXcdJRb/2jonGiMFVkl8JQf5lp4pDTVf5S2GbOIDdwDGzHq/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845631; c=relaxed/simple;
	bh=3YMAMW9u+o0KHvl2aIDJoWCn5Q1woWiy0jMltdoh5XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4SvuFfRwpDCicHIfN4xPIvZ/IwSXuD4i1HyeD79GVcJ6VOCheQ15MC3h5S3SMIkCFTJJsZnn+l/N7m8krAw7Z5vlv4Fr1e6oHuuYapcbZ2mzUVDYippVkZO3ZgzAVUzXxF250ZSbAVhSTK14aqOtca41DZU9NtJ3XhMPfvh+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsP7kHsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsP7kHsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47286C433C7;
	Tue, 13 Feb 2024 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845630;
	bh=3YMAMW9u+o0KHvl2aIDJoWCn5Q1woWiy0jMltdoh5XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsP7kHswhlzW7jtftysiAogQKeuHXYRN+k5ougyJ5nVMRSd+DmuWltJ2A4L6n0xSp
	 471yvXo4jYTp221J8QMwM/TzemtY+O8OOE5vIykVur0b1MZMTVfv9nCCl5+0G2s4kJ
	 Vs6xDrg43Yh3bigFb9ZHvMFq373pbGA15LsKBWKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 014/124] cifs: avoid redundant calls to disable multichannel
Date: Tue, 13 Feb 2024 18:20:36 +0100
Message-ID: <20240213171854.150669724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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



