Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEABCA6F;
	Sat, 12 Sep 2026 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211435; cv=none; b=nQD0CbHqG+dNOgw0X2SOc8CqWJQXxbJtBLVrBZfZDnPaMtO9FRJlT5JxdXT0S/XTr7fSI68Q508Gmtc2tXnpX58RkFyE3EmobEyJq2WLqT1KhzUjfS/DijPklosGQ2PtBlBfqqXpRgdepAwgqVpin427bD9T7OPYrL7t0W0jlmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211435; c=relaxed/simple;
	bh=UQXkujnW9Jw282x9XIAvoxNklWfVAfWIFHqnM+0XhDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaVNKJ7ZfagL9tk9QnvjpFUA/3kRATNPsEFX98GZhTMLoJEGY8t5cvp33i+4vD/+m0xxAc75a9/gkODDoiXGqrVZSP6W8nP4PtGzZWprZrArQ9GRVetJwhKc6vWuO52nozP8PS/BwghGCEkSo0UyX8U73OmtnYSZDqWv92aP6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mn9mnG29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mn9mnG29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECD81F000FF;
	Sat, 12 Sep 2026 11:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211434;
	bh=gqoVWmX0iwhK+ujV42bokFmhJnjQtixv6Wn1W8hZy0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mn9mnG29wD/yEdxHULfC5MeDLbTZFB0NcCx5XXRTLQKrQUpfPP3A6raEjcl8ZbIkU
	 EVCwnd30rB45PbxZgsXWj4LuIBs/MLugZYHDgQpIGWRcMW5y950EtwOjiqwaHFlpIP
	 8zxkRrvxpDxpMVd1K5hMiDOMXVd2pZDZ8vXvztVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1229/1518] ksmbd: do not advertise unimplemented CA support
Date: Sat, 12 Sep 2026 08:56:38 +0200
Message-ID: <20260912065651.307379718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bcf05caa2304d..9455abbfe1c0a 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -262,8 +262,10 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
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
@@ -286,8 +288,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE)
-		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_PERSISTENT_HANDLES;
+	/* See init_smb3_02_server(): persistent handles require CA recovery. */
 
 	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e532ee89e3271..696d4473b7f13 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2049,12 +2049,11 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	write_unlock(&sess->tree_conns_lock);
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



