Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A747374A17;
	Wed, 30 Sep 2026 18:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791614; cv=none; b=YNYyZ1y/2v4pTHdaJTNtqqMvz1XkDzc/F+Hnb1Yj+O2OxUjgbB6RjfXaAYanJJCmP43hltts1FlGXwyveOOKPYcfsbKmh9Xu+Ph0GA8PJ+KE6bghVEU2ENwpYSwgY3CE4cBjXCdbP2dCiWBiq0swlVUNPQDyUAJDJ0pCiTkacVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791614; c=relaxed/simple;
	bh=8ThXHy/B4yh9D/bx0qRSwkcQxw6+7m5n+pc8+MRVXPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/b8Woghl86pKoX4rTzE0nlLxuSp8vYwLiMdthaCLftH7LLQjVJ/MElMNb0BG4H9JHeJTqLA+/3WjIQX4T2FghiyT+rSF1kuEaxS501cDCczLjUf0xcrEgWtk4r8Kly754PF07MpeOI+iY8JXdj2tTucy+TjAhgIS0ra1BxtLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrB37st6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrB37st6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDBE1F000FF;
	Wed, 30 Sep 2026 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791613;
	bh=XHDjNG1VWZtIg2fzZ/wRobU/M0OBqv66FF7aTmVO8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrB37st6CcjNDQevAGOuBlXO2khmjfk15NeeqtCpzORcdsmjhxZUi1Kdvsqq4RsTp
	 cdRpa4f+50fuYMUq3cVs4T+5lzoamdoRTlh+SfSLv4mk8ol/oyA4CZ8Q1eLtXK8DXH
	 FQ1Um9TV95RekD9mTdvNA3x4wfzZUNPDyXIJqbFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 362/752] ksmbd: prevent out-of-bounds reads in share config responses
Date: Wed, 30 Sep 2026 17:23:52 +0200
Message-ID: <20260930152406.114960152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/mgmt/share_config.c | 38 ++++++++++++++++++++++++++----------
 fs/ksmbd/transport_ipc.c     | 24 +++++++++++++++++------
 2 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index e0a6b758094fc..5e9959361239f 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -87,9 +87,9 @@ static struct ksmbd_share_config *__share_lookup(const char *name)
 
 static int parse_veto_list(struct ksmbd_share_config *share,
 			   char *veto_list,
-			   int veto_list_sz)
+			   size_t veto_list_sz)
 {
-	int sz = 0;
+	size_t sz;
 
 	if (!veto_list_sz)
 		return 0;
@@ -97,7 +97,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 	while (veto_list_sz > 0) {
 		struct ksmbd_veto_pattern *p;
 
-		sz = strlen(veto_list);
+		sz = strnlen(veto_list, veto_list_sz);
 		if (!sz)
 			break;
 
@@ -105,7 +105,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 		if (!p)
 			return -ENOMEM;
 
-		p->pattern = kstrdup(veto_list, GFP_KERNEL);
+		p->pattern = kstrndup(veto_list, sz, GFP_KERNEL);
 		if (!p->pattern) {
 			kfree(p);
 			return -ENOMEM;
@@ -113,6 +113,9 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 
 		list_add(&p->list, &share->veto_list);
 
+		if (sz == veto_list_sz)
+			break;
+
 		veto_list += sz + 1;
 		veto_list_sz -= (sz + 1);
 	}
@@ -158,13 +161,27 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
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
@@ -177,7 +194,8 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 		share->force_directory_mode = resp->force_directory_mode;
 		share->force_uid = resp->force_uid;
 		share->force_gid = resp->force_gid;
-		ret = parse_veto_list(share,
+		if (!ret)
+			ret = parse_veto_list(share,
 				      KSMBD_SHARE_CONFIG_VETO_LIST(resp),
 				      resp->veto_list_sz);
 		if (!ret && share->path) {
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 7e6003c6cd9bf..9d7b21257bcad 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -475,13 +475,25 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
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



