Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A4344DB5;
	Sat, 12 Sep 2026 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203929; cv=none; b=C1w08F7nrw8U16cXDH1oJbkfH4Mv3dkW2lhV/XV+Cx+WP27zaS2/Or25b/dmLs0WfXGnAhUklZs23aZHZDaUABbT72U2x/DyPcygNFtjoH0WH1bTHDk4jsadrv0pW8Ys3irkmPNC76vTpabXKT7ezATZxL66PPa17C5S1kvrTa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203929; c=relaxed/simple;
	bh=QwAdMhL8bO1G2U9I1Rega5MZDWfAfpt18HObz/QLsqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC5N+8tNTFiyKoFgC4DLUAanA3qdnTVQFy3oQ8IOID0OdkQQo/KyW0h/LKsyVWt3fczrvXJ4ZaPCvY9NlsjzL1HcHQloWnj8dbkS/6UJy1tOUEPwVdZUdCu6OVLc6KPRuXfeu3Wkw7KxQuc/jew9CiY2jEXJAD5jOAljNvupBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhvdKjsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhvdKjsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A31F000FF;
	Sat, 12 Sep 2026 09:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203928;
	bh=tyVvx+J4c9HQ4YdgxKXrKps/5qQgB9sQ9UAi1MCwTAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhvdKjsvHuf3rRTBiZKbSLFFjkdUcWbeOxVQn2wFJ+7foAFceJYzqQJwWkNJwMitW
	 iX5xUK10HZ4+1BCimm0x3oTIwvs4DQIX3/OEO4bomFweTYzyEIy/LyubHzKkNuHTTd
	 n2pMbi90wvX/jEV8AOHvBPNqAMrBSdkSa4F4mnPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1506/1815] ksmbd: do not advertise unimplemented CA support
Date: Sat, 12 Sep 2026 08:54:16 +0200
Message-ID: <20260912065724.351743973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit eebdd3f1157e35a50df5ff2d3d9a305901df3254 ]

ksmbd durable handles are currently in-memory state. There is no persistent
open recovery, cluster ownership epoch, fencing, or failover implementation
behind the continuous-availability share flag.

Do not advertise SMB2 persistent-handle or continuous-availability
capabilities until those guarantees exist. A client requesting DH2Q then
falls back to the existing durable V2 behavior rather than being promised a
persistent handle that cannot survive a server failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 06c7b1d731bc ("ksmbd: free preauth sessions on connection teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2ops.c |  9 +++++----
 fs/smb/server/smb2pdu.c | 11 +++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index c9a32ee096b58..9eb7e17379763 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -266,8 +266,10 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
-		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+	/*
+	 * Durable handles are in-memory only.  Do not advertise persistent
+	 * handles until CA recovery and fencing are implemented.
+	 */
 }
 
 /**
@@ -290,8 +292,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
-		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+	/* See init_smb3_02_server(): persistent handles require CA recovery. */
 
 	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ebb832e47b49f..c85879607d1cc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2324,12 +2324,11 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		goto out_err1;
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE && share &&
-	    test_share_config_flag(share,
-				   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
-		rsp->Capabilities = SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY;
-	else
-		rsp->Capabilities = 0;
+	/*
+	 * A configured CA share is not continuously available until persistent
+	 * open recovery, ownership fencing, and failover are implemented.
+	 */
+	rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-- 
2.53.0



