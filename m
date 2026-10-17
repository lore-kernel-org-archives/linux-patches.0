Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F514CF47F;
	Sat, 17 Oct 2026 18:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260005; cv=none; b=bfDVV2Tu41oQ7PZ7otDR0RBzvkZjXobkndZ233/FFlxIHgWcA284aLbSmftKJquAnaGaKWXQ6pO3H5rdQRHcHS2Vfl23kcdsOvPsrJYx9ZXd7jakFuuh7zhIMNmA0l0wKk7SI5ZCWl8IhNIAYth5OSoP+sGzW96HRsPi+dsOFIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260005; c=relaxed/simple;
	bh=fNCylGyANJSFj6RDNSRvOONLiSlDnG5tGtD8cA8fecc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMLZgJvZ2tjfD3bhNMGVJMBiuNPgMzSBipQds4u0kXVA1eO/ZAGe2q+rQq4+YQJMIpEHdB1EHh+WPyjfvOIPMSKnD/CS65QLVyVU1NYg0kKulUHZBIqb/eD40URMlmqFn3+c5blPvwn0zc7RnBic3Fvx5dGmwf30ABsLKLpXYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSieciXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSieciXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0451E1F000C5;
	Sat, 17 Oct 2026 18:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260004;
	bh=v41VDGZIE1ZqC3H9qg0wxzPd67mQ+dhkBzY0zVzqWWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSieciXXslZYN57qSWQqlQKnfVTWdj9HJJlnJ6lv1EsV/x6kvzD7EFv2dXPVVZufJ
	 +nYmGvqT/OwflGr82PmXqa8QJOb0o4h6kueJmPr2Hu+gefi9zjfRG3GM3OpVGD4FF2
	 MLKIKsfBEEafUK/qN5NQxrj7L+qCr/vlfILL6ojI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1400/1674] smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
Date: Sat, 17 Oct 2026 18:01:12 +0200
Message-ID: <20261017160507.110907814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit d2ccf905f47d2344270749f4dfa905afcd3edeb0 ]

See the procedure below:

  ksmbd_tree_conn_connect
    ksmbd_share_config_get
      share->name = kstrdup() // fail
      if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) // false
      // do not check `share->name`
    ksmbd_ipc_tree_connect_request
      strlen(share->name) // null-ptr-deref

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 7db7345f1af94..cb89e54c4da84 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -161,6 +161,11 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	atomic_set(&share->refcount, 1);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, GFP_KERNEL);
+	if (!share->name) {
+		kill_share(share);
+		share = NULL;
+		goto out;
+	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		size_t path_len;
@@ -217,7 +222,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 				share->path = NULL;
 			}
 		}
-		if (ret || !share->name) {
+		if (ret) {
 			kill_share(share);
 			share = NULL;
 			goto out;
-- 
2.53.0



