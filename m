Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE90314A95;
	Thu, 28 May 2026 19:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998081; cv=none; b=up5EVhl7ZDQp8VocmNHnqfA7vLjsjSGVzGGFK6mfnn0DD62WATj7Gs8tUoYV8CzMO1098Q00WjpEpwXZ1t3grRK5qyNj3O5sQx/W3OqQxUmwuaAW3zdLzzN8qYsuVBKejFCm7aIXBwevNej+5+nDqhQce4QwwULW++r5IfmaAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998081; c=relaxed/simple;
	bh=mlBaJuo+P6bTU8dlqD+yI7oAZ2OACW0QAQ623rDlT3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efh9wgnLfW45a0oZ4sNKtcqQw/WoVVWYwRnm8pag8iPtMIPU3HLZyCYB04sOTEuQRL4BK77gKQf7T9b8axTo5c4cZhUssynCk2z/U6bPvk+JoJ//K6PCF9grN+uBZhKt8HG27TjgMy1GRr4O0KhCbf1fhc9blFrYZU91jkn3vpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTy9c1G9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTy9c1G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282C1F000E9;
	Thu, 28 May 2026 19:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998079;
	bh=JJbGNSNc3K0ccDLu6AyUpN4THF7XZW8uGYrrH0MJqJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JTy9c1G9pACaD38+SLzaBp+RdICRSSfGrD5lJ0PeoVzWjHB/sfwCPdHx2wXkf+iUr
	 Fpo/M+vnov+cxSZ33xC2x6n8RjW0WpKvlai011nAWOr5FIHpaSP7MHyZ8rWsRc1bh1
	 TIajpw4dLpXoKYZMFdN9DhT8Xnuezy9exbzy9xj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 047/461] Bluetooth: MGMT: validate Add Extended Advertising Data length
Date: Thu, 28 May 2026 21:42:56 +0200
Message-ID: <20260528194648.269225182@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9110,9 +9110,15 @@ static int add_ext_adv_data(struct sock
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


