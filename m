Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8CD3AC0C8;
	Mon, 23 Mar 2026 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275238; cv=none; b=lyZidCgxLw6OyWaIp52rKMD13Kpn4QRsLxtssdd9L2HWNRInSWbPEtP/bGU8wSrQmPMpGtx023jIRcveCI3qNbqDiMmVTVvegc1sEaPYoqgfzvgPbT7C2QfuFJh3DgoCDOJ8p0Z0HZvUGpYByLagAYA3LIMmKz1ugeJBDKbjHSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275238; c=relaxed/simple;
	bh=u1jOhMNJXJcpSaKv++ywbcTp3VRtMGSD+HLJl4r4LZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHt/dKmHk4ueYh71nIz/mQkAqH2RxhnuQtSkB/HN2tuKJNp49Tu4+RoCy96B5fymhd0mKsIxbi6451rkAPRTbMFaHGV8bLwOK7wR905p91Vy2nRrD32l8NHdfVGEde1MPJPiW/EuU2UXYsYaAhaT4kBm8axLktAxAs14cnDZ5is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISeqVZGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISeqVZGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998CFC4CEF7;
	Mon, 23 Mar 2026 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275237;
	bh=u1jOhMNJXJcpSaKv++ywbcTp3VRtMGSD+HLJl4r4LZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISeqVZGxfAcXPG0+cKj9zckjspQ/vveesiQRtCmToS1Sy8eS8dOoPcdb9lxt36AJc
	 bPVN5t+9iE4vAt6dfkxgbM4ekR/YXh06i92+HK0RxwiUR4yvHePtq2QIplkyTkXflT
	 286AsWvPA98R8OLMOcKbqVPsRtjZ6ybYVhsED+VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/460] smb/server: Fix another refcount leak in smb2_open()
Date: Mon, 23 Mar 2026 14:40:20 +0100
Message-ID: <20260323134527.285964374@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c15e7c62feb3751cbdd458555819df1d70374890 ]

If ksmbd_override_fsids() fails, we jump to err_out2. At that point, fp is
NULL because it hasn't been assigned dh_info.fp yet, so ksmbd_fd_put(work,
fp) will not be called. However, dh_info.fp was already inserted into the
session file table by ksmbd_reopen_durable_fd(), so it will leak in the
session file table until the session is closed.

Move fp = dh_info.fp; ahead of the ksmbd_override_fsids() check to fix the
problem.

Found by an experimental AI code review agent at Google.

Fixes: c8efcc786146a ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0d7ba57c1ca64..d1c2e8779ee18 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3012,13 +3012,14 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out2;
 			}
 
+			fp = dh_info.fp;
+
 			if (ksmbd_override_fsids(work)) {
 				rc = -ENOMEM;
 				ksmbd_put_durable_fd(dh_info.fp);
 				goto err_out2;
 			}
 
-			fp = dh_info.fp;
 			file_info = FILE_OPENED;
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
-- 
2.51.0



