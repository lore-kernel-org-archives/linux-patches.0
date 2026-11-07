Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065214;
	b=d1PdbtC4h0JkTPE8pwdeKSJeAZSJ8wRQclIdDxOuyrb4QGgLK7NOOASwgblYX1pXCBw4
	 TjcuP6QxF+BnCJo9edg7jpT+/rvfdd3OrjyS5Y3nntlqHcQrrZej4jjalz1AXJjmLXM/Q
	 2JrgdKDPqNIaCwwH6h8ujnt6gMrViSLPOP4sb1fGZzpbgUQyJ8oXQKfuA6gfcgHGA8qUA
	 fS/dIqgrJyTHbVkCSCf2x8fGYbS2cu4ESZUbhbHC4xQS3zObicVvbPf9VjIh72d/c8M5S
	 A7d83XbS5lQKX3bQsgQZoQsSa5issgqpUaf9yhV2RR7hNdIm/1vA7tQT8DMguiXkEMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dP4f3bQQjF1RFp/b97oHr3wq9jn1r8Pr05cGVF7UAUs=;
	b=04WFDVKBAvFZXwbr4wxhb0PQSt+XD825fLsUvS8T2nT9sTO6h8vO+zeovdhIEapQPWLl
	 XS2I2zvh53DLFpckvDyYUvgRFeoRKYPSc1AhpUoMj6P/cJ78Wz69Z5MEQnRJHCbRB6eX1
	 v/pzvLgwsRHDWJGULV0iP+7C2gdHISeZInyROL4ptftNt+E+iGiCtLfQbfd8XG/yitYW4
	 YQEsyl4AD0TSuz4CJhiGnXQfRuu55k5mddnIBfO86DzShoPybArmvJE9qBwxCXr4J+Bv0
	 vBC/pSTDYrAP+2TaH435B61WqGwD+CMgXXEvNKGNoUsZkxXu5EYdC/AecplJY2bl6GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+nr7aSC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1592606A331;
	Sat,  7 Nov 2026 15:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H+nr7aSC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B3F1F008A1;
	Sat,  7 Nov 2026 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065213;
	bh=dP4f3bQQjF1RFp/b97oHr3wq9jn1r8Pr05cGVF7UAUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+nr7aSCdVkCdXKgGZZmPBizXQ6b/v0ySiFJcu2GMHgNLwKdvWYeiVLOYJY9EM33M
	 c44K6Hzatuh3NKU+nrb6szUm846PVb70x9WfwPaMUWZuybArIOwRFJa8GZetd9I0xC
	 PAsZvRRu9Sh1j75/QfKXvpSP2mAcbIvNOKPIij4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Charkov <alchark@flipper.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1008/1257] PCI/pwrctrl: generic: Fix leaking array from of_regulator_bulk_get_all()
Date: Sat,  7 Nov 2026 08:55:04 -0500
Message-ID: <20261107135007.181454072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit ee450e3a2d334c7e6383d8a55ad2d53b3822bacc ]

of_regulator_bulk_get_all() allocates the consumers array and returns it to
the caller, who is expected to free it at an appropriate time.  PCI pwrctrl
never did, leading to a memory leak.

Add an explicit kfree() for the consumers array.

Fixes: 75996c92f4de ("PCI/pwrctrl: Add pwrctrl driver for PCI slots")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-pci-pwrctrl-kfree-v1-1-f09bbffd8da3@flipper.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pwrctrl/generic.c b/drivers/pci/pwrctrl/generic.c
index d56171e0ee244..4b6cbbb522480 100644
--- a/drivers/pci/pwrctrl/generic.c
+++ b/drivers/pci/pwrctrl/generic.c
@@ -63,6 +63,7 @@ static void devm_slot_pwrctrl_release(void *data)
 	struct slot_pwrctrl *slot = data;
 
 	regulator_bulk_free(slot->num_supplies, slot->supplies);
+	kfree(slot->supplies);
 }
 
 static int slot_pwrctrl_probe(struct platform_device *pdev)
-- 
2.53.0



