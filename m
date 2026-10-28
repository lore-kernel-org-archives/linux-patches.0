Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214368;
	b=WZCQ5qr5e0giJxBLAQnFDpTLv7crHqck+zgC8cwNyUzESzErd4YcHDG6H+fxmBwHNp+G
	 EHMPkEEBuadtHbo8Fo/Tf/uJBz44K6eetxd5Jh0YCO9cXp3I6g2jTw6PC4++P4EM2uNdU
	 hFaTkjjj7fIUyiqRdzeYayxVvhhsSYdz/2qnxbcd7/EKgAgnrzxMsEhWzEJUzyMWORlwQ
	 Zf4B9vv0j2Y7f3fX8kbDmXrCMJr2zadSM5QvemRDFaUMX/+n6elqM7anFRIpnxCo0sk95
	 megSl76H24b1HOmyV2XYwfS9FpNUowqruaLNeyAxS78tXuJXWaBPp+MRq/oB03qeo3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KWDd3glB8N26VyySUuZ4nzARE7bAE64fHSF4j2t4dZI=;
	b=4zpPllgbdnMneqobJo+8vHdNOzab5JeK28iffA7FNWU6N1JpKgQEErhfwQQ9IGKfnFTN
	 +uY9Y/NqIw1dLEu/0jd6ENsHDikGoxp52Oc83yOeUwr7Y8MDAmKIyhs2SdkKnavcXQFC8
	 Y2Ci388eHq5zf+Y0Dwqjyzu/9lmSOeI/Xi//aZ8rxDTGwrni/UX5OxkKpkQ67mK2PZokJ
	 GQh1Bz6okEw6HZNm9Vy6S06tt8PwWAQX9JW9KzeN2f0I51TosSvyQjgd9/ZjHf/QmSBMd
	 0ds6u3dTNEb7PO1UZJhMOl6nsvrbr3jUvrAWqQb9PrNdHaM8eF70zmkfknKDnQVSZSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aJooxJy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923AB60A3816;
	Wed, 28 Oct 2026 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aJooxJy/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13CC1F01829;
	Wed, 28 Oct 2026 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214368;
	bh=KWDd3glB8N26VyySUuZ4nzARE7bAE64fHSF4j2t4dZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJooxJy/oq1IKYVOUQVYq4hzo7e4Sts+QI4R4Ws0RXazPM0puQxQuklxyfrRspBbZ
	 zSs4PEvarC/V90YDlEB/R5l6SBvMEtje0iLfCZenvCc3OkVOpUJIulyt6NzJpfq2al
	 5kOJGbroaqeWx+2ffOi3MTRUeoaAELql1MKOWZPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Xu <ziyan@securitygossip.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0834/1887] ksmbd: fix refcount leak causing resource not released
Date: Wed, 28 Oct 2026 17:48:50 +0100
Message-ID: <20261028170518.405183269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyan Xu <ziyan@securitygossip.com>

[ Upstream commit 89bb430f621124af39bb31763c4a8b504c9651e2 ]

When ksmbd_conn_releasing(opinfo->conn) returns true,the refcount was not
decremented properly, causing a refcount leak that prevents the count from
reaching zero and the memory from being released.

Cc: stable@vger.kernel.org
Signed-off-by: Ziyan Xu <ziyan@securitygossip.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 58f351be5d905..a81c56b3fe965 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1142,6 +1142,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			atomic_inc(&opinfo->conn->r_count);
 			if (ksmbd_conn_releasing(opinfo->conn)) {
 				atomic_dec(&opinfo->conn->r_count);
+				opinfo_put(opinfo);
 				continue;
 			}
 
@@ -1184,6 +1185,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 			atomic_inc(&opinfo->conn->r_count);
 			if (ksmbd_conn_releasing(opinfo->conn)) {
 				atomic_dec(&opinfo->conn->r_count);
+				opinfo_put(opinfo);
 				continue;
 			}
 			read_unlock(&p_ci->m_lock);
@@ -1390,6 +1392,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		atomic_inc(&brk_op->conn->r_count);
 		if (ksmbd_conn_releasing(brk_op->conn)) {
 			atomic_dec(&brk_op->conn->r_count);
+			opinfo_put(brk_op);
 			continue;
 		}
 
-- 
2.53.0



