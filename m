Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAC423BD03;
	Sat, 12 Sep 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225690; cv=none; b=jaSUDYAkyDnGDDqJyLQn/JvPwGYL/5aOzZ0YiOwoC/mURId214yr+lQtUoWMJEKjsDO0UhrXd44UpOJJBQtGDhI1JW17d03d/aIOaGIvAZ53cuglABPGq/CISOBTPiNyN2wH1MQB38Hrf/1vBn9SFGjBTXcibn0VAmrqnJvOo+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225690; c=relaxed/simple;
	bh=fSMtNSKio41bQgZtO0B9s8l4BZN9QuiHb71uMBwCmE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAwnsCyjNNjQIKsC2KqGNWIQxsD0ZC7f1PjwNqgAwQC3GQu0P1foYzS8i+nuxrBytrxLT7O4yuBY9lAmXp4s7TFRP4i7iHsIktWctsy8kSJqde2pu/TMVJ8oyjcFx6FQQCmtumu4DB9Sxl4y5GE1Zlw4bgkZKTPdMGCUoJ2anmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lit/PA15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lit/PA15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04571F000FF;
	Sat, 12 Sep 2026 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225688;
	bh=x6bvtZKrUKL1dGSNHuji50ApVTUcY7mWegecNH+yRWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lit/PA157hrtCBya4F2IZ0dQkKup54Ag+v18vEbMqJrCmRIx4vvnp1bI4FgNChM41
	 CxMZYnxbge2s7NUUEOqAmg8kOST5AOUxoMTdoWuzVJsZgKIQUdnWOUOxxtiVTFlC/e
	 +3EAX6+q9yT9bCBfc9i+dTeo3Ot5BODqOd+uyjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1249/1424] ksmbd: do not advertise unimplemented CA support
Date: Sat, 12 Sep 2026 09:01:21 +0200
Message-ID: <20260912065635.254725569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8d04f64cb0830..dd9aadea61af7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2036,12 +2036,11 @@ int smb2_tree_connect(struct ksmbd_work *work)
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



