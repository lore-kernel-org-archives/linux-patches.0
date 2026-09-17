Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68773AEF2D;
	Thu, 17 Sep 2026 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670973; cv=none; b=swrlL8hW0EdIHawWjRZ23hRjbOw4KB6lIxNFVRD/OHaZ1183ZDXiS0KtiHKgpdfCEbCpTHPNxL3IEwftYYhBaXxitbUU+URam34vhrzc4CuEm0y0v/FRmMHYMqfEmoVHlGOxYXX8Bm9hs9GCu/6RGnBQLoRRcwLaCB/VH/3jJBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670973; c=relaxed/simple;
	bh=8ngyHlwZbzaDMHGhC7r8kKcagzXb8xpfcpSJhxT1+J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHpQQJsWGgtxRtT68BbXyReSJAH1FoERsKgbr75G0GJ5IHkWjMed0E0oZiYDzlrJge4sm2SBoyyj3IAlz7hQgEh4+S3nP2qzYxHGEbW1KS0n1zirHP65tTzn6wAflY7N80N8CPDCM50USgttqh4pW8KL15lD3jF/C4PLkWLfXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtxubWMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtxubWMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFD61F000FF;
	Thu, 17 Sep 2026 18:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670971;
	bh=ZNuYt8EeTBjPoko84SVP82YvGtheqyjV8ldZiyiXbf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtxubWMXCFEeYyS/crg5jbEEQUwfh5Rl5KEDIiMivBzzsfsRnLhkKtX7xTnH4p/FB
	 6ln3wDJ0T2+JzaEKl818rBk1grE4iEt6AxHcKBsNvHmFy5EW5OWidXnjlmrzOPHonH
	 FmgypfH9oKC8BupVBWg+fUnpn6HJE/7tXi0y3laA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0801/1102] ksmbd: prevent out-of-bounds reads in share config responses
Date: Thu, 17 Sep 2026 16:12:24 +0100
Message-ID: <20260917151600.586550086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit f25e93768fcc5d8287e50b1ec52a42e4c276df34 ]

Validate IPC share configuration payload sizes before consuming
variable-length fields. Bound veto list parsing and account for
the separator byte when deriving the path length.

Fixes: a677ebd8ca2f ("ksmbd: validate payload size in ipc response")
Reported-by: Kanishka De Silva <kpskanna1915@gmail.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 38 +++++++++++++++++++++++--------
 fs/smb/server/transport_ipc.c     | 21 +++++++++++------
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 4a5bc3c144284..04e8c11e865e9 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -88,9 +88,9 @@ static struct ksmbd_share_config *__share_lookup(const char *name)
 
 static int parse_veto_list(struct ksmbd_share_config *share,
 			   char *veto_list,
-			   int veto_list_sz)
+			   size_t veto_list_sz)
 {
-	int sz = 0;
+	size_t sz;
 
 	if (!veto_list_sz)
 		return 0;
@@ -98,7 +98,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	while (veto_list_sz > 0) {
 		struct ksmbd_veto_pattern *p;
 
-		sz = strlen(veto_list);
+		sz = strnlen(veto_list, veto_list_sz);
 		if (!sz)
 			break;
 
@@ -106,7 +106,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 		if (!p)
 			return -ENOMEM;
 
-		p->pattern = kstrdup(veto_list, KSMBD_DEFAULT_GFP);
+		p->pattern = kstrndup(veto_list, sz, KSMBD_DEFAULT_GFP);
 		if (!p->pattern) {
 			kfree(p);
 			return -ENOMEM;
@@ -114,6 +114,9 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 
 		list_add(&p->list, &share->veto_list);
 
+		if (sz == veto_list_sz)
+			break;
+
 		veto_list += sz + 1;
 		veto_list_sz -= (sz + 1);
 	}
@@ -165,13 +168,27 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
-		int path_len = PATH_MAX;
+		size_t path_len;
 
-		if (resp->payload_sz)
+		if (resp->payload_sz <= resp->veto_list_sz) {
+			ret = -EINVAL;
+		} else {
 			path_len = resp->payload_sz - resp->veto_list_sz;
-
-		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
-				      KSMBD_DEFAULT_GFP);
+			if (resp->veto_list_sz)
+				path_len--;
+
+			if (!path_len) {
+				ret = -EINVAL;
+			} else {
+				share->path = kstrndup(
+					ksmbd_share_config_path(resp),
+					path_len, KSMBD_DEFAULT_GFP);
+				if (!share->path)
+					ret = -ENOMEM;
+				else
+					ret = 0;
+			}
+		}
 		if (share->path) {
 			share->path_sz = strlen(share->path);
 			while (share->path_sz > 1 &&
@@ -184,7 +201,8 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 		share->force_directory_mode = resp->force_directory_mode;
 		share->force_uid = resp->force_uid;
 		share->force_gid = resp->force_gid;
-		ret = parse_veto_list(share,
+		if (!ret)
+			ret = parse_veto_list(share,
 				      KSMBD_SHARE_CONFIG_VETO_LIST(resp),
 				      resp->veto_list_sz);
 		if (!ret && share->path) {
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index a0b9b3def3346..10847d1cda4ac 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -524,14 +524,21 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		if (entry->msg_sz < sizeof(struct ksmbd_share_config_response))
 			return -EINVAL;
 
-		if (resp->payload_sz) {
-			if (resp->payload_sz < resp->veto_list_sz)
-				return -EINVAL;
+		if (strnlen(resp->share_name, sizeof(resp->share_name)) ==
+		    sizeof(resp->share_name))
+			return -EINVAL;
 
-			if (check_add_overflow(sizeof(struct ksmbd_share_config_response),
-					       resp->payload_sz, &msg_sz))
-				return -EINVAL;
-		}
+		if (resp->veto_list_sz > resp->payload_sz)
+			return -EINVAL;
+
+		if (resp->flags != KSMBD_SHARE_FLAG_INVALID &&
+		    !(resp->flags & KSMBD_SHARE_FLAG_PIPE) &&
+		    resp->payload_sz <= resp->veto_list_sz)
+			return -EINVAL;
+
+		if (check_add_overflow(sizeof(struct ksmbd_share_config_response),
+				       resp->payload_sz, &msg_sz))
+			return -EINVAL;
 		break;
 	}
 	case KSMBD_EVENT_LOGIN_REQUEST_EXT:
-- 
2.53.0



