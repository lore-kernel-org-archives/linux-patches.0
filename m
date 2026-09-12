Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720D11F419A;
	Sat, 12 Sep 2026 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218533; cv=none; b=SUzlhojfCM7/da4Sd4yp/xQLCZJSwNeNxufQS0BaTMKa5GNU0FVAKzb63Ly7GA8m6sjgcQ5gmOxTHqfe2/8dXQTfu2mkyt79p/fc6lJbMnZerwl1mXdTQUpdKEAKTpxAQMu9dar3GiprpglzRYHG0QFHXd5v3SplWpEnc16HSzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218533; c=relaxed/simple;
	bh=7Z6w3/KQZpPTNIE1fF0eZBnNLasebBDtnZ+QTxwKhGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1eHKYbWFxEzjdTy52PFDFFEvV+TlNIJraV6ofczUa5C9XS5I73YSr0wWwCyzaX4+dhmVKOYeTHzjld+S6FHzKWba/jQvesmMwKrnzVd0bLwslOVf17qEd1wFfjnn9NwCHiQkk9l0wS7QFHqqkw4q+//CSK0nSZZ6kwdavsF57I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGTWKJ8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGTWKJ8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F981F000FF;
	Sat, 12 Sep 2026 13:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218532;
	bh=K5Jhv3K+VNedU8olOenqo/xS/tkZCIRPeC9BXJQYmx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGTWKJ8CsihG3AjDP8RDrdDgoixK98S8fmgOBo1tcRoFIFGf9VCWphRRkYXQ0962U
	 YjFznwsAouax3crpytRA9Ut0oq6Km+QoTGRkQB3fzQ9YjIpyAIYKXyAMFFIF6L18ik
	 +BmbWUyZYES1IIGVVFxfiF8vXa2nULC1TL5VfeFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1165/1376] ksmbd: do not advertise unimplemented CA support
Date: Sat, 12 Sep 2026 08:59:51 +0200
Message-ID: <20260912065633.516755166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e4473ddba022..52df4cafe8a84 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2056,12 +2056,11 @@ int smb2_tree_connect(struct ksmbd_work *work)
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



