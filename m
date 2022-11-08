Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F5D15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B7FC433C1;
	Tue,  8 Nov 2022 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916532;
	bh=nDYNS4PGAaPaoLEKupnHdu2IljDtSRZ3Qw5fIx3e9Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVZNwaJZ+PSRFeGtAqhxqWGSFqlRF2Dg0UtgMP1I4Pkz5gNraghXp8NiJtZ4Zwppi
	 YkK3o6gSNzRX41ttPjpDG3oHUfaBYn2HF/qRUL9jPYkNeKOHlMqobg//n+VsYkWb1v
	 CRzxBeZLrqdDeZ9h0p+TGzIJGTFVSV4VtZtxvZWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soenke Huster <soenke.huster@eknoes.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 051/197] Bluetooth: virtio_bt: Use skb_put to set length
Date: Tue,  8 Nov 2022 14:38:09 +0100
Message-Id: <20221108133357.137153682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit 160fbcf3bfb93c3c086427f9f4c8bc70f217e9be ]

By using skb_put we ensure that skb->tail is set
correctly. Currently, skb->tail is always zero, which
leads to errors, such as the following page fault in
rfcomm_recv_frame:

    BUG: unable to handle page fault for address: ffffed1021de29ff
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:1751)

Fixes: afd2daa26c7a ("Bluetooth: Add support for virtio transport driver")
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/virtio_bt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 67c21263f9e0..fd281d439505 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -219,7 +219,7 @@ static void virtbt_rx_work(struct work_struct *work)
 	if (!skb)
 		return;
 
-	skb->len = len;
+	skb_put(skb, len);
 	virtbt_rx_handle(vbt, skb);
 
 	if (virtbt_add_inbuf(vbt) < 0)
-- 
2.35.1



