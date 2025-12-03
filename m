Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBAC3559D4;
	Wed,  3 Dec 2025 16:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779739; cv=none; b=Lx0Mlt+0Tb8TujwM1XcKLjysyjmp8kSlFJMj+e8kPxgCFPTg+oSDY9AYJGCHQxFbPK2oD31Cu2qZGLpVjdtGFY++ihYsWOYcVah0f/I+DoNaobsIzUumB8Ov2pBGqflPURECeT+HzU/r6uWW8Ljo4y0MCposfvsTAKWSnazQ5U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779739; c=relaxed/simple;
	bh=IWkp5zhPGdyFt4pA06q/yjVSGTYwFQiqlOweqmPX96U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcMeSqAU3w3o5P9dr2BFEuUTRGmOWpvAlXVOGHNJjt00M4hgcNS7Bd4N0V8sDtp2yEbc19/rmBmuOW7GAr+QgnZlHPU3W0vOYACsLi4f7gPG9ua4LrZFd730f7R+Ewb2YIvw5XdNALAhKWOdj98bmczKUbDAXerDt6jgpLYSQM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PprgLXGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PprgLXGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD91C4CEF5;
	Wed,  3 Dec 2025 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779739;
	bh=IWkp5zhPGdyFt4pA06q/yjVSGTYwFQiqlOweqmPX96U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PprgLXGq78Ka9Shb1NI0hJIAjgnppjTgSQXkjc7fGqZElF5YDCTRLpM0ibq9pgiH1
	 DjsNCA52rcdqYuFJc+NFC07prbzMApK9Obx2yDO9+zjabiof32X5z2Tp28b0gE4qAZ
	 XNzmXZH1JUOyZB6gHn+mi7E7bC91ALL4XVsHltwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/568] smb/server: fix possible refcount leak in smb2_sess_setup()
Date: Wed,  3 Dec 2025 16:25:47 +0100
Message-ID: <20251203152453.340364925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 173135f6f7dbf..e3ea06aab8c1b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1796,6 +1796,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 		if (ksmbd_conn_need_reconnect(conn)) {
 			rc = -EFAULT;
+			ksmbd_user_session_put(sess);
 			sess = NULL;
 			goto out_err;
 		}
-- 
2.51.0



