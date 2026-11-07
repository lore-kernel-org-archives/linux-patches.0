Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062992;
	b=y2QdjLuupx07VmvOy2X7McsYgpz0iwPfewc9uPF29yBtzbil7bXmxY3/n1v2eaLiTDNh
	 7UMGR2Q2BbRshXhdD/fXNFC2E9JURwaHYAj6kH0064+VCdSs6A/AZDrecCiH48hQnfz7A
	 ts6bPy4pk4L+TNg6UhxmJNYsCjjKVXI27q6ay5llK1bo9k6ATtMFLkRAiEeJDcUWF8BT1
	 111ogiqinTfD+X4Vs858mRSdxB/08+w0qQctopRRrauxwY5k6RiITqHdGgGL6wgIxb7mu
	 zitbjVmW1w4zghG49OcbbuBPii9n+3SCAcKizZnmIldm/QleIGNLTYUv4Y+uo/qvFkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbHgEUbJpraozfh9Bci9HgSPEF3clrx+zIrUrF6Ex40=;
	b=Dj9mb73yYJrlebleewPMMXJcstcze7ZVcxyCoYcAZeGMLb1w0sTwWlCkfYKp/2eCPL/h
	 SSPL1yRHMWxKRJnEnA06K3o26Y36n7Au0Vc61ergtI0TZj8mY6t2gt8xp3F8rLF9dpKS4
	 5GTkZtftQtxpEYZVhlQmq9oSGt6bnlg6JQf41s0qFMyZAbzNmgD+vOTFMc+M+G0hjqhoo
	 iWi2hqeQ0xsIMarLsjC1cvdFwo9E8UQwS87DpNr51CDYhI+OGHyBdat7vBBc0sdlQuFZz
	 Y0NXJGqbRGX/voCRlNLxGufButLe0Bzc/xFs5aBb3vhdUaIqqJSZqjZmegfyINAsC4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I46ArmAz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DD606A330;
	Sat,  7 Nov 2026 14:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I46ArmAz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA61F0089F;
	Sat,  7 Nov 2026 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062992;
	bh=PbHgEUbJpraozfh9Bci9HgSPEF3clrx+zIrUrF6Ex40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I46ArmAzkjCsv9+3tq0DxzQCf/FLAmUZ+EFkqB9GkRja3RXcdsQKIWiMN5BX1hEm1
	 DE6DIc3t8JfonxEx+VLt4TUou9AeYIOvUa0dFmKOYhN5xHtJPW7ryDIhx5sYMk1LRb
	 C4IygywCfC15PMRn8i/m//EPmUnzyIeVBRmJCtEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/869] mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()
Date: Sat,  7 Nov 2026 08:48:51 -0500
Message-ID: <20261107134900.217069195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e6ca524ee5b2705be30ea19ce2e55122d9f9ed8f ]

The PIIX4 PM device reference taken with pci_get_device() is dropped
again before the iobase resource is allocated.  If pci_assign_resource()
fails, the error path calls pci_dev_put() on pm_dev a second time,
releasing a reference that is no longer owned and underflowing the
reference count.

Remove the extra pci_dev_put().

Fixes: dd8e9ed6ed54 ("[MTD] Switch to pci_get_device and do ref counting")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/l440gx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/maps/l440gx.c b/drivers/mtd/maps/l440gx.c
index 85cd273ce0654..1df5ea5fafcac 100644
--- a/drivers/mtd/maps/l440gx.c
+++ b/drivers/mtd/maps/l440gx.c
@@ -110,7 +110,6 @@ static int __init init_l440gx(void)
 
 		/* Allocate the resource region */
 		if (pci_assign_resource(pm_dev, PIIXE_IOBASE_RESOURCE) != 0) {
-			pci_dev_put(pm_dev);
 			printk(KERN_WARNING "Could not allocate pm iobase resource\n");
 			iounmap(l440gx_map.virt);
 			return -ENXIO;
-- 
2.53.0



