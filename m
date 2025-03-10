Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5464233733;
	Mon, 10 Mar 2025 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627408; cv=none; b=pEf7/Le06KqcYIF/Do6jODx74Mq4wPotl1L2mKXN9X/YJcxKcjTqd898WUHlJ49sK2YiSJuRsZsNdyTGPPcqw6cSvzEcbKWvMddi93feHGgu9hERqlG2NLo8LaS+COAaHSgRkr23t9fuTffn5ugv30uGTJkn4PhFaaSR+RSSKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627408; c=relaxed/simple;
	bh=TcE6Mkx1ZC9EQuh4xdp50eeyfGVKsbaP/lIRzPhcBkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRua1LxL/u7gr1ogxpqxdPkx6Pp6sDUQxwgEm6Iunkafin2Sv9IzgMaH973GF0Ru46vyNST2dYOt/Up6d0T/9H5UpWnwWgvlg9HSCHU1hNdp8fNKNS6Av8RBUWAXFT+XmYaty3nWC43Zmvjz27Dh1AtRSOUGBVoi78xvhlyYH3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moWN2QwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moWN2QwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A2AC4CEEE;
	Mon, 10 Mar 2025 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627408;
	bh=TcE6Mkx1ZC9EQuh4xdp50eeyfGVKsbaP/lIRzPhcBkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moWN2QwCHblrWI0aRhBm+UgaJVDFlRQh0Fb0MHYWsFmQzx1jDfo0lNnZMjuMk+eJR
	 7/TB4bwIIlJV+ODCYGDq4dc33FKq30VN9DyVq/dmgtVdHT2fQp2Xnn/ncVkdnpueg1
	 JA8xLsM1DmQsXv2qljo1oh5Bs0ndRfY7JbbNYRuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 120/269] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()
Date: Mon, 10 Mar 2025 18:04:33 +0100
Message-ID: <20250310170502.504967494@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d8df010f72b8a32aaea393e36121738bb53ed905 upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_device_connected() to prevent null pointer dereference.

Fixes: e96741437ef0 ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9731,6 +9731,9 @@ void mgmt_device_connected(struct hci_de
 				     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
 				     eir_precalc_len(sizeof(conn->dev_class)));
 
+	if (!skb)
+		return;
+
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);


