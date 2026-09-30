Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA2A4F96CB;
	Wed, 30 Sep 2026 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785557; cv=none; b=jo99S2GYqmDwqXNgdKm+PAiX6kzoplpricAQFSXcG8pXkNJmU84wLfnzAN81z8F+V+U29R+4+7gRWmyc7iswwGkcIC3Pa6oDmXkhzCknSvrnyMhlK+fITeZF+0orMSVeASGiHSRR1MbYdV4jSaCFETS1Hyk4G9O/d4NamWzPfHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785557; c=relaxed/simple;
	bh=c1gA6nkziFH9kb1puvye//SPYh5KR10Jah9FBiOqCRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBlxFnHMG1CvPIQNyIy1o9ZkRl7OYJF9uy0FZxgSsEQF2IoYCWOejZsaA+UvtGOUAd2whv7FmzQsF/bo9XsZoxTT0ySWQTSYQ2GePBrhm2MF7ocZF14aH2FilQbIdgaKxDE56aKJFDrvLnFShO5DLVp5g7KNEuly2/QjkTJTUns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmv70vak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmv70vak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991C81F0089B;
	Wed, 30 Sep 2026 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785546;
	bh=eTDqmN3ghjRmjVGIWckKXrsuNQhMXlxB9v4Fgl/2ENs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmv70vakOV3N6P+GegHOZtoZqmn+Nl3wB6Y/yF/gBGzRtzjG7gtscdGn5moYFr9EW
	 dDty/e53H3R4sh9yV6vB8dpWcyjg+rUgyo7mtSj/avZqdmMdDOu/WywzIOPcxYuy2T
	 l4U2ZR/xlGIAc5+sT32ycYtJN/3oOE5nTwVLYIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 492/982] ksmbd: prevent out-of-bounds reads in share config responses
Date: Wed, 30 Sep 2026 17:20:28 +0200
Message-ID: <20260930152427.349121737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/transport_ipc.c     | 24 ++++++++++++++-----
 2 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index d8d03070ae44b..7db7345f1af94 100644
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
 
-		p->pattern = kstrdup(veto_list, GFP_KERNEL);
+		p->pattern = kstrndup(veto_list, sz, GFP_KERNEL);
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
@@ -160,13 +163,27 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	share->name = kstrdup(name, GFP_KERNEL);
 
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
-				      GFP_KERNEL);
+			if (resp->veto_list_sz)
+				path_len--;
+
+			if (!path_len) {
+				ret = -EINVAL;
+			} else {
+				share->path = kstrndup(
+					ksmbd_share_config_path(resp),
+					path_len, GFP_KERNEL);
+				if (!share->path)
+					ret = -ENOMEM;
+				else
+					ret = 0;
+			}
+		}
 		if (share->path) {
 			share->path_sz = strlen(share->path);
 			while (share->path_sz > 1 &&
@@ -179,7 +196,8 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
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
index ed423d0ca99d6..89fae5e1886ae 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -487,13 +487,25 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 	} else if (entry->type == KSMBD_EVENT_SHARE_CONFIG_REQUEST) {
 		struct ksmbd_share_config_response *resp = entry->response;
 
-		if (resp->payload_sz) {
-			if (resp->payload_sz < resp->veto_list_sz)
-				return -EINVAL;
+		if (entry->msg_sz < sizeof(struct ksmbd_share_config_response))
+			return -EINVAL;
+
+		if (strnlen(resp->share_name, sizeof(resp->share_name)) ==
+		    sizeof(resp->share_name))
+			return -EINVAL;
+
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
 
-			msg_sz = sizeof(struct ksmbd_share_config_response) +
-					resp->payload_sz;
-		}
 	}
 
 	return entry->msg_sz != msg_sz ? -EINVAL : 0;
-- 
2.53.0



