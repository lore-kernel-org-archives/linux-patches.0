Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E092D063E;
	Mon, 29 Dec 2025 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025452; cv=none; b=AQZcmTo5/SZIKD4YKGIpouCFcSYtYV7LvHH8VocbRXYp03Xajk8ma1L3rTxB7bApTK76GjPBYuo4+KmwsvkUhgJZOmkkqV0OrAw52V3mVRfibm3TE7iD4TB4w3tyDIhkM+HG0tBA2YYn0nqssJnxed/S1XYP2i1Z8ooi1SSKWRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025452; c=relaxed/simple;
	bh=q0xCDLt7JLjwDQDn3PGNNAL7Heih4lAxX1DT+c3u38E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3Ht7x4XW8HIOXnq/S0ovGpVH8G8V0AjUkxHgJK5li2ykPJ1CnmyVeC+zS3h7uWJcvbGFgfzJpkH+IdrmKHNOVoORwqlqXonMlJt4sgvJ46DLp/hoziN40w/P2xdwkuKgKoN1UifiC8xC6qDkfl83eS1DFVeEqpO7SLCf7N3A1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdC0ODzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdC0ODzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EEEC4CEF7;
	Mon, 29 Dec 2025 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025451;
	bh=q0xCDLt7JLjwDQDn3PGNNAL7Heih4lAxX1DT+c3u38E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdC0ODzH2gV4+aLj56oTQPtjf4Arxdu6omLekRUbHByXLc7h6/5XYFKfDpeJ4m2X2
	 cqegocEx1wOQSOoRZH6dtKeChHdR87vSrYdHtIfFM/qNYTl+PUlk8O1PlqUv9pPV1F
	 MNlOsOuXpBoGrGmGv3NMt9G16Fz/6FOTbhls6h10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/430] cifs: Fix memory and information leak in smb3_reconfigure()
Date: Mon, 29 Dec 2025 17:10:21 +0100
Message-ID: <20251229160732.411671506@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit cb6d5aa9c0f10074f1ad056c3e2278ad2cc7ec8d ]

In smb3_reconfigure(), if smb3_sync_session_ctx_passwords() fails, the
function returns immediately without freeing and erasing the newly
allocated new_password and new_password2. This causes both a memory leak
and a potential information leak.

Fix this by calling kfree_sensitive() on both password buffers before
returning in this error case.

Fixes: 0f0e357902957 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2a0d8b87bd8e..d8bd3cdc535d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1080,6 +1080,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		kfree_sensitive(new_password);
+		kfree_sensitive(new_password2);
 		return rc;
 	}
 
-- 
2.51.0



