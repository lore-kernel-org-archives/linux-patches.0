Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72CB1E525;
	Mon,  1 Apr 2024 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989893; cv=none; b=cmvHP+arlIGGg+RWo9iUrjn8NOzSMMzqZ5drVOu5/LFVSLsfU8W899IbNWycGg+/kOzXo8QNL4dJd7qXHBM5R08s7PFnsVahsPBftjdAZlKUP8g5gB1Es/NVetWbkVQpOrBERpzS+l42/blSprBpT92yRdbFDG+O4kV/70SzRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989893; c=relaxed/simple;
	bh=luflWCn8FsuUII6wE7bFuw4Tn4aldvRHhfg8zLir2nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmDy9X22QKyCmmedM/iqV1BPuDNQ4y2qejPQxpYfu/em5CIajznZWsgRpuhYJ5TBDGUNEmAABDSeRDVX9a6uP2KNzIcpIM7kgju+LtYph7lbO0KxBZV8LAUnlhREdXWMJM9xpanrVZEdz0H420iReMyjBwhop8L/UreXnS49ntg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUFDkbJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUFDkbJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35995C433C7;
	Mon,  1 Apr 2024 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989893;
	bh=luflWCn8FsuUII6wE7bFuw4Tn4aldvRHhfg8zLir2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUFDkbJTeCJOsqA5qD5Dfh6J/iHs6SC7urZxkGv0wQzpzw8r+5yxada92QjaFdkbl
	 H/NWWf2Yq29MYU7cLvLorsDUba4NmpRsWnzFc5cY3KYCTkpAnpGHRaVaWxnDyMZqZg
	 Atl8AwvC49Yjcow3OMDuu5YWdTocUfxrWPlUVVfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/396] cifs: add xid to query server interface call
Date: Mon,  1 Apr 2024 17:43:25 +0200
Message-ID: <20240401152552.595986877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

[ Upstream commit 4cf6e1101a25ca5e63d48adf49b0a8a64bae790f ]

We were passing 0 as the xid for the call to query
server interfaces. This is not great for debugging.
This change adds a real xid.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 13c0a74747cb ("cifs: make sure server interfaces are requested only for SMB3+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a4147e999736a..2a564f19dbb39 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -119,6 +119,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 static void smb2_query_server_interfaces(struct work_struct *work)
 {
 	int rc;
+	int xid;
 	struct cifs_tcon *tcon = container_of(work,
 					struct cifs_tcon,
 					query_interfaces.work);
@@ -126,7 +127,10 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 	/*
 	 * query server network interfaces, in case they change
 	 */
-	rc = SMB3_request_interfaces(0, tcon, false);
+	xid = get_xid();
+	rc = SMB3_request_interfaces(xid, tcon, false);
+	free_xid(xid);
+
 	if (rc) {
 		if (rc == -EOPNOTSUPP)
 			return;
-- 
2.43.0



