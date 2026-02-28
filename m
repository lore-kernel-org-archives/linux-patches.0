Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA18333FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300923; cv=none; b=WwZYPygkfRYtwh2il/UpBuUc7o/FUVHhdM/DouDyz6ch8UNg3GR+U4aAH4ygwAonbNb4fISJFLKhwJtv4wnvYkCIpoV7lX4bigW+P6TpEirayc1pJUjYNczp1Ml3DWDdcWxJ3HQmw3vyIpJo7a7CMy2IP2VP9QkD8uaIX+XqTAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300923; c=relaxed/simple;
	bh=p879vf71f97APmxqn906UXB0tZiLZ6yc7bl9Ov6via4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3pqCp54DgHvNpJGIBV48ZgYl0kimIYwdWmtYCmxO5W+Fyhm8GIc1efwSIMThpE0/dInwXFyf+5Dq0AlgtX6cF0Da62zWYKK5UZCRegynTbiyzyamdUQesloUkRvJNIrNXWyXA3fnLa/er8ZhHVFDvEC7uMCAwuAymU+pLM8R4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfF0rPHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfF0rPHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C5AC19425;
	Sat, 28 Feb 2026 17:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300923;
	bh=p879vf71f97APmxqn906UXB0tZiLZ6yc7bl9Ov6via4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfF0rPHuhFTtHMynz6t6lBvVLPPO1+KceyrBM7adVFMqZFNQuwMWDz74fURy2x/Cn
	 VBxsBnfRWnrakfqvhtPeQfRuOH226uMPT7DPPOO1EM2Butj1gOUitsBMD2D0coI0+x
	 lDGPCq9fKTX8Ko8ZrGsvMSYEXhXNgk96gEIxJ/74WDdzbdZlljCyB/+ZSdS5QKY+YT
	 ZxN7V4QkJMv6z7A1W7tkviZ72irGqfRitRrjQ4nz4720DMbFRjT2XHCVi26iKngTCe
	 XjirgOH/P3P0gJzcjBo8x7if1srD0P/f3rQ6ex2gdVA1ycfMUP308ZHPZbWLCaBmXM
	 rXKwTh+CtbWWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/752] smb: client: prevent races in ->query_interfaces()
Date: Sat, 28 Feb 2026 12:35:52 -0500
Message-ID: <20260228174750.1542406-41-sashal@kernel.org>
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

[ Upstream commit c3c06e42e1527716c54f3ad2ced6a034b5f3a489 ]

It was possible for two query interface works to be concurrently trying
to update the interfaces.

Prevent this by checking and updating iface_last_update under
iface_lock.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1e39f2165e427..c3c5fddb2caab 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	/* do not query too frequently, this time with lock held */
-	if (ses->iface_last_update &&
-	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
-		spin_unlock(&ses->iface_lock);
-		return 0;
-	}
 
 	/*
 	 * Go through iface_list and mark them as inactive
@@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 				 "Empty network interface list returned by server %s\n",
 				 ses->server->hostname);
 		rc = -EOPNOTSUPP;
-		ses->iface_last_update = jiffies;
 		goto out;
 	}
 
@@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
-	ses->iface_last_update = jiffies;
-
 out:
 	/*
 	 * Go through the list again and put the inactive entries
@@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
+	spin_lock(&ses->iface_lock);
 	if (ses->iface_last_update &&
 	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
 		return 0;
+	}
+
+	ses->iface_last_update = jiffies;
+
+	spin_unlock(&ses->iface_lock);
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
-- 
2.51.0

