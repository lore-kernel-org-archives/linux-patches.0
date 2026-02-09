Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD72690EC;
	Mon,  9 Feb 2026 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648521; cv=none; b=qXrWCbgPui06P1IdYWywA6cI8e6PPGMppcOMKlfSG2htoRkOqx1yHK+sVk3HRIEYpHOhs4D18Z9VT1nA57WJTwB2s4w5Ai1n1dyVTRFm1B3e6Xj7lylPd8PB62lUITk1fmBFpd1NnCK3m+Dg8BahxXO2bRjPleVXEAp115MITXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648521; c=relaxed/simple;
	bh=fZtOdK9xdb4ONPaEscBK4zVtzTCHyBJkaRIvr1Uudx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVRApGg6Igv+4fnhB5Iq3G+btSSliYWSJ5iac8AAZj6U5XU8LhEVtz9Cv2rJAv+tQCHE4A5lLcbH4RJNioDPigmR+0AlGjfhxvtj9XGWoPNpczAx7uAARQPuTwz3aNq2ED9I7f3KKAXs03FzEVgZY3IKZLTeIJ+ZXYlF2DEVk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnbzWgFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnbzWgFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8818CC116C6;
	Mon,  9 Feb 2026 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648521;
	bh=fZtOdK9xdb4ONPaEscBK4zVtzTCHyBJkaRIvr1Uudx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnbzWgFKyUXRnbhUuFlixPurndn+tpW5pLUVfhCe0R8J1Bbk7LYhz1WCQcyNW67Ot
	 EcLjFJw54eIWtOosFjeM8CKtdu0pcBEiYBi2hyM2E2vawnFmyvouqFMk4Y2bvCDVwD
	 yIbW7vUDWSx4vgRg+zN5DNbNOmi66DiXh7cCpBEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/86] smb/server: fix refcount leak in smb2_open()
Date: Mon,  9 Feb 2026 15:23:51 +0100
Message-ID: <20260209142305.797755253@linuxfoundation.org>
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

[ Upstream commit f416c556997aa56ec4384c6b6efd6a0e6ac70aa7 ]

When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
must be released.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 19436ce8a4958..5cbe84938a729 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2999,10 +2999,10 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
+			ksmbd_put_durable_fd(fp);
 			if (rc)
 				goto err_out2;
 
-			ksmbd_put_durable_fd(fp);
 			goto reconnected_fp;
 		}
 	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
-- 
2.51.0



