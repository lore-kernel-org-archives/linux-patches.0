Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A9E23394D;
	Thu, 28 May 2026 20:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001188; cv=none; b=HDGGduodPp9hosZMtdstGRhpV8He1JAGEXwMwukI2Z6rLzZzrLXW++J/lKjUBvdX8EejeiStzufxk5jmmHxIBKQbYIZG3OrtZRT9WT3mCN+FbXVAzyCp5Gzswe16HHGOVO+VkD9lRr5V5ZlWF7yr+9r8Jr6K6JKRR2ucMRC6skE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001188; c=relaxed/simple;
	bh=TB6brmzw8CouT94maFYVaqvYCsX9AaDH+iLIcEmh7t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQiqgJu+7ju3nFNc/Ysi8xRPmxaVy5k+L7+hd7oBsZH1w8eiW7e8HvC9Ax2K2fAlZyGi0ZZ6EjqL8CrdnRss6c5dH7DFM1U2RrRYkkIjSAH0OTuV36EVBm/7pwsRX20W7nJ0OeYoaH42sYUsE3CbRt93zb345PzuUE2Kplce/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3VvQlpi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3VvQlpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A761F00A3D;
	Thu, 28 May 2026 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001187;
	bh=+E8ChDiWZpXaK6VNb/HATFdpSX3/AhwvQFhzQUq8vJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3VvQlpieTLvcTwAiq0x4BbWjf/RDUJ4xAKKbpmNbsb+wPIbO2L49vmU0dIHe14pa
	 yXPL/qstY7CYo6R381bQkjSb8lKZdsjDPUvrExHzOx+uX5Pq4mBQJM8P/BpiA1ByrR
	 vM2lNkfnEVQ//VjZQsLCF+X2ZCDxdT4eolpneKJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 039/186] Bluetooth: MGMT: validate Add Extended Advertising Data length
Date: Thu, 28 May 2026 21:48:39 +0200
Message-ID: <20260528194930.019320329@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit d3f7d17960ed50df3a6709c5158caff989c8c905 upstream.

MGMT_OP_ADD_EXT_ADV_DATA is registered as a variable-length command,
with MGMT_ADD_EXT_ADV_DATA_SIZE as the fixed header size.  The handler
then uses cp->adv_data_len and cp->scan_rsp_len to validate and copy
cp->data, but it never checks that those bytes are part of the mgmt
command payload.

A short command can therefore make add_ext_adv_data() pass an
out-of-bounds pointer into tlv_data_is_valid().  If the bytes beyond
the command buffer are addressable, they can also be copied into the
advertising instance as scan response data, where the caller can read
them back via MGMT_OP_GET_ADV_INSTANCE.  The trigger requires
CAP_NET_ADMIN in the initial user namespace; KASAN reports an 8-byte
slab-out-of-bounds read.

Reject commands whose length does not match the fixed header plus both
advertising data lengths before parsing cp->data.

Fixes: 12410572833a ("Bluetooth: Break add adv into two mgmt commands")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9140,9 +9140,15 @@ static int add_ext_adv_data(struct sock
 	struct adv_info *adv_instance;
 	int err = 0;
 	struct mgmt_pending_cmd *cmd;
+	u16 expected_len;
 
 	BT_DBG("%s", hdev->name);
 
+	expected_len = struct_size(cp, data, cp->adv_data_len + cp->scan_rsp_len);
+	if (expected_len != data_len)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
+				       MGMT_STATUS_INVALID_PARAMS);
+
 	hci_dev_lock(hdev);
 
 	adv_instance = hci_find_adv_instance(hdev, cp->instance);


