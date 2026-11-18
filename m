Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042213;
	b=GKza3luxXarRoeV4szvPWtHvSYDCCRexIm2YP3z+4cDRUtlWrMpaaZDR/R3sRAB78a14
	 ecQJaIK7kXlOk0XGIlhgvCu4sia4yw1hJylAlzXeoQaST+hfgPIKhIEosGR9Wb3MZaMZW
	 3AOYj2RgvaB+8qGJhNOOUZCpsYhIL7p0YqMp9wj/UUr1lqzEQoklmBvYsLaVOEn56mbd5
	 x9mQg8/qUHC8lvViEf/Aj80UO/eIATxCiQAUiogGyYi6tesvc4Fne8UsjAlIyfGKXMple
	 c7nWSW0MCGUR32+V7+C6UIj47xXVWEOnNqKPdN020Ca0kWH97BUZM1uO2XHDn5ebf3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29A7uo1dXDFvuQ0BqJkD02AhZ1d0I8foM6UqDsLvGJg=;
	b=zEI2I7Wd2ZPMtWakgv1q8pjKMIiYjUzY4sjzcYUdc9AfQ7bDm2zyUiZZK627gIm73Aye
	 365TolwQxhm8rWIit2WgFJXRmgaWAYnRNtWFhB4ZBdsxrgv7nvYKQ4Eg6Sf+Yaf+x3dR1
	 eP1683f/ouC2zPT3E9/IZIsO9fhpto3KLgp8AVZyb5mts0V1qkIlzvqhZncrME4aWNMPI
	 fMl/Pi6XRalo3Xltf6TBM8jU91xPoxIAslxaCI8qQRsaIFPKS2cbfHaj15ZARh+Sw1aQh
	 tWWfXCm7/Y/FfdT1RGvOQ96uPprPq64sw3p70NZ+963Iv86GTRqO6j82CC4MY3zlh/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+UaIh62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B5606A325;
	Wed, 18 Nov 2026 22:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+UaIh62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4A61F000C4;
	Wed, 18 Nov 2026 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042213;
	bh=29A7uo1dXDFvuQ0BqJkD02AhZ1d0I8foM6UqDsLvGJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+UaIh62NP3NzwTvFDVgCxPKDHS5CEbyyF48f1Ox4RdkuQMdjWlrO9wdgW3YSa2z0
	 4BYE8ucXLnROKpkak+KFlYvSPnF7ipVD6RpYI9DyIXOLbSYxKQCuX7JLUCaDjORai4
	 2YwsidWmtm11LzaBDBe9W+ncJn7RhnUrnVe6u0w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3090/3318] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150452.737219522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6702e317f68b5..19ede9fffb6fe 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8278,9 +8278,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



