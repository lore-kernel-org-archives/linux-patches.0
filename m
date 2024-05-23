Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D52514532F;
	Thu, 23 May 2024 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470596; cv=none; b=ocuMLQE41QVHtv0yg1Qvp2ARx/J9bairxsMe7F89QF2WCWilf9ikk0YkEy0vt1JG/EFUAd0DkIvPM64ifrvdTJ/wtKZ6Vew98CAHr0BlzPGMBX3qABmHcwGATmBC09OUVPlninq5okO8KdHPYbW7en3RksF0OAQMEZMgkJhs2XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470596; c=relaxed/simple;
	bh=Vn1SfbeYpBW0pmLlt5NYoCH2eJ5+wQREZOnRu06JUnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1V7phZDwDKIx1sBFWa3ySEZKxnHTkomtPoBwTlL6dmXBeRuf/pLr1FXzY059WLLPHVOoNOIm7jAOYGsAIwRpYengI/aBvZDQDHOueVhWPwqyhnerVpp6R3Ssh9qnEmomJK1HYOlsAKLP55zG8oaRxR2syHL1LHJNeMerqwYOQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCu/QHJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCu/QHJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A0FC2BD10;
	Thu, 23 May 2024 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470596;
	bh=Vn1SfbeYpBW0pmLlt5NYoCH2eJ5+wQREZOnRu06JUnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCu/QHJ9RzJAN6YKTQugzRkWIgMNljc0vTDe0iwek5NVaDqScCBGxS0CrrgS157CZ
	 Htb9Vvfb2SnsXaOwQxWN+D2OTKEtOrY0bdq5kNJcUz0k1evg4YEUVt3+zeomByvBQZ
	 U9l53FADRTIMele5pInDRorpGcD5cGfNHJslmrmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/102] Missing field not being returned in ioctl CIFS_IOC_GET_MNT_INFO
Date: Thu, 23 May 2024 15:12:34 +0200
Message-ID: <20240523130342.815945458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 784e0e20b4c97c270b2892f677d3fad658e2c1d5 ]

The tcon_flags field was always being set to zero in the information
about the mount returned by the ioctl CIFS_IOC_GET_MNT_INFO instead
of being set to the value of the Flags field in the tree connection
structure as intended.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 204dd7c47126e..682eabdd1d6cc 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -143,6 +143,7 @@ static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
 
 	fsinf->version = 1;
 	fsinf->protocol_id = tcon->ses->server->vals->protocol_id;
+	fsinf->tcon_flags = tcon->Flags;
 	fsinf->device_characteristics =
 			le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics);
 	fsinf->device_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
-- 
2.43.0



