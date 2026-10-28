Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217306;
	b=j+EfIgIxhBRS8JPvobZkA9emguNHXjTyMmeJbk/FraUr65OX7rdNCXHATjoLwbQdLKAo
	 hs/jgE8j+Y89JTa+Juv+47P1LBiuyTzO3150SJltvj7u94/X9AXhwxjoOnKqcMWwQCyWx
	 45rBN4zYU79+HIzspLRsvvP0U69E6COQzZnW+eXS58uAbi9CtsHvULUcFFGK89TZKOKea
	 8UukNjuj7br19tiRG5nsH5yTJgaToSLrMGG0MD3fyjkjaiapqtzc5Tfyzd/oDvSZISFbo
	 9AfLuk57t720bK07LJpz75ZM+BYgKvMmJ6zHbxGooLkoFT/ZyDnC1GjYBh/IATNX7Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ivpofxjNWRvJ/9ApMBp8QzVMb6M8/L0UBE2a2WiK90o=;
	b=dsP2Yq0ghCxmAeq09PKztgnc1rEyoMuJxcapPnAXEmbomJsRQpmqbVkVpbeWE/aQJB1x
	 tfwfRNR/ByTqjTltTCJQ0owdLst89ep7It4QlwqsL4JoZ0zSSue1E5jkzi/EdS8yVxVzt
	 RTJIxz/21/kCCAQj9avXFT+ksGXZNZsmbVia/7r9y50TSlFHX8X2Elo2MeNW2Yb7knxit
	 x7GZH91m5Jda02a4WS2Opca9LFLTYlfPOb7iMUExTm1GJoLr26NrKa1F/6WouliVo1pPt
	 h3JwR5mVIuduVo5ZyUKLWRB2rDo1DRQHu+QEVtkSZVtU3Y5jjm99wIDZyzSyvYjywpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pef0boHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FAB606A31D;
	Wed, 28 Oct 2026 19:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pef0boHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CBD1F01825;
	Wed, 28 Oct 2026 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217305;
	bh=ivpofxjNWRvJ/9ApMBp8QzVMb6M8/L0UBE2a2WiK90o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pef0boHsyInmS3rCnXlHanTWNptJxQ8TDL0ae6hrwahLL+mk3CDIUumRmPtu0xcxw
	 uy97W9PFRDWWGQtX+9r/pNZhP6890yGxirapzX536ip2d3eCFWn6xpN6UsWq3mXKtY
	 GVv+qLu2SujubwfXdCYPoMtgquSuk2w8qn6rCOZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Juergen Gross <jgross@ssue.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1858/1887] xen/events: fix error code in xen_bind_pirq_msi_to_irq()
Date: Wed, 28 Oct 2026 18:05:54 +0100
Message-ID: <20261028170541.734218323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7f3da4b698bcc21a6df0e7f114af71d53a3e26ac ]

Return -ENOMEM if xen_irq_init() fails.  currently the code returns an
uninitialized variable or zero.

Fixes: 5dd9ad32d775 ("xen/events: drop xen_allocate_irqs_dynamic()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Juergen Gross <jgross@ssue.com>
Link: https://lore.kernel.org/r/3b9ab040-a92e-4e35-b687-3a95890a9ace@moroto.mountain
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index bdfbe27591593..8fd9d173a9a9c 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1101,8 +1101,10 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 	for (i = 0; i < nvec; i++) {
 		info = xen_irq_init(irq + i);
-		if (!info)
+		if (!info) {
+			ret = -ENOMEM;
 			goto error_irq;
+		}
 
 		irq_set_chip_and_handler_name(irq + i, &xen_pirq_chip, handle_edge_irq, name);
 
-- 
2.53.0



