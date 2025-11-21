Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B48350A2A;
	Fri, 21 Nov 2025 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733314; cv=none; b=T4bHVWgqgpg6SuRVOytq+wGfh97AK9p/DnOxWNhnynpxMpipN+XhgV2XUmgEuqHFCIrSrCJa1Xq7RaCSHg/MD8UuQGfBhLHnjNV0MiiiJ0pNtL7GMtUEQsEvJ7/SSsR3r/feEV33S4TQ2stWHXoFLr2Qto/yNGstlV8HrIFg5OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733314; c=relaxed/simple;
	bh=tmhOkKadNlfFx6xf8M/7wVM8e2lVe4m+6GocpCzzvV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EITOp7Cw4SiVQir3AYtUl+P/DSehdgMS+waw2ukT2GY6p1a0utJrOhr1WfrYahNpVYfr9J8H4WjNZaf8tfwo+Ot9Ag7F6ClpPbnCGBmqrHOymJq52P2LjBM/bYL6mLzHjsc7YsKv3irJqOibbt8chR7UniVwTo9gbLsMDhcJFiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sp2f8X4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sp2f8X4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D84C4CEF1;
	Fri, 21 Nov 2025 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733312;
	bh=tmhOkKadNlfFx6xf8M/7wVM8e2lVe4m+6GocpCzzvV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sp2f8X4QVrLDmROFg1+PQnNSfVlcD/oithDSKQQnKtPJpsnnnZrNmCpzOEQVGRt3e
	 mBWn8S7X+nzSTRm5M2/Zh/wrJXkSjnRIeOjYxMHoCLMAdzqRC/Aa/pgyh7OJ5v8sJq
	 CbLEKkylUu8gkVaQZsRB+OjFaM+MqSP0T5tu9uok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 392/529] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Fri, 21 Nov 2025 14:11:31 +0100
Message-ID: <20251121130244.970144238@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

[ Upstream commit 379510a815cb2e64eb0a379cb62295d6ade65df0 ]

Reference count of ksmbd_session will leak when session need reconnect.
Fix this by adding the missing ksmbd_user_session_put().

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b3fa983a522fb..9f64808c7917c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1793,6 +1793,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.51.0



