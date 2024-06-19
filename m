Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E312FB31;
	Wed, 19 Jun 2024 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802635; cv=none; b=lHKkw7Y4iVCt781rRwzCpAysVKndvqABNx4YU7LKo3V08RpCwj3Qf9OfdhVdd8NyatkM5d6or4QHRLDvJbCXL/vCRbTAoY/u5FQ1PLqrLaskg3MPe+bGaRwoSD4tusSobcdUZnW7axGlOoxPVdxpgV1vPTvCOqDZeTfeQbsTEPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802635; c=relaxed/simple;
	bh=4tkcWRvYPh7yevbqnVdxhtNm4vyO+nx8NIMawQIHr9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrXYJqiA+Qib1ByMhhq4HxeyT2qWN8MJB55BdU+xvi4tfO8eyYU8dfD+vz5PP9I/Oas8IFSg1/NBJIFNkH85CX+sasJDBrUuiaH7C0ofkuZQOdUkW1KALtU/sc5U0LhYI/49eVIwSlxFNxWeZjXKI5G9XaG537JH3edA5tiq7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9OHQNDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9OHQNDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FC4C2BBFC;
	Wed, 19 Jun 2024 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802635;
	bh=4tkcWRvYPh7yevbqnVdxhtNm4vyO+nx8NIMawQIHr9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9OHQNDbXjGyDoLv79lBCL2vRw+9xdLORzw9YzYCu+RepydtPSJQ6IUaWDUjRaMdU
	 M0DGGfyCAxH4wGJeb/nHlZmI+i6Ic9sKO0+h66BkNeJCl9ljkZGzpVT3sor2p3bawY
	 fc0dLOHeXjbooIgly+Ou9OX2c6TLXKWZiVAIBDmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhi Liu <hyperlyzcs@gmail.com>,
	Kumaravel Thiagarajan <kumaravel.thiagarajan@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/267] misc: microchip: pci1xxxx: Fix a memory leak in the error handling of gp_aux_bus_probe()
Date: Wed, 19 Jun 2024 14:56:55 +0200
Message-ID: <20240619125616.454773104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongzhi Liu <hyperlyzcs@gmail.com>

[ Upstream commit 77427e3d5c353e3dd98c7c0af322f8d9e3131ace ]

There is a memory leak (forget to free allocated buffers) in a
memory allocation failure path.

Fix it to jump to the correct error handling code.

Fixes: 393fc2f5948f ("misc: microchip: pci1xxxx: load auxiliary bus driver for the PIO function in the multi-function endpoint of pci1xxxx device.")
Signed-off-by: Yongzhi Liu <hyperlyzcs@gmail.com>
Reviewed-by: Kumaravel Thiagarajan <kumaravel.thiagarajan@microchip.com>
Link: https://lore.kernel.org/r/20240523121434.21855-4-hyperlyzcs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c
index de75d89ef53e8..34c9be437432a 100644
--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c
@@ -69,8 +69,10 @@ static int gp_aux_bus_probe(struct pci_dev *pdev, const struct pci_device_id *id
 
 	aux_bus->aux_device_wrapper[1] = kzalloc(sizeof(*aux_bus->aux_device_wrapper[1]),
 						 GFP_KERNEL);
-	if (!aux_bus->aux_device_wrapper[1])
-		return -ENOMEM;
+	if (!aux_bus->aux_device_wrapper[1]) {
+		retval =  -ENOMEM;
+		goto err_aux_dev_add_0;
+	}
 
 	retval = ida_alloc(&gp_client_ida, GFP_KERNEL);
 	if (retval < 0)
-- 
2.43.0



