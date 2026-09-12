Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D671FBEA6;
	Sat, 12 Sep 2026 16:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231112; cv=none; b=ifSwUrwtXgQh/jsPm8pTauBwC9q8xs9fkKFz4Dl5hG1dCAqulYplvaavOny83Ub6MMLkwWHHvZkGcjKEQS/YzoXsW4iIBOn5PKIxyY41Fvc72VjEUNrwtZ1mKnb3N4SxKLoecVTpyfd5ixaImzCaV823JWATaFS7/ymvsGbrs0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231112; c=relaxed/simple;
	bh=MOzRpMSl6WrH3bIaZj+6HM1C6QXpSz5W/qHAyXftymE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjSBJRQvD9lONJfRj2XQ1Kl7tQoyjfaaagjG3oqOyXBAh44vWF4pbJ5y8D01JeKzRMmbL2cMoT54bjsIQGwFx2h4IfUCwY70AVonRU4R8PbodEwvAoJdQ3nkCapaHuExnYc1ZFlnmgx/2iGtddNa/Vn224/LCeHcTAKQi4oL0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cm1THRLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cm1THRLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C84E1F000FF;
	Sat, 12 Sep 2026 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231111;
	bh=8FUASymNnaXdeVnhdlymnyIc9/vwmLddeSl0SSXQtxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cm1THRLknxl5Lp1ayWQoXVE0isjBgJ8qN3CgMRcesnUZcvE50gqRXA5TD2EbKsFuh
	 Jd8nkYMug6+8hPHNp5tnEP9EyhGofiuIlWnBqAPqZsD7fJBZJtFY813xi1wgXr05bt
	 eBj1SAzWf6sFUBh33MteC96TAIZCUn/KsVkA2lFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0933/1191] Bluetooth: MSFT: validate evt_prefix_len against the response length
Date: Sat, 12 Sep 2026 09:01:01 +0200
Message-ID: <20260912065609.183539452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 0079e1a944634ab2dc1c7cdec1144486d096407e ]

read_supported_features() only checks that the response covers the fixed
part of struct msft_rp_read_supported_features, which is 11 bytes:

	if (skb->len < sizeof(*rp)) {
		bt_dev_err(hdev, "MSFT supported features length mismatch");
		goto failed;
	}

evt_prefix[] is a flexible array member and rp->evt_prefix_len is an
unvalidated u8 taken straight out of that response, so

	msft->evt_prefix = kmemdup(rp->evt_prefix, rp->evt_prefix_len,
				   GFP_KERNEL);

copies up to 255 bytes from a reply that may have carried none of them.
What is copied is data the controller never sent, and it is then used to
match incoming vendor events in msft_vendor_evt().

This is not an out-of-bounds access. An skb data allocation always has
at least SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) bytes past the
payload, which is more than the 255 byte maximum, so the read stays
inside the allocation and KASAN does not report it. It is still a read
of bytes the host was never given, with the length fully controlled by
the controller.

Reject a response that is too short for the prefix it declares.

Verified with an emulated controller over /dev/vhci on a KASAN kernel,
with vhci made to advertise an MSFT opcode the way btintel, btqca, btmtk
and btrtl do unconditionally. A reply of exactly 11 bytes declaring
evt_prefix_len = 255 reaches kmemdup and copies 255 bytes
("skb->len=11 evt_prefix_len=255", with the copied buffer dumped); since
the reply ends at the fixed part, all 255 come from past the end of the
response. No KASAN report is produced, as expected from the allocation
slack described above. With this patch the response is rejected with
"MSFT event prefix length mismatch" and msft->evt_prefix is left unset.

Fixes: 145373cb1b1f ("Bluetooth: Add framework for Microsoft vendor extension")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/msft.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 39c7fc8c5a17e..c27e137a23475 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -139,6 +139,11 @@ static bool read_supported_features(struct hci_dev *hdev,
 	if (rp->sub_opcode != MSFT_OP_READ_SUPPORTED_FEATURES)
 		goto failed;
 
+	if (skb->len < sizeof(*rp) + rp->evt_prefix_len) {
+		bt_dev_err(hdev, "MSFT event prefix length mismatch");
+		goto failed;
+	}
+
 	if (rp->evt_prefix_len > 0) {
 		msft->evt_prefix = kmemdup(rp->evt_prefix, rp->evt_prefix_len,
 					   GFP_KERNEL);
-- 
2.53.0



