Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B786052CCC4;
	Thu, 17 Sep 2026 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665969; cv=none; b=df1mIs7qj2AiCEPLqnDhFUXMxrfyY7blzqyysWvLEigJnAN0UPYzZcODOljiShk7eY4I6keSTq9a86SoIf/CpZljXw6svrev1RK8ooVl8NRvxWtRoOOhGBFBOBfUisD+9Uq6GKD1c9mzkq+wstoM+pcXuLlSMHNOp187iJGZsj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665969; c=relaxed/simple;
	bh=zwtEVGSlYiw84bPM5OGOQXpKA0Qr39nK63zJLSq3s80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcSOtVTwW0JToWsiINa92LKa+p2cMmaWUu5cf5HSYIrPMlChwkMhSfckueAk2m4n1Vr0m0lKuOVlwdyVhlLzwmaqirk5cll9i6DUi95g5lSzEPc4oEjAe4c8aTssHMvsgcOsUSOMpzgn7LprZGpqcJNYlQRKtWT7NKHb0/W5Ad0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3EL7zHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3EL7zHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C651F00893;
	Thu, 17 Sep 2026 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665967;
	bh=Fzysj+9o+3g23OGrbvorTGHAs/RzR1JW3Ytfr0B/BpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3EL7zHo+R+GKKKERZSf9TMBbpPzrcy0AgpgVziakDAXV6y3gR2wzUMTunUZzXHdk
	 GPdj8HXzhKyLhtN51rOpWbXqnmknY+BR5QhaXfp4VuE8VfssWPmT+5teiKBE7PfaXF
	 lbVpeAK3qqsBm5C3oylEaQ7DrNnmIBCXgBSmiUEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0880/1250] Bluetooth: btintel_pcie: validate packet_len before skb_put_data
Date: Thu, 17 Sep 2026 16:11:15 +0100
Message-ID: <20260917151615.836578079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 6436e1b5331b1aebf905c13e0880a37032719b75 ]

btintel_pcie_submit_rx_work() reads packet_len from rfh_hdr without
checking if it exceeds the RX buffer size. An oversized packet_len
can lead to an out-of-bounds read in skb_put_data().

Validate packet_len to ensure it is non-zero and does not exceed
BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr), logging an error when
invalid.

This issue was reported by Claude Mythos. It can be simulated either by
using customized firmware configured to return an invalid packet_len or
by modifying rfh_hdr->packet_len in the driver before calling
btintel_pcie_submit_rx_work().

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 6b7a8c044119a..e599e89725cd5 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1365,7 +1365,9 @@ static int btintel_pcie_submit_rx_work(struct btintel_pcie_data *data, u8 status
 	rfh_hdr = buf;
 
 	len = rfh_hdr->packet_len;
-	if (len <= 0) {
+	if (len == 0 || len > BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr)) {
+		bt_dev_err(data->hdev, "Invalid packet_len %d (max %zu)", len,
+			   BTINTEL_PCIE_BUFFER_SIZE - sizeof(*rfh_hdr));
 		ret = -EINVAL;
 		goto resubmit;
 	}
-- 
2.53.0



