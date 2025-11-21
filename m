Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66322190477;
	Fri, 21 Nov 2025 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731627; cv=none; b=V5f+U1vy7dY4zlfQlHudDgSXsP/ct7s9YXty2BTW+GOROzrRLS2rdY3tv2eWji7tqzljuiJ/PAuIQ3igB7TAW46oVrTHe5clac1hOg4I6gJpNDXp5rzaDtASUpNAMFznmN1+z1b0xCXmUgUt/zAQ0ak90ENBXCtgDTFWjZXU2T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731627; c=relaxed/simple;
	bh=cw9AIxmfxGfGwfelptD17+M+KzMnC15M6X7Al6xIpmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHnTxHv0N2FVfaEZapN3HXI8ea8bKmsT+wAengFITAzzlSRA/wZrWcEL60ZqvqomFrZAxh0x1mcfFOvkllQ9F7Z+LR4nD1RW+9UX/tNZdn5cdAJeVSmj/V53jDKmxxYGshBaSt5EqBcJ0myazeDRLqzEyAZJV1KYyShaQWMIxqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/geXlIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/geXlIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D8AC4CEF1;
	Fri, 21 Nov 2025 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731626;
	bh=cw9AIxmfxGfGwfelptD17+M+KzMnC15M6X7Al6xIpmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/geXlIAsV00n1FaoBn4ryMEoqbFp4Nt7UxEY1BVy5KfxNNbOtgsDVuegS+ZfDZPH
	 w1PVUh0QrjuUGS6jh65+PRE2MiTMf7dxAhDe57xVfsX7lI8BdUJtMfKKsbDaiTooS8
	 ROeCGEE1jJ0kmSoEBBswEua9tVlBs2GMX7AeCkdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/185] smb/server: fix possible memory leak in smb2_read()
Date: Fri, 21 Nov 2025 14:10:53 +0100
Message-ID: <20251121130144.818232628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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
index 796235cb95677..67021dc6dfd81 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6782,6 +6782,7 @@ int smb2_read(struct ksmbd_work *work)
 
 	nbytes = ksmbd_vfs_read(work, fp, length, &offset, aux_payload_buf);
 	if (nbytes < 0) {
+		kvfree(aux_payload_buf);
 		err = nbytes;
 		goto out;
 	}
-- 
2.51.0



