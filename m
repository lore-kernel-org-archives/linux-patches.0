Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032610;
	b=TzKscErX81rFPWYoZa89oSPfYtamCWJ7d+hPCMJ1mQJM+hDD+uiEh4g6NVBZhvaBj6WW
	 3MF4unbl9Th6IJpNBG+y+rcENHs2a21GOnwGXv9MLAQF/K8IvRGB9SskqElYzD9EfJgHD
	 0re1Cnzw2O+Fmkj3SXBTPXmmFJdCeUx6d7GEkTARJp6zHqBHUsUu4tgYTjAesS7PBikp9
	 fcV1CHQeL3ZbXDc3y89EbbX+2GB0390uNlCITujA9+U3Q+U4P24bVPvzLm+7pvt/mBHo4
	 Srq/zbt1o/LwJnsMl1NHCgoFqUfP5YUhw7gjP+XqVvJ7b0XgQ922xQPZx7WbJ3ZcmSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVEK8Ek3fa8+c2C5QXVKroJaESQUNBVJgefnDBgmP8M=;
	b=rJng3/4fDAWIqCrY3C6ioFozEn81osiOTQRsVD1mXVGCLjvtB8XJ3vlRi6eXz/Scpcpo
	 pc9Es2zM43ixdTgJ1/gdNj5+VR7Wl9Z/bd+/jH1siXU/XLRmDaDxo7sG+xReIqI4dNyw9
	 Wb/QQgomavKHGz9FqXlG8GYM6afjnZpjb0oPbjyp02MUOB/i2bLILMooOpc1Yb8n4j60k
	 qRv1cPYIvBjJg3pI1ZlZb+FQRpW01W9rllvDZqd+09VKmH75qCB0PKI/4CBKRzxq0jXO+
	 ef/G3cWWSsPeReH0TnY8EYckVO4UsAnqnKm5rpQwKJr06+IYWkaAZdc7iZmws7EGGUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqG5tSu0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D71606A320;
	Wed, 18 Nov 2026 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqG5tSu0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FA1F000C4;
	Wed, 18 Nov 2026 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032609;
	bh=zVEK8Ek3fa8+c2C5QXVKroJaESQUNBVJgefnDBgmP8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqG5tSu06y2zULJXOhGk4eKZTjJSe/3jEPnrMyS0/Q9vus328XSL9mQm1WKo0Vi8G
	 Q1pkHmchEan2DicfEyyrUccY+lTZPwNjsEMg+05Z71A9MxMnXjkpuAPO2RUo2BIH8x
	 GT4h1J3VYha0/wINal4pIrde7D1LYApb89pV3R54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1473/1756] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150107.650625983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 2c50a4a5e75db55880eca43c035649cb51fcb52a ]

fsctl_query_iface_info_ioctl() assigns nii_rsp to the next output
slot before checking whether the interface has an in_device or
inet6_dev. If either lookup returns NULL, the loop continues without
advancing nbytes, leaving nii_rsp pointing at an uncommitted slot. If
no later entry is committed, clearing nii_rsp->Next updates that slot
instead of the last returned entry, leaving the latter with a nonzero
Next offset.

Fix this by using nbytes to locate the last committed entry and clear
its Next field, but only when the response contains at least one entry.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e03a9401e276d..ff202ff161497 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8298,9 +8298,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	}
 	rtnl_unlock();
 
-	/* zero if this is last one */
-	if (nii_rsp)
+	/*
+	 * nii_rsp may point to an entry not included in nbytes if the IPv4
+	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
+	 */
+	if (nbytes > 0) {
+		nii_rsp = (struct network_interface_info_ioctl_rsp *)
+			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
 		nii_rsp->Next = 0;
+	}
 
 	rsp->PersistentFileId = SMB2_NO_FID;
 	rsp->VolatileFileId = SMB2_NO_FID;
-- 
2.53.0



