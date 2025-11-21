Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A558C350D79;
	Fri, 21 Nov 2025 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733311; cv=none; b=M9lVLQqFYcipJ889Ql74TbVvZNtTNk5dEcM3mO+EthhSO9jgzeCLHT+/6Nrow+Ax+Ytln+Tz/PXNJ0Fs1jaBdKlWinaImcaroqo02ABMvlI0RVfvD39zTlr7tym0MLc/Nmv6ORBv0YDG6jm3bgvaxc2T1kDKPNONdcTXReNpsNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733311; c=relaxed/simple;
	bh=9He8KDO5cVVeSvcQiUoZ0uQdljDw5yePQDGHZ2nVp5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHJT14FPR5vMURGa0YMPLnJPFNNHllwW/0EZ+4rKcmaiKu4Bmao/hs+nRELdaml6EoX1fRSGdB8wjEPsO+CWOzXRugFCmky4j7vsTbZPzlKxWpe36XW81i+xajbAxV/C0yPBBvn33E0Wx0Ko+ZOKwxW2w5/ufqCaQh51pWyTiGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou/2n5sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou/2n5sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A453C4CEF1;
	Fri, 21 Nov 2025 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733309;
	bh=9He8KDO5cVVeSvcQiUoZ0uQdljDw5yePQDGHZ2nVp5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou/2n5smnIF7ZmyVKGnJH/PJ0vgJjnYLTGFuT3U+UlTs5XOl6mCSYkWAIeMgC5eDT
	 vSbYOrx4VzuhXQSvkCwdka/XM4syltEw7MsjnfiUwrCO/Gse9clcihLFtOvcBFbbaD
	 9AovLK3bkiowsfucqL+VgHxp3C2nyLw/LBDpWLoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 391/529] smb/server: fix possible memory leak in smb2_read()
Date: Fri, 21 Nov 2025 14:11:30 +0100
Message-ID: <20251121130244.935160494@linuxfoundation.org>
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
index 9a58c5a6f9866..b3fa983a522fb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6772,6 +6772,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.51.0



