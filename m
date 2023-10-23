Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0793815492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eogH8tui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F5EC433C8;
	Mon, 23 Oct 2023 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060234;
	bh=ZeL3tHcnK8C3Ve8tB4kOihsoDJod3dfX0P238QtUd0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eogH8tui+ZijPFP2FY9vD1kgHf4prOBo1dbZaORuJ6RojPrT7II/qVk3O9LTeG+rO
	 XVFQzXSOLh1YyJNueG8yt/k85PnAggRgzJKo03znMd1dDmV9J96sFMargfBCNqMVpW
	 NTutc5Yd0jMswZH+0Dq9W/fMcHB6vZXZ0kt2sai4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dcbw@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/196] wifi: mwifiex: Sanity check tlv_len and tlv_bitmap_len
Date: Mon, 23 Oct 2023 12:56:08 +0200
Message-ID: <20231023104831.445945325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit d5a93b7d2877aae4ba7590ad6cb65f8d33079489 ]

Add sanity checks for both `tlv_len` and `tlv_bitmap_len` before
decoding data from `event_buf`.

This prevents any malicious or buggy firmware from overflowing
`event_buf` through large values for `tlv_len` and `tlv_bitmap_len`.

Suggested-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/d4f8780527d551552ee96f17a0229e02e1c200d1.1692931954.git.gustavoars@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 7351acac6932d..54ab8b54369ba 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -921,6 +921,14 @@ void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
 	while (tlv_buf_left >= sizeof(*tlv_rxba)) {
 		tlv_type = le16_to_cpu(tlv_rxba->header.type);
 		tlv_len  = le16_to_cpu(tlv_rxba->header.len);
+		if (size_add(sizeof(tlv_rxba->header), tlv_len) > tlv_buf_left) {
+			mwifiex_dbg(priv->adapter, WARN,
+				    "TLV size (%zu) overflows event_buf buf_left=%d\n",
+				    size_add(sizeof(tlv_rxba->header), tlv_len),
+				    tlv_buf_left);
+			return;
+		}
+
 		if (tlv_type != TLV_TYPE_RXBA_SYNC) {
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "Wrong TLV id=0x%x\n", tlv_type);
@@ -929,6 +937,14 @@ void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
 
 		tlv_seq_num = le16_to_cpu(tlv_rxba->seq_num);
 		tlv_bitmap_len = le16_to_cpu(tlv_rxba->bitmap_len);
+		if (size_add(sizeof(*tlv_rxba), tlv_bitmap_len) > tlv_buf_left) {
+			mwifiex_dbg(priv->adapter, WARN,
+				    "TLV size (%zu) overflows event_buf buf_left=%d\n",
+				    size_add(sizeof(*tlv_rxba), tlv_bitmap_len),
+				    tlv_buf_left);
+			return;
+		}
+
 		mwifiex_dbg(priv->adapter, INFO,
 			    "%pM tid=%d seq_num=%d bitmap_len=%d\n",
 			    tlv_rxba->mac, tlv_rxba->tid, tlv_seq_num,
-- 
2.40.1



