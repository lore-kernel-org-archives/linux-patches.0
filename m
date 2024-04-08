Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E957E59F;
	Mon,  8 Apr 2024 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583541; cv=none; b=IB4LMKa3jIewloxFAtLHU0jhzmSjk3yC9iu9/7BEDbdCpLr5HeJxAMOzFwT+5yPbkWGBmDh7FPb3lrWBgaTeFZDsHICVS4yIT7/Vr46EZewI+9/VN7Afn6eXMpd8IXFp0fE/zVM+yb1+/7zLm1BxZEefiIXriyYUwzfSf21tb3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583541; c=relaxed/simple;
	bh=RZ86TbakRrbfJLY+e66EplpRfpG8CLm1x7Dzb1mhlts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKKhzFLStQt9r5Sig4rBlvCWYFSg4HL8iGBr5CkhEU3k4FHp6cTxsULzb6ZWI3jdZFRVdoFTd6r2u0wKWQwMTdGxBaqPQKaOQqeuKaKU6yA8J4uPomVjXHqKVKcUg/g1g5La348xl+BmGDe3kgUmTGDnqveXHG9bDURe5BDtqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uR7cU0an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uR7cU0an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFF1C433C7;
	Mon,  8 Apr 2024 13:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583541;
	bh=RZ86TbakRrbfJLY+e66EplpRfpG8CLm1x7Dzb1mhlts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uR7cU0an74zyGCYRYAKaNzcLdJfj8dz6uIG0bjtYc8WjjcDmCoa5rl914ZtrP9QW3
	 gGFwgbz87m0pwxIOH5HlRbWNYnjN3LpevhcGKV5SGxR7RsIOppq1+vkPy/lnbEFNMF
	 ZDZizZLZ7KIGSzw9Xqv3pjCiT+dRWWbCzsvCSIwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Christopher Adduono <jc@adduono.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 206/252] ksmbd: do not set SMB2_GLOBAL_CAP_ENCRYPTION for SMB 3.1.1
Date: Mon,  8 Apr 2024 14:58:25 +0200
Message-ID: <20240408125313.044434788@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 5ed11af19e56f0434ce0959376d136005745a936 upstream.

SMB2_GLOBAL_CAP_ENCRYPTION flag should be used only for 3.0 and
3.0.2 dialects. This flags set cause compatibility problems with
other SMB clients.

Reported-by: James Christopher Adduono <jc@adduono.com>
Tested-by: James Christopher Adduono <jc@adduono.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2ops.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -228,6 +228,11 @@ void init_smb3_0_server(struct ksmbd_con
 	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
 
+	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
+	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
+	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
+
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 }
@@ -275,11 +280,6 @@ int init_smb3_11_server(struct ksmbd_con
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
 			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
-	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
-	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
-	     conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION))
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_ENCRYPTION;
-
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 


