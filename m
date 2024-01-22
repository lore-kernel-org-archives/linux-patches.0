Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917045FF16;
	Tue, 23 Jan 2024 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974665; cv=none; b=Hz1OCJyrtk6tCw8/Z1n9WaB2ABMtuaGCJT7puroRbYS8q+JQt+ZoRBFK5JZDwr0WVFfPIhNfy2tiijw6g6OoEw0IkRsmugfeIhnXxeUlrersBVsys0FYDfJJew9at8alVmlQGCxZIH7tRUaptlqwkgBfsZJ6eNY85/rpqrUARsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974665; c=relaxed/simple;
	bh=Cya7ry4BDZE3ghC3UL5rbgWdt9RBlXcVkAixhc3ZS9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHWUD1vfVGDQd+ufCol0CIOAgLz2yPMVEsKuTTmiAzjgiiE+53hbvjXw/dG2EvV4F+WK51OXG8n1K/iy+8XOK34ZiUUK3B4l1ls0J7qgVLLPPjYGjNeOity5N4QEXZ1Ywgf9CEeRvZxtmzpePUAz/boRqqgbO1GE0TvukhaB9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boyV0A0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boyV0A0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CF6C43394;
	Tue, 23 Jan 2024 01:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974665;
	bh=Cya7ry4BDZE3ghC3UL5rbgWdt9RBlXcVkAixhc3ZS9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boyV0A0i/6ZHv0SNkhww+Fox8rk8tW9uf1BYvzh4w07MIfPqb/LOv/hB6Bk6EFbyV
	 HZLQR9+esNYJIJgMguEmJkRcEmmXd9cJuTaqba1+9LtKzC1CJaWNzSyJYJTTI6IdAo
	 xFMV0SsOXWI2p/qRBdgeR+t3xWd3NTyjSlXfpkLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/374] ksmbd: validate the zero field of packet header
Date: Mon, 22 Jan 2024 15:58:16 -0800
Message-ID: <20240122235753.084913459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 516b3eb8c8065f7465f87608d37a7ed08298c7a5 ]

The SMB2 Protocol requires that "The first byte of the Direct TCP
transport packet header MUST be zero (0x00)"[1]. Commit 1c1bcf2d3ea0
("ksmbd: validate smb request protocol id") removed the validation of
this 1-byte zero. Add the validation back now.

[1]: [MS-SMB2] - v20230227, page 30.
https://winprotocoldoc.blob.core.windows.net/productionwindowsarchives/MS-SMB2/%5bMS-SMB2%5d-230227.pdf

Fixes: 1c1bcf2d3ea0 ("ksmbd: validate smb request protocol id")
Signed-off-by: Li Nan <linan122@huawei.com>
Acked-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index d160363c09eb..e90a1e8c1951 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -158,8 +158,12 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
  */
 bool ksmbd_smb_request(struct ksmbd_conn *conn)
 {
-	__le32 *proto = (__le32 *)smb2_get_msg(conn->request_buf);
+	__le32 *proto;
 
+	if (conn->request_buf[0] != 0)
+		return false;
+
+	proto = (__le32 *)smb2_get_msg(conn->request_buf);
 	if (*proto == SMB2_COMPRESSION_TRANSFORM_ID) {
 		pr_err_ratelimited("smb2 compression not support yet");
 		return false;
-- 
2.43.0



