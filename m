Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B86F23D2B1;
	Sat, 12 Sep 2026 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218542; cv=none; b=rXvo7HBgWJEeFpSP6RkVZt/Uym8LCa2C/FdgRr03HYWBbIUNZQSoHu0MGFF0jycHAb/Inc+GvKgycA8iWi9zMFqYSvxUFYpET2na8CdlRzlv6ymABQ1PQ9E2wOebhZU/N8+2FBPfW5BV3Myj+HfJOwMDLyyZgQ9vmP1hMkL9mps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218542; c=relaxed/simple;
	bh=IHzYMexOdTXd9dsZrgwD3DfW2JMoEmOP2NLnrPSRm1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFvWA4l73OJrFRD8c+vUADXNyRhlcJaN0YTQREL5I0HnjZQ4WtWkwtTO4AY8oxCijgS4sWHhVObrFJFwTZy7fBR2OW3Ra+ltwGeXLcnQEFejD2hbSZptMcFwqTUmpAV7PhNxL/at2eIl425CCQtw7h9cXlAmpG/lWGggUhHd1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRBJ5r8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRBJ5r8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B552F1F000FF;
	Sat, 12 Sep 2026 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218541;
	bh=TDgezDhME/i/ekWB4e4Oiu9OmADBC7VkO1UDPYP3IWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRBJ5r8LLyq9N0w+D4RnZwzgJbe5JIYfn8o6eRrCzbKV3uSBvvBIxulx67usWZZJo
	 UpH1PKAZ553dRlon/9iSKXmaWKZnjMSblT1tAMDzZ0kBUtTv2hJmAuSe2/e06pEGHk
	 3+UQTJSVFWJOkbC7q/RnBUyXcOA/5CIbyCILYvQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1167/1376] smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
Date: Sat, 12 Sep 2026 08:59:53 +0200
Message-ID: <20260912065633.561424845@linuxfoundation.org>
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
index d3d5f99bdd34e..4a5bc3c144284 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -158,6 +158,11 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	atomic_set(&share->refcount, 1);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, KSMBD_DEFAULT_GFP);
+	if (!share->name) {
+		kill_share(share);
+		share = NULL;
+		goto out;
+	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		int path_len = PATH_MAX;
@@ -199,7 +204,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
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



