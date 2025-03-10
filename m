Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EFB22DFAA;
	Mon, 10 Mar 2025 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627501; cv=none; b=XMv4Tv7oxGRv72vKrSJqXs2ZAYQIiTDJQ3ivrzJQ0xWwN893Yr8dXXzUR4NdjYNsbkVrf2fS/76XszNM5gkPMPf3sJrs0euTI7jakNVdZRTRQ8jpxJKEn1bOMNE8FbF0I3jahAG/VgX/B3zlt9Ikj2ctkqnpkZMP2te2OFLcjfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627501; c=relaxed/simple;
	bh=z2QoIpgQPAo9PLxaDh89D0IVovyqR2e0BVQdmtudKrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAV1zbi6dx/zduhq8u+it5EAQSogHpuzbASbdqRhkFbaqKEjkpFotvoCyOUEhcQpYRn2vqASNGY3iHmYlp4/Cb78VZfIpdFeolL0iLq/6IOw7x9okTUGjxJd0RfPU/eU5Zy9BTCAOSlTfV6a9sKHU0Wtneo3lBgErhKbU+06TFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8/mtl5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8/mtl5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC53C4CEE5;
	Mon, 10 Mar 2025 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627500;
	bh=z2QoIpgQPAo9PLxaDh89D0IVovyqR2e0BVQdmtudKrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8/mtl5b8M3NSZUb+Ug1RJSFEKw0gEKyiAYlftmKKypkqwtLPSV8IZSo1U4s/v42W
	 UzhG8rRAZMeLrlySE1PiMg8Ismx7Ww2TWy8CSEugek6Tdp65V2SpiN3epV+wpy9Oqn
	 Wh+Qb6T6SN/voMyAB8NkXIKExISfla1ObPjpK0qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 119/269] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()
Date: Mon, 10 Mar 2025 18:04:32 +0100
Message-ID: <20250310170502.465307594@linuxfoundation.org>
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

commit f2176a07e7b19f73e05c805cf3d130a2999154cb upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_remote_name() to prevent null pointer dereference.

Fixes: ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -10484,6 +10484,8 @@ void mgmt_remote_name(struct hci_dev *hd
 
 	skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
 			     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
+	if (!skb)
+		return;
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, bdaddr);


