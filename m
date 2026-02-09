Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52B02BDC3D;
	Mon,  9 Feb 2026 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647412; cv=none; b=ISO5GqVqaCV1OdP0WeOyEkyKLdJ+muqJPBVGYeNQOm9yp9ps3pjXLoZuFXMCAIyaU2pXQcMOsG4OtCfa2DyPvdxbJagOFJvwGNgnFecV5PRmIzBv+gGlgT8+AexhgjgSTGstjiSqXxZMWmzAmobDd8bgYSKUZpixmt7ijHYVQT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647412; c=relaxed/simple;
	bh=GEKP5LqB87WxQpASnc1tnF59Kql6xwqDnzzkz/mHjrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNvri7b2kiM/Cx4cmC6lZakrl7yihsKka38nlyYPqmwYz4ohM2HxP54V5sdlaWgowy/bf4Ru3O9NQcnGUxkvgjGAyrQAPaxAFWyjWpGDHe9MOjVMx/2hYoYICOMYFIezB7m0c/cK7/i47YrJpwoLyXoSGGakvRLLJRgzFFtFuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stgHS7Iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stgHS7Iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448ADC116C6;
	Mon,  9 Feb 2026 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647412;
	bh=GEKP5LqB87WxQpASnc1tnF59Kql6xwqDnzzkz/mHjrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stgHS7Iqku46xFVJq0M+Od+uH3gnYyufZcutXCvBH/Kl3grRS8uvzc4ZG4r8dZP+v
	 GC2mbMXEil8UuaXFryKpTvQXj0mc7jN0xubWOre02cx4gC3a6KTg9T7zK36GtVIzTa
	 LHVVhkhA+26sLkoAltzBL4+8OVL9JKt2iwcZQa2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/175] smb/server: fix refcount leak in smb2_open()
Date: Mon,  9 Feb 2026 15:22:11 +0100
Message-ID: <20260209142322.552283525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 10d58e3094423..244a5665f26df 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3019,10 +3019,10 @@ int smb2_open(struct ksmbd_work *work)
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



