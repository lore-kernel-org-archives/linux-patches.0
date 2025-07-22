Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76D242D8F;
	Tue, 22 Jul 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192155; cv=none; b=eRZY6WfQc90J1nycVcdenno7UY07xMtyw4gOfdC0Wi8QJdMNG7FPUndAyYn1enBRWJmKg8cVfik8+KPS60OprJ3TO2n6UMBRFNj5a2+179ZZQx6Fy3FHEJiHbilmtRKHuNHp667I+hqk4k/BH3XzqDiKlW00zpOpImYUm48mrgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192155; c=relaxed/simple;
	bh=A5LY6Nwuoc/GJ63pMHadUynIvB+njLJO9bRVmYBXBo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnP2NM/lGV9bta0bc2B4PGIEF2GjRVT9ds4ImJgfcmtwM5e7BPgmUBz+rIcNhAp//nQB7/IMaIWK6JErPe0lvpT5nXFeFvIC9LMdQ8vYD7+4DWrTaXnJrFduMPPGA9G1oUfN1MLdYKOdqUCOb6SWBPoY+pgv11U2MGGZMQ0+Njc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruey9eNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruey9eNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5E9C4CEEB;
	Tue, 22 Jul 2025 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192155;
	bh=A5LY6Nwuoc/GJ63pMHadUynIvB+njLJO9bRVmYBXBo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruey9eNHJwTVSB+//AbF4325cPQNAU/6y+Wj/qmw0ilupcEqFHaE+YSRAUOephS08
	 JO7whlnbhTMPNkqpzwbzx4I8mK/zb3MEh1jZmu+xQBhf6eCZnCInGfQLO0Brh7I9s9
	 eBbf5rAwkMqTV1XmNEiPyb/RoG1es9qaoiylK9o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/79] tls: always refresh the queue when reading sock
Date: Tue, 22 Jul 2025 15:44:57 +0200
Message-ID: <20250722134330.617793004@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4ab26bce3969f8fd925fe6f6f551e4d1a508c68b ]

After recent changes in net-next TCP compacts skbs much more
aggressively. This unearthed a bug in TLS where we may try
to operate on an old skb when checking if all skbs in the
queue have matching decrypt state and geometry.

    BUG: KASAN: slab-use-after-free in tls_strp_check_rcv+0x898/0x9a0 [tls]
    (net/tls/tls_strp.c:436 net/tls/tls_strp.c:530 net/tls/tls_strp.c:544)
    Read of size 4 at addr ffff888013085750 by task tls/13529

    CPU: 2 UID: 0 PID: 13529 Comm: tls Not tainted 6.16.0-rc5-virtme
    Call Trace:
     kasan_report+0xca/0x100
     tls_strp_check_rcv+0x898/0x9a0 [tls]
     tls_rx_rec_wait+0x2c9/0x8d0 [tls]
     tls_sw_recvmsg+0x40f/0x1aa0 [tls]
     inet_recvmsg+0x1c3/0x1f0

Always reload the queue, fast path is to have the record in the queue
when we wake, anyway (IOW the path going down "if !strp->stm.full_len").

Fixes: 0d87bbd39d7f ("tls: strp: make sure the TCP skbs do not have overlapping data")
Link: https://patch.msgid.link/20250716143850.1520292-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 44d7f1aef9f12..b7ed76c0e576e 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -512,9 +512,8 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 	if (inq < strp->stm.full_len)
 		return tls_strp_read_copy(strp, true);
 
+	tls_strp_load_anchor_with_queue(strp, inq);
 	if (!strp->stm.full_len) {
-		tls_strp_load_anchor_with_queue(strp, inq);
-
 		sz = tls_rx_msg_size(strp, strp->anchor);
 		if (sz < 0) {
 			tls_strp_abort_strp(strp, sz);
-- 
2.39.5



