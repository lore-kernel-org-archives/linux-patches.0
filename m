Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281921DE4FB;
	Wed, 19 Mar 2025 14:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395188; cv=none; b=Zoh6IRhFaF3afi1iBNbxsbL6WCOc+rgBJK2vz46lDdKnKTS3qC/HsEyFLLsBsVqkYF9yHsgJ8MvgdEmlpMluJBt5dQZufCyuTr3dDbSN0wb7nsiBaiMKDbZ6HDjgsIHeXKMNh7o2nwboAF/HTo0lFioMwAHlPlQJAkanNAUpndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395188; c=relaxed/simple;
	bh=ltPrECMu3vT2wOmM7T2K5ToOxWvKxf63qO/rXBZliuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RknJ4e72ly5JxwHDlOF7lJrJDLzXzz0UrQ5JKlN6H7FMQtjZiWHIiNxMjKcMPwb9z6FtrBcCTb5+/MSajGaNuA2Rf/jfUNS6K3fekRxlYPbXcaFMLyh5J82R3T8eL2rfxWTcigbZ1RL1Yo690vSfLz17WmLu/5Ajy9ggU0UFATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWBSzO57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWBSzO57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C53C4CEE4;
	Wed, 19 Mar 2025 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395188;
	bh=ltPrECMu3vT2wOmM7T2K5ToOxWvKxf63qO/rXBZliuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWBSzO57x9IpDiJbEP/uwRljnD0nUmj2OhwZuucVhjmPClvAtcRgFwepZFpW1Cxr3
	 xeNB2zUGd4phvMvXMZUhzbM70DYQwhQG7r+fGATcQHk1k8PpS/3gF6idAlksNrmrFz
	 wB1oLAyltZy4F4fNzXN0KHKr8/e85h6u6ztRQbX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/166] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Wed, 19 Mar 2025 07:30:18 -0700
Message-ID: <20250319143021.265999846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 773dc23ff81838b6f74d7fabba5a441cc6a93982 ]

When the client attempts to tree connect to a domain-based DFS
namespace from a DFS interlink target, the server will return
STATUS_BAD_NETWORK_NAME and the following will appear on dmesg:

	CIFS: VFS:  BAD_NETWORK_NAME: \\dom\dfs

Since a DFS share might contain several DFS interlinks and they expire
after 10 minutes, the above message might end up being flooded on
dmesg when mounting or accessing them.

Print this only once per share.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 24b1738a35a15..1b6cb533f5b87 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2162,7 +2162,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5



