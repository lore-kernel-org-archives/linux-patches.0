Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C211A2389;
	Sun,  7 Sep 2025 20:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276310; cv=none; b=mcRKDLgQp3O6iUW5ReBcwNutu5ONCfiS9z7BdiCAsnZsRrm1dgmx4ce/RTVAuIw/jtGoSN4/WlgrIpL7sQN/ne66Mn9xIem1KvdSdCT293xylReAqphlCjaw2jbyikoQrhoBEy8HCux6cs0g7rTl1N152DaEYaJ2mrE0ALlsmGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276310; c=relaxed/simple;
	bh=gS3W3mDP0lslAeUayjZJgePr5IoB1uU+FSyYPoM1WgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhWYyIznZUXWlKouhWHDL1LBpd2CmieWijauraVxm9tTxfqAwng04OkpcYdp4VyPmqepKnzWbdjzjlBjCWhlFZMi1Th4OEwIzJ/kh2WF8TOLPUEFx1uiVrvQSaa4Y0LPsPTBv5IVOke+wAR7JOT3KSq5sQCw94WcKU81hykqZ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjwxBvBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjwxBvBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E63EC4CEF0;
	Sun,  7 Sep 2025 20:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276310;
	bh=gS3W3mDP0lslAeUayjZJgePr5IoB1uU+FSyYPoM1WgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjwxBvBColpukIpiNDHgvbhxZSiH0nowo0SBwlL8eLNsiqRekky5EZKSBuzlM92vd
	 K/nOL9gHOF8VXuNh9aVWO95jLEFmqq4x16J3IxkK8KFE5AmdT90Fv6UngiOMCSKL1W
	 Ny00wytA7QCCwMlpmovFvMoiJbvKx0fwc0jRhcvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/104] i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
Date: Sun,  7 Sep 2025 21:58:18 +0200
Message-ID: <20250907195609.262996262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1cfe51ef07ca3286581d612debfb0430eeccbb65 ]

If navi_amd_register_client() fails, the previous i2c_dw_probe() call
should be undone by a corresponding i2c_del_adapter() call, as already done
in the remove function.

Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.13+
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fcd9651835a32979df8802b2db9504c523a8ebbb.1747158983.git.christophe.jaillet@wanadoo.fr
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -337,9 +337,11 @@ static int i2c_dw_pci_probe(struct pci_d
 
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
 		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
-		if (IS_ERR(dev->slave))
+		if (IS_ERR(dev->slave)) {
+			i2c_del_adapter(&dev->adapter);
 			return dev_err_probe(dev->dev, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);


