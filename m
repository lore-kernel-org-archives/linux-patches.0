Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D581547078;
	Thu, 17 Sep 2026 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668283; cv=none; b=T+fqPvkQo6fhQTaO39RZIu+fXEPGYfqRuHxmr+sOnW/T9SolPheO3DJO2LaLQl+uXehO2OBw7/v+zrLvdsiW7/NbWtOI+bc0fSz17FVwrVEG134pTo2KW4hxdDYqv94VjkghQGIlU1atDhmNLaIuR0XQzysTrYVMKVMERqHw6mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668283; c=relaxed/simple;
	bh=jzvWhhojLyM3FoO5kIJ4VjMpNiwr58nLXPLEM6mgQ00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGpQ6Jpi/9TFACD6lMAt5+M40e4+8U3wDK2V+LhDZZpY0wzajLmRGtuG5ViyS/NZBV96hmHkU1msUENIQ8sOFV0e26WuFtUqBNqiBAhD6U73mAAjCgbT1KMBEneT1bIbay9/KiVmiX6G+/GP2RsMXvJ1U4RqH8pI76XoX3kWtnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqp4ZeVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqp4ZeVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7193C1F000FF;
	Thu, 17 Sep 2026 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668282;
	bh=YNeBGHAVBPWO7cxV68ZxtgmLFgzuvySX1ha7HFgS0Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqp4ZeVCrF+6h19eFKbP3kS2YReMxVZCd+S6wZ8+LwGLtFlgeFRSe3lGvD94fWgQD
	 V3sft61iYi5pdVmG8QTCeT302/ooSBWQkwGO1i5RqguFf0ogJPd9JyO9rQ8nfRefRq
	 IhvjEdyhglPU3HV+Wep8sLiYU+RJ641Mzw8dx3n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0374/1102] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Thu, 17 Sep 2026 16:05:17 +0100
Message-ID: <20260917151549.041762304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d4d56b00c7df88cd5751e7415bdfabc9fdbc82a7 ]

ndr_encode_v4_ntacl() allocates sd_ndr.data via kzalloc() at entry.
If any subsequent ndr_write_*() call returns error during encoding,
the allocated sd_ndr.data won't be freed and causes memory leak.

Move kfree(sd_ndr.data) into out label to ensure the buffer gets
released on all success and error return paths.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 00dd014ded5bc..6a897956ed1cd 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1566,8 +1566,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
 	if (rc < 0)
 		pr_err("Failed to store XATTR ntacl :%d\n", rc);
 
-	kfree(sd_ndr.data);
 out:
+	kfree(sd_ndr.data);
 	kfree(acl_ndr.data);
 	kfree(smb_acl);
 	kfree(def_smb_acl);
-- 
2.53.0



