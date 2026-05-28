Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DA32F1FEC;
	Thu, 28 May 2026 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000502; cv=none; b=CI79EoBPb3GFzbU09tMZCRKc2hCcFStp4+Keeuwe6AsjObV9tG4gotUUF+u7mTgzdgm01tUALvfsp4/Jp7wt5lPWrK8IDpSTSnlRYPuQawaHV7qvelAV5Av6UdljdwzinU/nXWPLM12P5ye/sRzw2sephzdqBWwYX0hq9Xc+Nck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000502; c=relaxed/simple;
	bh=wwhjP+/k9O3cM6r9PIfvFRjuZZ1OFRe+T+GKhNqZ9FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDWv/OWeitlXpd8zy8EDuNblMo1xx0aRmiHWyrJCe7VNhDOGLhsI2G/6AGwnlIm37ka+2Kq1S3bz4IEDcHw4xSApdwMfST/SV0cjQwMukTlcrQ+gYgy9+I3Mh5ou06kxBZZ0XCYElkOLD0FZpHJYZ+pZbURZ6CnNre4iK8fdkX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlL/wate; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlL/wate"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5E1F000E9;
	Thu, 28 May 2026 20:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000501;
	bh=vTuzpa2oK51LHMYnElUawVMe+Ng1JjBTSV/LAg7bmI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlL/watePd1kIEmYhmQ4iZx4NLigAGzJGSJlZIoZFNGqtReVGgxyfurT6p19TW5JG
	 W92BS1nufSN3fDb+wg3nNWJm2eUwHat9yNJP1B6ZvSQcNccB7sxb4j9e2HeA3gjfKE
	 lLGs6/qXXdJsnKtAeyzz+vHVBucvU9s2CRSTL4ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 067/272] Bluetooth: MGMT: validate Add Extended Advertising Data length
Date: Thu, 28 May 2026 21:47:21 +0200
Message-ID: <20260528194631.255637188@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -9193,9 +9193,15 @@ static int add_ext_adv_data(struct sock
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


