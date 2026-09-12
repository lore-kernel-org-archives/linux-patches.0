Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB4041A785;
	Sat, 12 Sep 2026 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202699; cv=none; b=dbS/HjlNV7yQce6GbLXiiAR2mVmTDBGXxW5aFv2rj7tv0vGj2ow1cxXMwLQ+2IzO8mylpYUZ8el9XVoAUfRoZhq9wuS0RNt1RoJir0m9u1TXoGm9svVOQ411xasrDKk/PmHKI5SsoLmWeKXTZBKWMaDn8XRZ7iUfOjG9IswmbS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202699; c=relaxed/simple;
	bh=j8szpb2V5Jlqd15tfxfRSW+jsiUSWxfpJEwxzTFgAnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRI2gdwkiYQvlIrqCXdJtgMDB8xG7Necs08tXiUkvSMCUn1doVBpLItOV9fAVUjIfl5OTtmGBP/C+ZnWlvwlS4Jesen2xSFwqm6z+CIHn4iwjJpT1VvWozBAkebFIOdshn1klX44FhuWH7ScD7xFBnf+jZFgXl3iDPOQx+g2mOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDRDjEZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDRDjEZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1CF1F000FF;
	Sat, 12 Sep 2026 08:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202696;
	bh=owt6c7+htC58Jjd0TlOurVd3llB7koo5bv4J8k8bL+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDRDjEZNoygbH8Q2/5Zy2AvTozrQys26tVRpeUQLrXu0M6n6jXMA5dVgZ7ZCJfDh4
	 ugpWc+vY608TWGrnvoesfI1RZgH+dVVmq/6AVvEi6VeT/h4Qsiybuw1/rae2zn1eF3
	 1Bi6X0tHcwseA+wka18FPS/qPg6eoF6VFx+I8La8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1256/1815] Bluetooth: MSFT: validate evt_prefix_len against the response length
Date: Sat, 12 Sep 2026 08:50:06 +0200
Message-ID: <20260912065718.499882201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d7badce8746ca..ded68568e6c9b 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -165,6 +165,11 @@ static bool read_supported_features(struct hci_dev *hdev,
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



