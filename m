Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEE924C060;
	Tue, 20 May 2025 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750727; cv=none; b=B583DFT1JMQfGN5frFKotYvkZ3E47ZIQs44cUKRK5JF+qTT5DU8+yDRxsL5Uq8Be/dEGD2K+dbs62Ibi3MBDXwIwHcoblxvJG+FL5rT+W8Yw6QPXyGO+J5b1ALJadxLzqYMOKbd+YdYfjek4VaoNf07T5c812U5Orx9cFXTUyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750727; c=relaxed/simple;
	bh=DXRMk0rz/J7mqFo2Zv12lDICmvQagg9GvnObFuZxnIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIF4vG21bSzCynz8ZO8TQPKtavsu6F+/yuqoB4Oqj8xDh6BiW9d7TmYNKzHlhWzV1QN88eoQWbsNgQVz1+WZdzb7VVp5tJ1ijaHtWkWs7ltAH6TQ5gRvU8k60zj9WZrJVY0buFtpyWfx2hRNnSlavfsRMg7HLglReCmRmtx6V00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zojR0Bmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zojR0Bmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2817C4CEE9;
	Tue, 20 May 2025 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750727;
	bh=DXRMk0rz/J7mqFo2Zv12lDICmvQagg9GvnObFuZxnIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zojR0BmrUuLBfRiXw8GJ8A8m5wZMNLdFOhjgG4BlvNF4ZCJfDREm5CavrmB8OQs7h
	 SDWiYUHjCo1es3ngyWgNPm3Km+e/SP8nWkD8QoJbyPklDepVyi/zwzUrf3KXPMVgyM
	 3xK2Q3fVCuV60fEeOZ5W4f8WgPvfX3A4wsJvAlFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.14 101/145] i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
Date: Tue, 20 May 2025 15:51:11 +0200
Message-ID: <20250520125814.521793819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 1cfe51ef07ca3286581d612debfb0430eeccbb65 upstream.

If navi_amd_register_client() fails, the previous i2c_dw_probe() call
should be undone by a corresponding i2c_del_adapter() call, as already done
in the remove function.

Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.13+
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fcd9651835a32979df8802b2db9504c523a8ebbb.1747158983.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -278,9 +278,11 @@ static int i2c_dw_pci_probe(struct pci_d
 
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
 		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
-		if (IS_ERR(dev->slave))
+		if (IS_ERR(dev->slave)) {
+			i2c_del_adapter(&dev->adapter);
 			return dev_err_probe(device, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(device, 1000);


