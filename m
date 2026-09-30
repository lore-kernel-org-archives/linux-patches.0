Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0D051B165;
	Wed, 30 Sep 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784670; cv=none; b=pAPMBIDotXRzhBTcMv/l10cTmr8XMSzg0rU1V49W8uX3nwSCT0tAE3/Rxj/2+Ti4UKM21UBmEaEdyxfYGVdbRdLEpIl94qPnAnblZVNvf2AGkys+NbPrUmvuvQGnojMCwvm+OoeuFm1OcjbE1TRmJ+4qCxmvpnNT+Dxo2n8rV34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784670; c=relaxed/simple;
	bh=CtJPmDcHSqUUN+liSR4jwmQybxvu3qAFquxJvt4pXaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7PD9FI3fespOGqAVCqsAMQVP6qS0gPVI6ndQWONLV5BpHwGgol/St9o/WQ/vcRum5R72/QBOHvAcQQ+/u4GzL5WM+qel21rMZ84Hpt2LsGVO18/yjH+Di9c8cG2qc+tlMktZ8gHc7CLO2fYXfZu2xQe4SyTkEdhH5yRL4n19UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLu5Oavh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLu5Oavh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE15A1F00893;
	Wed, 30 Sep 2026 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784666;
	bh=g8ZmHExbWpsTbAwvgV59QFZjLJPwVvDC2t0U0/VIjBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLu5OavhRTr0F6RYv9Wa+dIjhWIVfP2C0fwet2dX+y/0/nytt2sCOp7++JnYu47vH
	 k26RniuXF4H8WVap+487wA2dSh4J1B7gaTKlFDScBrYkt2vGUEs6aNNiBKPRid/7Am
	 zseatiTS8kNd6kZkQFOjssWUo+/TZDJV6BIQN5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/982] ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
Date: Wed, 30 Sep 2026 17:16:11 +0200
Message-ID: <20260930152421.845760526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 2915f7e98fe93..413071ce9633f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1520,8 +1520,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
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



