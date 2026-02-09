Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6D8285073;
	Mon,  9 Feb 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648514; cv=none; b=H2QrFA3s5AvvPJsG6PVChzYAm0mO07XGm1Y1fwrmZsbqI8oaaq19lLGbvAEiN0vz1foX25o02PLGwJsvV04Za+uZne+GSgJd1Cf0kyBFtJzDRlHIqj9FgCnJXVz9sWC7uzBUbtjRaF9RVaRUwyVN1wZ50Kj8O4hSnZspAHlFTSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648514; c=relaxed/simple;
	bh=xDIS/jnrAhkZCIo2EBukWNYGm9wqvnHUcoBgdfDJcdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qcoq2UqPGwxznyVdIR/3r1zPAw2F8H2x8bsxtKovW1m5DGEr0cvoMMIj0iN0rlmL0Ikqm4x1AE4iP2m0sRhwKoLDBnwFdXk3gmAJPpGUpQ4BTayXE8WtnMRLCeai+4u9OgZH3+jFapdVqZUt0+58l7DEq3692zLDFTi1wJD9bkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q02tnW5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q02tnW5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF659C116C6;
	Mon,  9 Feb 2026 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648514;
	bh=xDIS/jnrAhkZCIo2EBukWNYGm9wqvnHUcoBgdfDJcdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q02tnW5yXVPMGk+Otf8Z+ab1c4MjRXPm9Ev5wWX1ToxO/k3y7CgPKkFGe5xOHbmIS
	 SWqUlBNKae+hRzxcovq29oVHbZNzZOQUCo4dbXxKqA/tzwFhFZV3UGT8bnUgLQo8d+
	 1OSWDkVdi03casxNicf5sIi5ebJPNV/NtW1ZK0v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/86] smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()
Date: Mon,  9 Feb 2026 15:23:49 +0100
Message-ID: <20260209142305.727629661@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

[ Upstream commit 7c28f8eef5ac5312794d8a52918076dcd787e53b ]

When ksmbd_iov_pin_rsp() fails, we should call ksmbd_session_rpc_close().

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index eacfb241d3d49..19436ce8a4958 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2274,7 +2274,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
 	struct smb2_create_rsp *rsp;
 	struct smb2_create_req *req;
-	int id;
+	int id = -1;
 	int err;
 	char *name;
 
@@ -2331,6 +2331,9 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 		break;
 	}
 
+	if (id >= 0)
+		ksmbd_session_rpc_close(work->sess, id);
+
 	if (!IS_ERR(name))
 		kfree(name);
 
-- 
2.51.0



