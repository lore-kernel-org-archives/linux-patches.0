Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065215;
	b=2XA3Rg04pnml4xsS57PfBL/9fl3nodVaq8yCe/8jXM51/8B4+T73ua4BLsu5u4qWwZ1M
	 PL4xG1IHH9+arMDFDPUHKxcNfDk/zmdv3fi2iH4GPqsQy9vvsaLPOuFv+sgRLYAJS1Q1Z
	 97wtvJ+CrUA8GHTn2PNUWiruYALyySYiXljZk26DjTI4NSX2xJgqL0EAt2ugLr/vvKdIV
	 ZHeUCMPsIMtgxjWBGid6W6af1wNkuH13sAv1f3XMMW9K3cbyGorpgBhn+DMPSSy9jkWya
	 fY1HnRGju+q819WpXZMHTvNJJ38MdNLjcVOTOG51Cfp6uGVHj8gGPukQBGSUabhPE/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XrvjouC3ro/PLdrFPuzwsrHc5ppvStvYxI9xIBte2Fo=;
	b=pY9pplOBvu9KagxPNfwlc3+VoIrv10zFt44Vd9NhL9vPF+uNd0IY9CJN+yXVb//WiRFT
	 +3UMFghKM+Z28zxE6R1WwQz/9ER5YY6kX+1PkmiLpvryNMg2ZQXylkZFk0Erbu3G0F4oO
	 7y1gjQhso5DdpfTT6spa3m3qpzloKFNkSdTo7jZGtqoMZPAfqix/NCjXW6ORrINPN3A40
	 IyZklglNWkUpGcKvTz1NKc7MNyKsz3b0hS2KDCqcbIdl2HIN0324VyCV2hdkyNOdQXXZc
	 fv4CJ1dR/DwsJMN0lsPDpCYt7DGyghWfJWuqPkhuNQWqbArBPBsritvy0s40n4aorig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT7o8oO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B889606A32E;
	Sat,  7 Nov 2026 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT7o8oO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF891F0089F;
	Sat,  7 Nov 2026 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065214;
	bh=XrvjouC3ro/PLdrFPuzwsrHc5ppvStvYxI9xIBte2Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT7o8oO0CB6oLrNakA81dYhOYf+KPSksfHrwj7B65CB7eOclQbiwwft+b/3MRheH1
	 a9Hy3dO4zsIm2H6Eslj6ZYQoox+KuHzsMmKOj4U5dkuV1atnyBwlR8AyQeBD9dmozR
	 rdFrnF2IK9wf+DuG3pCoPJFAazyow88tkRaWYSZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1009/1257] PCI/pwrctrl: Only destroy devices created by pwrctrl core
Date: Sat,  7 Nov 2026 08:55:05 -0500
Message-ID: <20261107135007.208549858@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 7bf2ebcb7ca1e8814d3d0e35214a8e4b2193a619 ]

pci_pwrctrl_create_device() only creates platform devices for OF nodes
that pci_pwrctrl_is_required() accepts, but pci_pwrctrl_destroy_device()
unregisters the platform device of every available child node without
that check.

Nodes under a PCI host controller that are not pwrctrl devices may have
been populated by another mechanism.  Destroying them here would tear down
devices owned by other code.

Mirror the check done at creation time so that only devices created by the
pwrctrl core are removed.

Fixes: 4c4132489201 ("PCI/pwrctrl: Add APIs to create, destroy pwrctrl devices")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/1791446700-100166-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pwrctrl/core.c b/drivers/pci/pwrctrl/core.c
index 10d817aefb096..c14df117ece37 100644
--- a/drivers/pci/pwrctrl/core.c
+++ b/drivers/pci/pwrctrl/core.c
@@ -388,6 +388,9 @@ static void pci_pwrctrl_destroy_device(struct device_node *np)
 	for_each_available_child_of_node_scoped(np, child)
 		pci_pwrctrl_destroy_device(child);
 
+	if (!pci_pwrctrl_is_required(np))
+		return;
+
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
 		return;
-- 
2.53.0



