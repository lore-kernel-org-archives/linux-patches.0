Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827078;
	b=eqQVnPIt2e+yPksxStsBML0UQy52H+jxXLdhOD/XWybIr2WUHwy4zt0EFdogUY/Zx0On
	 gHVH1sNxMFACoOI9D6BWFtanEP6+dgKHylJDSNqGGBn5jZMOp3wWdzoelHF85vUEdGtBc
	 sHtkiB3hQOYDpMJR76sPQ7u+06+gRuWcdpdUnLIik5d4sSJYUI+Jl9CAImlULuWrE2vdb
	 dL9pPVH2IbAPYiYEVEyZ5u6IIxGMZ6DdWi/5U6B8bzSm1u5Ovk5kmmYfB/mj3SEGDbXLV
	 4FykGh6JVnqe/9qCKnsgqbmDFm1DdGhYqjcuZX4vYdc713cjDbWy/iafQVHi89BG4Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JrQzLCk8/RgHsZUQyVWXSRxfnN87B3K2wnINvrmoA+s=;
	b=zUUOyICpUXiU8QDm1qx9/kfoX3vmhOoKj38tZ8MKhC3Rx7TNlzugf8VDqFDpVqspl9q6
	 DMX7p3WwAR3vW+KIz4CpIJht5ONzDAz34Q0y630YxBiz57GH0mcI6o7y/6T5FvFBBHJ9X
	 B7HDT5Y1/4ZRNieuA8v0mnnF/2mkXvbwnTxxQrC4HGvTmDxRcbilKTHwuND2zBBFev2Xo
	 5iEazAUzUGhMFDgpq1L1BDBDeEg5a7AFOXMREHRanHd36lgEmSJXovMDRaD7AmLUyk0uA
	 Dqpr5A9vqumkoZTau4PjzfpZanSFvVCnxrRI8rGm0+njuHxoRZlOkNhLMd5FGhNhSbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Uzfz3/+3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88B7606AB0B;
	Wed,  4 Nov 2026 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uzfz3/+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549F21F00A16;
	Wed,  4 Nov 2026 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827077;
	bh=JrQzLCk8/RgHsZUQyVWXSRxfnN87B3K2wnINvrmoA+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uzfz3/+3DVbgcodVafbx6LpUZEAFLE1Ia8N3v1IOC45fDnZVFloycBJEaPoXOSqZ4
	 y2i/7W8hyiPPSJ1+6TulFOWHEk7FWOMOqRawXCQNynq9Bqx5xULQ9QeeLq8f1Fa9jr
	 nzUAeizLfQjzPuK4zjUoPAJ3flMaEJ/XjjXvL4zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 7.3 142/547] spmi: Fix potential use-after-free by grabbing of_node reference
Date: Wed,  4 Nov 2026 16:05:26 -0500
Message-ID: <20261104211042.208424937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit f7aa9de4f2b197cdd704cdc476901b68ee128433 upstream.

As noticed by Sashiko during a review run of an unrelated patch,
in of_spmi_register_devices(), for_each_available_child_of_node()
is used to loop through children, and to also assign a node to a
newly created SPMI child device.

Problem is that the refcount is dropped at every iteration so, in
the specific case of DT overlays, a use-after-free may occur when
an overlay is dynamically unloaded!

To resolve this, increase the of_node refcount when assigning (in
function of_spmi_register_devices) and release the reference in
spmi_device_remove().

Fixes: bc32bbd04011 ("spmi: Set fwnode for spmi devices")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608100949.36309-1-angelogioacchino.delregno@collabora.com?part=2
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/spmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -24,6 +24,7 @@ static void spmi_dev_release(struct devi
 {
 	struct spmi_device *sdev = to_spmi_device(dev);
 
+	of_node_put(dev->of_node);
 	kfree(sdev);
 }
 
@@ -517,7 +518,7 @@ static void of_spmi_register_devices(str
 		if (!sdev)
 			continue;
 
-		device_set_node(&sdev->dev, of_fwnode_handle(node));
+		device_set_node(&sdev->dev, of_fwnode_handle(of_node_get(node)));
 		sdev->usid = (u8)reg[0];
 
 		err = spmi_device_add(sdev);


