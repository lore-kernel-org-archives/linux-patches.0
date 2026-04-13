Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FCA2741A0;
	Mon, 13 Apr 2026 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096766; cv=none; b=SXGGWa4SvO7sfYvd4SY4yvGuHQrFDK1J1q7OaTgrXXkoKJSvLo78z/wRR8A5T9RWHhhNDY3ShKK2z+tkyRB/bae+7zbu+Hb0mFB4zYD4zt6tLzDedw8FVWkf8z6a8wcPxODRCpr1wIJj+PBoqun/ZqcjeGr3p2rj2n0K9LrjNyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096766; c=relaxed/simple;
	bh=IH0SA4B6twXh3I+KiDsP7auNbAglpjIET3fKXJPb0AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZGxdB2z1VVgmV3f6sW1G1+RfY56CpgBsIuKQ8oIPTlVA/TStamrcFHWazetLQMXMMyCE6QSn3TMpMDHNIAkfVEiMHBCrp2Z3S+rm/fUsfoJ/GY7RVBanfX917QaROMlEyxkBRJYU+1cj4JAwedDr1i+VYBKzr1NQxb9xjh6E+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fWMwaK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fWMwaK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBD3C2BCAF;
	Mon, 13 Apr 2026 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096766;
	bh=IH0SA4B6twXh3I+KiDsP7auNbAglpjIET3fKXJPb0AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fWMwaK0jh7lycBYn+nR3JayyiAtCtZ0i0WuA2CYtVd+IhDMsKvMu1f+Y5+B1FEXn
	 WI5C3LFJk//HgqcoHd3Oq6ImSTf81GNy0q55Rq3W5OhGd8e41AyRrFQ7h5arXH3rhW
	 UA0FnEWDfcc0xBUasR3Wnxk8R3rRxTVltIj5xp40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 22/70] nfc: nci: complete pending data exchange on device close
Date: Mon, 13 Apr 2026 18:00:17 +0200
Message-ID: <20260413155729.015619342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66083581945bd5b8e99fe49b5aeb83d03f62d053 ]

In nci_close_device(), complete any pending data exchange before
closing. The data exchange callback (e.g.
rawsock_data_exchange_complete) holds a socket reference.

NIPA occasionally hits this leak:

unreferenced object 0xff1100000f435000 (size 2048):
  comm "nci_dev", pid 3954, jiffies 4295441245
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    27 00 01 40 00 00 00 00 00 00 00 00 00 00 00 00  '..@............
  backtrace (crc ec2b3c5):
    __kmalloc_noprof+0x4db/0x730
    sk_prot_alloc.isra.0+0xe4/0x1d0
    sk_alloc+0x36/0x760
    rawsock_create+0xd1/0x540
    nfc_sock_create+0x11f/0x280
    __sock_create+0x22d/0x630
    __sys_socket+0x115/0x1d0
    __x64_sys_socket+0x72/0xd0
    do_syscall_64+0x117/0xfc0
    entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 38f04c6b1b68 ("NFC: protect nci_data_exchange transactions")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index d10e2c81131ad..058d4eb530fbd 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -567,6 +567,10 @@ static int nci_close_device(struct nci_dev *ndev)
 		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
+		if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+			nci_data_exchange_complete(ndev, NULL,
+						   ndev->cur_conn_id,
+						   -ENODEV);
 		mutex_unlock(&ndev->req_lock);
 		return 0;
 	}
@@ -597,6 +601,11 @@ static int nci_close_device(struct nci_dev *ndev)
 	flush_workqueue(ndev->cmd_wq);
 
 	del_timer_sync(&ndev->cmd_timer);
+	del_timer_sync(&ndev->data_timer);
+
+	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+		nci_data_exchange_complete(ndev, NULL, ndev->cur_conn_id,
+					   -ENODEV);
 
 	/* Clear flags except NCI_UNREG */
 	ndev->flags &= BIT(NCI_UNREG);
-- 
2.53.0



