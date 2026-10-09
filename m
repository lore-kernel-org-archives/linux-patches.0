Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD954E8E0F;
	Fri,  9 Oct 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557070; cv=none; b=XWyMhibqvMTt2HBQ0kYTrtLbIkkHWatjOg+iuLZdUV5FIR3HMndNjPSlkRfxzaOZLM6+5e+P0IFQWWNs7TkPNaondXlLR93W+rxcLUzaqbOf6wc1yj1svVzQLGeKZy0hRA9jI0AH4MU/Hx0c2wAVGgOY3qseXFjFPTDh/GLuNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557070; c=relaxed/simple;
	bh=vwrvntRsYU5+B7pjFOHeJRsl69ttXgwe+1XvVjrznGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW+E9BBt7JVqhLJXF2c+Y9KJ1AamnVXefV2QrLVpxkanU/ktIEx44fBcjsg5EtaZWYf8yeITmBoEHmBUvFww6HDxbHcj00vHZWvyhgsvXGvP72qEpkzWULAjUnXzWy0qnzqJznUfeeYNG9rbjoIOE0UKstuHyoI8MERL+ePE1v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV00o8Hc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV00o8Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586FA1F0089C;
	Fri,  9 Oct 2026 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557069;
	bh=7odJJrHmnsuSiOaXZzjZIm9p3X6/LEhW7ZNSOZ8ySFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV00o8HcTo0iEAhJC7kbY78oAr/knT0zIYkY9HC2smiM9Zhi47TZPwjemAoScXpl6
	 yHhe0z2f5AgZxJM9FaZPsYqAV9vGAtNH25wG8dpIjZoJJp1CeCvvmyFEeJ5l6O+88v
	 xXxIgUs/WcUBu1SX0blbHYcF57G56SHyWB8TkSrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 291/428] Bluetooth: btintel_pcie: fix plen overflow in btintel_pcie_recv_frame()
Date: Fri,  9 Oct 2026 16:10:28 +0200
Message-ID: <20261009140952.498676652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 7dbeb6935ac331b0cba6c41cabd8e9d02d5f64ea upstream.

plen is u16 and computed as HDR_SIZE + dlen. For ACL/ISO frames dlen
is a 16-bit field, so a value >= 0xFFFC wraps the sum, bypassing the
"skb->len < plen" check and letting skb_trim() truncate the packet.

Widen plen to u32 so the addition cannot wrap.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1197,7 +1197,7 @@ static int btintel_pcie_recv_frame(struc
 {
 	int ret;
 	u8 pkt_type;
-	u16 plen;
+	u32 plen;
 	u32 pcie_pkt_type;
 	void *pdata;
 	struct hci_dev *hdev = data->hdev;


