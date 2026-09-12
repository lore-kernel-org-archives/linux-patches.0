Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAED733AD88;
	Sat, 12 Sep 2026 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204979; cv=none; b=UVzi/mTfW6jTRH2csdm6V8+QS/ousU5VAk5kV/DGIX1AoXBZqhMqErXFVEQXi5ctaOoSm8IyuMWEm7gqUFeA9tdSSHeIvuDC/+mZvAGoAC61tWCxhxeJV9TzJZ5rFn/ffmXN/rMgLkMzr7pklEH5ggGffgd+4M3N8sQZuV5VVWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204979; c=relaxed/simple;
	bh=Pn2ABxJUGFBDR7i9LGZIAick/7IJ2ni66i4k2SbC88w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQU2pWkI67Uw8K+rffqRAYy0k4Fcp7PaqNHVEdTHXZHhv7TCnx2aLVbuQaGQ7Gc0O3sxXDzo5prKzsjSVV6KcspyRpqAojlRVbIrcbog1/qsWVP6qArRJjmJWHn4ZQiWuLBLrj3lumVW8W/1N36IpGriU4e2du1p5SgHe80yu4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo1vP1pI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo1vP1pI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E041F000FF;
	Sat, 12 Sep 2026 09:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204978;
	bh=NF8VGngeAo9ek+QU1JA9BE54ylxdzp+hgkjMAZ7+f7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wo1vP1pIP+UMoPFTze3Jp8/LG1nbCSf5Zz6a011FXvNldv96yIf7NKAWYd3aLn0Y7
	 mpwvymhCkqi8CZVwvyBcgq2i607m6jVCJIn3gSDk4Np2rSuP0HyczStTZ2Rw+5ahlJ
	 2bZXZnYfIO1dq7gsi9aTB/sdO8NV7505/AlXPCBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 7.2 1723/1815] Bluetooth: hci_sync: add conditional locking annotations
Date: Sat, 12 Sep 2026 08:57:53 +0200
Message-ID: <20260912065729.422842905@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 5b9b68abb5fa548478e20ee38a0ef5c18e9cf4b7 ]

Add context analysis annotations to functions doing conditional locking,
to suppress analysis warnings.

Fixes: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e6ffeb2c60939..86de842175ab8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1287,6 +1287,7 @@ hci_set_ext_adv_params_sync(struct hci_dev *hdev, u8 instance,
 }
 
 static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
+	__context_unsafe(/* conditional locking */)
 {
 	DEFINE_FLEX(struct hci_cp_le_set_ext_adv_data, pdu, data, length,
 		    HCI_MAX_EXT_AD_LENGTH);
@@ -1375,6 +1376,7 @@ int hci_update_adv_data_sync(struct hci_dev *hdev, u8 instance)
 }
 
 int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
+	__context_unsafe(/* conditional locking */)
 {
 	struct hci_cp_le_set_ext_adv_params cp;
 	struct hci_rp_le_set_ext_adv_params rp;
@@ -1531,6 +1533,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 }
 
 static int hci_set_ext_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
+	__context_unsafe(/* conditional locking */)
 {
 	DEFINE_FLEX(struct hci_cp_le_set_ext_scan_rsp_data, pdu, data, length,
 		    HCI_MAX_EXT_AD_LENGTH);
@@ -1584,6 +1587,7 @@ static int hci_set_ext_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
 }
 
 static int __hci_set_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
+	__context_unsafe(/* conditional locking */)
 {
 	struct hci_cp_le_set_scan_rsp_data cp;
 	u8 len;
@@ -1725,6 +1729,7 @@ static int hci_set_per_adv_params_sync(struct hci_dev *hdev, u8 instance,
 }
 
 static int hci_set_per_adv_data_sync(struct hci_dev *hdev, u8 instance)
+	__context_unsafe(/* conditional locking */)
 {
 	DEFINE_FLEX(struct hci_cp_le_set_per_adv_data, pdu, data, length,
 		    HCI_MAX_PER_AD_LENGTH);
-- 
2.53.0



