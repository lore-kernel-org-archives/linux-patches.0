Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B63A6B7F;
	Wed, 30 Sep 2026 18:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794624; cv=none; b=PoE/C6RhTqU89thXWbZr/H5cBKN5y3yCBqru0xz6fArvXz9MfGTrHu2kOkjwDKUwSDs31QC0huTx7IB/Dj1fMbYPgkIJceHfMR94O1x7AQmyQJCvBuBepzZdMVTIl5FyseCVWqFUdMUc+N7nrHdEupc8JnuiQhPF8YcWHxQdIjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794624; c=relaxed/simple;
	bh=q7SgLEnRvLqDSnLWbXR0bHHr5OHSliNNDlI1uMY+WDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Faf80z35P2HDrkCazOU3VElCM2oWVFrvEHTG315E3FPbUJsf5AxXh02uvNND7uz0aUYxKRzAQON7Uy5Wewdn9sizj5Z1BhlImqEBqoSlrp+uNNToDRUtiCVTk/toO3vm0j0YuJbRaeuIM+yJujMK1b4XAAG0bJRoFfZl+ug6KbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmSSTvRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmSSTvRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24FF1F000FF;
	Wed, 30 Sep 2026 18:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794623;
	bh=pzd9oEQMrP5JoUJrxoFzgZFPzlM8NZ7sTMXLAszFJrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmSSTvRFkUbvkyfKhtE1gM4as/e1qXiHp0OpQtJ3GoGyRFDL6BiGXFsDzF/7YsQd5
	 LY5OcI9Nml9V2qiG+DnEurHIX5SUTQLGmMrtcdWXTMvPpR5RA9Tm/WeH18Ud/Kk/WG
	 V+erOiM9oeX1Tuco6AuUO0N1Lww06dYTryhVZoBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0274/1193] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Wed, 30 Sep 2026 17:15:58 +0200
Message-ID: <20260930152440.252630292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 775c53e48adec..bdd33c5554292 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1544,8 +1544,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
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



