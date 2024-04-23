Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5F3143C5F;
	Tue, 23 Apr 2024 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908767; cv=none; b=MFVzrD5tPJNY50lFjcz7WZ9HdsJxlALGrpKuodHAk7c2I2KefdrCSWtiTR9uSllRpFChE4W7BC6HOJEcM1iqDmtVRUMXJc6/l+9f4wJpWKp+WZEpZ1F8FqnY8TV/ugy+7550Zm4rIx+vODFGwvM+8KJuGJRU7Iyf7ZEaRNrN1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908767; c=relaxed/simple;
	bh=zAd6y5hG91CFlKTUVnvAZutJZiX2mxpD0VG800EbyzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nnb5aD/gNvHHkme19CZAlbjYBAUZx6BAqwD0JbVOzRFEsiurBhVywsrBaPVnJ208FMDGBOKO2MDsLZSCOQyhVlIjkaf/vuL7XzYk58vv8D7xBrAwVZU7g+iGfjWa1c9+Sfjv8t5bqqDP0TFWjq4moQ0twwxlupkxqekSlu1lCsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTDcCWnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTDcCWnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E23C116B1;
	Tue, 23 Apr 2024 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908767;
	bh=zAd6y5hG91CFlKTUVnvAZutJZiX2mxpD0VG800EbyzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTDcCWnBD7qGMpLYmLON2i2MKStnzbZ+LFhNUrUIojEmAMuev1KVps1xxR8wFJOZ1
	 656GbMiCjiypW71zaQVgLsMUSHGpB/v7zu5Rhy3Zwnm8r2No6+nHlIU9+K4xu46vBI
	 pgSZQ0l4PH6dFrKDD9ZtUiB9CpnaiLkjhsY4JBn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/71] ksmbd: dont send oplock break if rename fails
Date: Tue, 23 Apr 2024 14:39:14 -0700
Message-ID: <20240423213844.170765993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit c1832f67035dc04fb89e6b591b64e4d515843cda ]

Don't send oplock break if rename fails. This patch fix
smb2.oplock.batch20 test.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 14cd86a14012f..86b1fb43104e9 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5581,8 +5581,9 @@ static int smb2_rename(struct ksmbd_work *work,
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
-	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
+	if (!rc)
+		smb_break_all_levII_oplock(work, fp, 0);
 out:
 	kfree(new_name);
 	return rc;
-- 
2.43.0



