Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2F3559D9;
	Wed,  3 Dec 2025 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779732; cv=none; b=JuuqdJPtDVJ3s2WfqSTtTZidimv78CBXOquvZStLHmE8bJWGkFgcIcywOJaD6il8s1qKFmtNsAzS2iVjUZqLaWo2c+sYvHDyaeVhMqHPuNPpsTziYv9yfmZ+TG8xGtFIq1SUCDgOLUdebpfvzUTvMfxrk8vEEge09EklIjm/LQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779732; c=relaxed/simple;
	bh=MkAJkwrYFu6k7xETgwdVe/uGoZU62egl0VMIanBoxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub633xpUB0SCypMJARNLC4g9rrdxLdsvDVmGRMeDrFInFeRjToEt0vSid3wqNnMiqFYLUUbFw0tGIiwfcvopuCzk1kNvkvTibYStoaBbGBw/D6oOApp3OAeDDcNEHeAAzSXlP2slcq8G3IaQhRpeKQGMLeZgcpdGMN8aub4jbco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFq34tY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFq34tY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387DC4CEF5;
	Wed,  3 Dec 2025 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779732;
	bh=MkAJkwrYFu6k7xETgwdVe/uGoZU62egl0VMIanBoxNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFq34tY21306u9sn9Gt7MwKKAZ4xu84D0JWptEd71bj3R54onb3Afnv87gauDyOQo
	 MktBTpU9WspB8fmddgFq7M6qy9MhGvoH16+hrnOzFlOYSbueK7arKpwmJdjC/+aPhw
	 T+OJ1swzrpThlzCdVf2L9sRbC7umcZ00dnOl2gK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 344/568] smb/server: fix possible memory leak in smb2_read()
Date: Wed,  3 Dec 2025 16:25:46 +0100
Message-ID: <20251203152453.304303526@linuxfoundation.org>
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

[ Upstream commit 6fced056d2cc8d01b326e6fcfabaacb9850b71a4 ]

Memory leak occurs when ksmbd_vfs_read() fails.
Fix this by adding the missing kvfree().

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
index d2dca5d2f17cb..173135f6f7dbf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6405,6 +6405,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.51.0



