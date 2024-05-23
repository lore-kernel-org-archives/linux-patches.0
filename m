Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0F13BAC3;
	Thu, 23 May 2024 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470752; cv=none; b=u6eLIX6fP7jThaVJRi/XonIsJfX2S1twYf5yx+KnmwhJpRNm+08zLmWYMdxHUTwo2gQ2w9wS9wD0CasXTGBYl3gEWFF54HsMOh7KCrFjoyFHnhJbc59rLLmJ+Epxa/tTExPXRDrH9K8F+YYkAt40C1kMdqeqMVNcQqpcQ9TAdVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470752; c=relaxed/simple;
	bh=PpfQ3UBX5/9fOze8flXhbnv8n7sDNB1+ZiutHUJE+To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVRQIbKPgT5h9caopZM2QPpfA9j8wBFhzmqCqZLG+NnQAiQ552lNpvMs3iAvNXzFqTjHe9SGZ3gO03NTJJcfeOpEbeFxLSOgNmSqxcdwTpRILUTzZaX4SIMoOQy3q3stop+gqB85lV5uMVvoSzgD2Fsu5pFhz2Oc6KxdlkJA0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obZm78ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obZm78ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5950C2BD10;
	Thu, 23 May 2024 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470752;
	bh=PpfQ3UBX5/9fOze8flXhbnv8n7sDNB1+ZiutHUJE+To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obZm78eiCRbUX5om+wfnSI1dhMlJshe0/l8ExbpbZUmgER/yhwK5qrWXaunz8znuZ
	 XmwLdi6F+g+XuXFLM0xKvNsOK/grGq30DxYEkrGISwDANuzNf22+8IvIaBam18uhEj
	 DJ+SHrMSDi0MmSqYm3wF00FCFtQq5JJex/f4F2ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/102] ksmbd: add continuous availability share parameter
Date: Thu, 23 May 2024 15:13:40 +0200
Message-ID: <20240523130345.295295379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e9d8c2f95ab8acaf3f4d4a53682a4afa3c263692 ]

If capabilities of the share is not SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY,
ksmbd should not grant a persistent handle to the client.
This patch add continuous availability share parameter to control it.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_netlink.h | 35 ++++++++++++++++++-----------------
 fs/smb/server/smb2pdu.c       | 11 +++++++++--
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 686b321c5a8bb..f4e55199938d5 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -340,23 +340,24 @@ enum KSMBD_TREE_CONN_STATUS {
 /*
  * Share config flags.
  */
-#define KSMBD_SHARE_FLAG_INVALID		(0)
-#define KSMBD_SHARE_FLAG_AVAILABLE		BIT(0)
-#define KSMBD_SHARE_FLAG_BROWSEABLE		BIT(1)
-#define KSMBD_SHARE_FLAG_WRITEABLE		BIT(2)
-#define KSMBD_SHARE_FLAG_READONLY		BIT(3)
-#define KSMBD_SHARE_FLAG_GUEST_OK		BIT(4)
-#define KSMBD_SHARE_FLAG_GUEST_ONLY		BIT(5)
-#define KSMBD_SHARE_FLAG_STORE_DOS_ATTRS	BIT(6)
-#define KSMBD_SHARE_FLAG_OPLOCKS		BIT(7)
-#define KSMBD_SHARE_FLAG_PIPE			BIT(8)
-#define KSMBD_SHARE_FLAG_HIDE_DOT_FILES		BIT(9)
-#define KSMBD_SHARE_FLAG_INHERIT_OWNER		BIT(10)
-#define KSMBD_SHARE_FLAG_STREAMS		BIT(11)
-#define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS	BIT(12)
-#define KSMBD_SHARE_FLAG_ACL_XATTR		BIT(13)
-#define KSMBD_SHARE_FLAG_UPDATE			BIT(14)
-#define KSMBD_SHARE_FLAG_CROSSMNT		BIT(15)
+#define KSMBD_SHARE_FLAG_INVALID			(0)
+#define KSMBD_SHARE_FLAG_AVAILABLE			BIT(0)
+#define KSMBD_SHARE_FLAG_BROWSEABLE			BIT(1)
+#define KSMBD_SHARE_FLAG_WRITEABLE			BIT(2)
+#define KSMBD_SHARE_FLAG_READONLY			BIT(3)
+#define KSMBD_SHARE_FLAG_GUEST_OK			BIT(4)
+#define KSMBD_SHARE_FLAG_GUEST_ONLY			BIT(5)
+#define KSMBD_SHARE_FLAG_STORE_DOS_ATTRS		BIT(6)
+#define KSMBD_SHARE_FLAG_OPLOCKS			BIT(7)
+#define KSMBD_SHARE_FLAG_PIPE				BIT(8)
+#define KSMBD_SHARE_FLAG_HIDE_DOT_FILES			BIT(9)
+#define KSMBD_SHARE_FLAG_INHERIT_OWNER			BIT(10)
+#define KSMBD_SHARE_FLAG_STREAMS			BIT(11)
+#define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS		BIT(12)
+#define KSMBD_SHARE_FLAG_ACL_XATTR			BIT(13)
+#define KSMBD_SHARE_FLAG_UPDATE				BIT(14)
+#define KSMBD_SHARE_FLAG_CROSSMNT			BIT(15)
+#define KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY	BIT(16)
 
 /*
  * Tree connect request flags.
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 75db0e63bcebd..1e536ae277618 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1988,7 +1988,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	write_unlock(&sess->tree_conns_lock);
 	rsp->StructureSize = cpu_to_le16(16);
 out_err1:
-	rsp->Capabilities = 0;
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_DURABLE_HANDLE &&
+	    test_share_config_flag(share,
+				   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
+		rsp->Capabilities = SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY;
+	else
+		rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
@@ -3502,7 +3507,9 @@ int smb2_open(struct ksmbd_work *work)
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	if (dh_info.type == DURABLE_REQ_V2 || dh_info.type == DURABLE_REQ) {
-		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent)
+		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent &&
+		    test_share_config_flag(work->tcon->share_conf,
+					   KSMBD_SHARE_FLAG_CONTINUOUS_AVAILABILITY))
 			fp->is_persistent = true;
 		else
 			fp->is_durable = true;
-- 
2.43.0



