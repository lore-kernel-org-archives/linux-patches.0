Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9FA4F5DEA;
	Thu, 17 Sep 2026 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664871; cv=none; b=pH3bqHVVKFr5McMTocWPqzln/QHGjeVIt4ZQoVwtQ9rgCmTAWoDtaCp5L7baHUvZmxauTTc2WLbGVD7SDMTcpCuvLJI+4pzynWnyJlJEZgfX5XU6zNXgU3Ukf0SQRIkInNiz6FK1olQi4EDwA7firpfHnNhN7uhPmEMUKZtAjL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664871; c=relaxed/simple;
	bh=VuK4e0ZPBskZLGaYOPcboIWmnS2M/9dAkbxKaazzxpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psGwMbqy1ipJHvYk0vTMo8Vludzz/x93I203QKglzgkp8ILHnsxth4YIDODQ4QRUwbxdHuQ1JsxuZGt9E2B18HiC9Yxwi04WEyBaks+msJwkJG64l6LPmTUf8cHN8c28AQp/BcuZB1DfU7A8kysBGK1mpDjTiuLgH87huM5qrmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzIfccRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzIfccRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDB11F00893;
	Thu, 17 Sep 2026 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664870;
	bh=9dh6/5zgpmK13+edrBDcotsQp6rzZclrb0IBJSqhSFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzIfccRdPGlcsQ0eSgSMBlCn0zss1qPby9N2T6fMSR9ejZvu4HfioBUCBUiL4d4ZP
	 XvkkV1qWbW9uGa/ENsAG9A/xbMZy9YC9PfZqDqet7rtRhIhVc8/Qs5cr/4hd7g94Eb
	 O9D6VVM+97gv56ebkJVAf5+F467g2/cj6+jnM8X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0478/1250] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Thu, 17 Sep 2026 16:04:33 +0100
Message-ID: <20260917151604.923224733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d4d56b00c7df88cd5751e7415bdfabc9fdbc82a7 ]

ndr_encode_v4_ntacl() allocates sd_ndr.data via kzalloc() at entry.
If any subsequent ndr_write_*() call returns error during encoding,
the allocated sd_ndr.data won't be freed and causes memory leak.

Move kfree(sd_ndr.data) into out label to ensure the buffer gets
released on all success and error return paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 969ece627b745..938f83d647c52 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1572,8 +1572,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.53.0



