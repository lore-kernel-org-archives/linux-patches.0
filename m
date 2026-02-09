Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A3A125B2;
	Mon,  9 Feb 2026 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647805; cv=none; b=TEu2M0J+oYo+Ul7QTR9U58+u3BggO8nyZFFH+DZK8kqDFhSTKq32n0NiZiB9VnmH+Xfm5UYwSo8kP8AWE4YXsPOmcreKjk+S9Gb6P+3kzBLaeYCQI8nknFZnIu/bdzMF2iH9l/ew9wGXs1vjwRwNPonk5wFpuJtvtKlT9pUbOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647805; c=relaxed/simple;
	bh=k70GLZv3oL+l56UPAfSWcdteQ0Zpf2573IFGTiUHnGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F950Cv0rC7Y5RnEDTtMbBum9uY1YlPWAatvmp7u8T0Eay3j2BxexDaB12OQGpxHWpZjJQThl9gOChHsGktyXqQj/wyLK0RA/rMV+NgxVWlVj5iqCmIFSr4K23c9CfkV+gljjFEIrpDa1C3nPeMbYrUdLCAs6ATxfh+bhUFavwdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKNREqnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKNREqnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A635C16AAE;
	Mon,  9 Feb 2026 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647805;
	bh=k70GLZv3oL+l56UPAfSWcdteQ0Zpf2573IFGTiUHnGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKNREqnHFDUw0yPTKFfmQ3F/alNLMIV6300mXf3UHJWc+2mJvDjVPIZINZRESyS1o
	 Cyp/WG5wxewSkS5UzXr0ZxjNFQ9fi4QNW+7u9b1jRSYF7W496+b7abJgXhuyjIcbrh
	 6DYLyME7MG7XQDsC7z0O2drNzU+arUuMQdquXpTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/113] smb/server: call ksmbd_session_rpc_close() on error path in create_smb2_pipe()
Date: Mon,  9 Feb 2026 15:23:03 +0100
Message-ID: <20260209142311.433349818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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
index e2cde9723001e..a3c0754e3822b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2281,7 +2281,7 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 {
 	struct smb2_create_rsp *rsp;
 	struct smb2_create_req *req;
-	int id;
+	int id = -1;
 	int err;
 	char *name;
 
@@ -2338,6 +2338,9 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 		break;
 	}
 
+	if (id >= 0)
+		ksmbd_session_rpc_close(work->sess, id);
+
 	if (!IS_ERR(name))
 		kfree(name);
 
-- 
2.51.0



