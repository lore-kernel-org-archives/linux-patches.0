Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCF526E6F2;
	Tue,  6 Jan 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720780; cv=none; b=jXpv/DVAonghGDaPjJuDrGjIFbo7CsIsr+vbBTC/vbcAU/+0wn4YwNoohQoMq3DS6AupM0pvb74DCz+LoupFygmEZVCMsrfRB7PC5/0BZ7+1mKQuHXpgvdVg7RJMl+a6TCiQnyG3EsWQf4VC+C8mtlls+soyYjZhtIhNYYffKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720780; c=relaxed/simple;
	bh=lwD2Znoe65COnElf/SeQrkuC+m1He19flIGP1ar0gtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxQfdN5sIDLtLgJdmW7Jr7Amu1R4WK1VgDOzIM49pm/e5YKRFDGJ2umTZ18x0Yi5YJ/tee6MMt4y8EbxRfqT+beGDWyKsrH0VQJh60IMsG1ZrVFYcmutMywlT66z1cU5yJ/XE0LQkq6zL6fGBQa9FPOWZjCdpOsCqibkN/47jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuf9TwWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuf9TwWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D14C116C6;
	Tue,  6 Jan 2026 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720780;
	bh=lwD2Znoe65COnElf/SeQrkuC+m1He19flIGP1ar0gtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuf9TwWEKkLxRJRtVL686E1m5cV2FXZ5ea7euj12EfhiDD/pkWWkYDGGthXDNaJ18
	 YDyBTbaKJAFKtKnHfrRN0GP7vpB5GjmEU7g4nrn0+i37pMzHXAv66OJ/DQ4Uy/rtdI
	 n22IdvFgD7C3vYjWBci2lWMQDGHlm5+m8kXuKk74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/567] ksmbd: Fix memory leak in get_file_all_info()
Date: Tue,  6 Jan 2026 18:02:01 +0100
Message-ID: <20260106170503.868762474@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 0c56693b06a68476ba113db6347e7897475f9e4c ]

In get_file_all_info(), if vfs_getattr() fails, the function returns
immediately without freeing the allocated filename, leading to a memory
leak.

Fix this by freeing the filename before returning in this error case.

Fixes: 5614c8c487f6a ("ksmbd: replace generic_fillattr with vfs_getattr")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a1579f76e063..e2cde9723001 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4926,8 +4926,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 
 	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			  AT_STATX_SYNC_AS_STAT);
-	if (ret)
+	if (ret) {
+		kfree(filename);
 		return ret;
+	}
 
 	ksmbd_debug(SMB, "filename = %s\n", filename);
 	delete_pending = ksmbd_inode_pending_delete(fp);
-- 
2.51.0



