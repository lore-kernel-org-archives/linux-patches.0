Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021373;
	b=PnBsCKPGPslTUeR57pyy/L56EvGagkItvh2X4E4b7UUbS3AprWsY+xjhl8FXIgjsVMzR
	 3sJQHFB4fvrsdsOhKvr9W/NpRNer0ornAJlcDS2YPLJw7E+ualKRXrVRTbFjCuJYDUTyn
	 opw6C+TNG/8PY397nEehyevM8Nu9X2DiGq6dsZafRzWNRBeQlAcA3YYiiCbOhJ8ccPjz0
	 LtCvz+wwVSGCf71X0Oaz9PVddZ7/zhf6+OJxig2OmF1J+ebFlheT5dkqUfSS0vYcBxZLd
	 ce3SGtakkl9BdUpNaNxDsyNttDQAxtZGWZKOi92+/RVac/1yHsuTB6qjyAp8nxwfSEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaiuwk50KEEKCZpq+wihxzDS2hfONhZoUOuxhOdHIvY=;
	b=Pi041rrt9cHri1ZOpgVNaCMnNpxcZ7BdRNLnrFRf4t14coOSOdfdw7xUdiC+X5efKxWi
	 W80WMk+jOdm3JomOF4NqF0mWtj8evHjBzEWoLOpupPdoAPmSt23gUziDEDz66KpPmtv1X
	 BMlI2amj+LK5t3FcvR0Xsqflera8dGUxBOl0sGGNt1Cxx1lj3kUI2tEL2q2QnLXvufuqC
	 6FEypR3opAy84yeGP4h+MtTafXtUlsi582KAU9GFmAf6ziHJwhE+0OU37RYWWXUllCxfr
	 QUm25LVEB+euYCT9Ix7qg+GokkzAn2QQymgzijvUWr5SHMBYNgEgiNsCjyC+LvXLdhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTUGrhrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F31606A320;
	Wed, 18 Nov 2026 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTUGrhrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F5C1F000C4;
	Wed, 18 Nov 2026 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021372;
	bh=zaiuwk50KEEKCZpq+wihxzDS2hfONhZoUOuxhOdHIvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTUGrhrzE9r9/qJAd+oAekoGNt2F9+8RsxW2BogtRbkEQuMFHkH/KvySpU+vMF0PV
	 nxKOhTI4HrcWwOac9R/ki/Y1FX6HctvG/NpAL32areoeE7wseiofsOcIpuMgVkk+JO
	 ULWCUdXlyqob/B1ceQkQS0BXwgD5RkCg8IC/lXJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2285/2651] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 15:58:45 +0100
Message-ID: <20261118150407.558187076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index efc3723389c5a..9b97656d599b0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10776,9 +10776,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



