Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056772;
	b=eKSuxCQvHqL6yYfsxOnUKj0bAamyEO7fGcABqgBX2xXWvtiBa0TFyGOArT+RPvuBjfFq
	 bONBywaookEHLdxBIKRYXGLZ6cvr/Sbkw/1fLq4agOTfrSihPp0vEf1Sjdo9YtBmIcikY
	 XBWiA75NC9H4UQGvRZWqpR227XNc6oYLni/W84x8lVK0I5ewfvsJz9Ntif33BjdO7B7K2
	 vQDPqQV8HSaBr2QqC9OMnKmFRRlo9VvaEB235RI2UdYuRhgu5f71neeTrt574h/JIspUx
	 /8zz0fWdGffWN4zf9ENKdg+qnReJMG0Hcs4f1Udy5CnhxYm1QJ1NYHfvUNuvN1wd9bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwkK/alUuiz7+LE5OSm3l79oJ/k6PM2f0o0yN9p1aCw=;
	b=blcdLIp4GIIFKvYC82jEcQ6MYsqSUmWO4Ca9cafKySfEJulj039yzzoN+xVk7C0/3ryn
	 XIcSYfnZM3MQKRyNhM1fJQZrmBrOMTxnoa1VozmmnwFIF055PdKYKcHChFp+MmK6uBL3a
	 MThvemGHiCgdHW0EdqQ9Q/nuIhwwLdqy+GZ6UfTqBrY4G6BFJ8OqC8oMlK+AE9jeJ1Xea
	 k02IhLXjWZhlDegMkWPuwAH3aQ+UeYTnevl1K117YesHJKZk+J/681BgnXNiVHf10Vy2w
	 gNqkdNPxoIoLOy5w13AP9h0lF1j1h5185kNdXpuuYsFPBa8Dsi63gnSWenSaCbFZl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlSqPpWo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089FB606A331;
	Thu, 19 Nov 2026 02:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlSqPpWo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED921F000C4;
	Thu, 19 Nov 2026 02:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056771;
	bh=GwkK/alUuiz7+LE5OSm3l79oJ/k6PM2f0o0yN9p1aCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlSqPpWoIdo7VK41tLnwqibIOaBee3k/lkD9vrD0JxriMI1lMW4W1/Tpty4XiuixW
	 JCtOP3jLv4UY9v8yitSzJ+CS15T9uU6baFpA5pABmx1XdZKdmlCvcVXhSGHhGNbfoF
	 gn9pNmEtkxJPpu5BBj+J6MqJDUB2GGZgs6n48viw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2080/2214] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 16:02:36 +0100
Message-ID: <20261118150133.855954160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7e08e71af80e4..a3b4b09d22814 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7647,9 +7647,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



