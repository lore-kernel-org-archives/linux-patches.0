Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062083;
	b=BIJ94qtdDoM15QN7DMZwZjSNJNZ1CqAYe04PlZgz+dWBlVvZKb3Nk+aL6zIjUkOu25H/
	 LR9QWUuP9P1v+A0RRuyiSBr4Jg+kYt1MDJO1M0zt6P5D+kU2PFKfp/Nt7DvzNobiXUTVa
	 lZuQgh0WngZf3jfIT3K/dqlMulSaM1Zs9so2gxs3q1op170UpKnXp9o0Q75Iy0Taj3pGn
	 rhTvcr4RFNsth+jiREGMXv1K1fkfHkrH7wrMyOesbzMFWIHKezHcTWSxJ6SvbhDSR4nLP
	 OG4DgwvxQtMRor1uwjmKVH6VEHVeA30sczD7kGLiFeAosmCWF4mJ3Q7GLhLoTvEQLjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mjKpz82K9TxD3jBro2nTcMFJUf6RZHvmuih02BJ93k=;
	b=BPhhJ2/Fr/xTVnNJzqxiSDU0yy0gfWFHlpVKPI4S+EDIWGieFZRZERMIs+EClkgsFtZF
	 b0+xkqZ9F/2AlJpOk2IDb5TGBoWVXQnOPbWp4JwBkxqsTWTC7n1gZdHhPdH0eVEq3uFrO
	 FeeV1xu7CF3z8sF2Go5FEpErrlrGcczuDYMySjiVus1rHDWaVenhWeGtGXAjEuAFRgOy1
	 5xUZYVWynJE0K++g9IFARsBxpLWfk19Z4iH8RAP6Ryh7dyZyZqQdpXKeA1etfHytITsfZ
	 WLu5dYARyLwOS7BcZvv0Iyua90SDSjBL4InT9c5/13oSd/TckshArOf052+kidT4aNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkJ+eq4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB0E606EEBF;
	Sat,  7 Nov 2026 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkJ+eq4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ECF1F008A2;
	Sat,  7 Nov 2026 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062083;
	bh=4mjKpz82K9TxD3jBro2nTcMFJUf6RZHvmuih02BJ93k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkJ+eq4iCmAQncqwS8Y9NABfE6UITIxR2pE8tuEwKjLG8f1sUAjQ/gwD2U4mBvcoC
	 dHkfmlRTOrCuvCCX1cL5GdqIoxlObOgD8lIlaP/BKqhdZ7dmCgbsMh6R2ImNPnCkGQ
	 huvHptrgImZgIvGt7F0ie6mv2yYQie4jN8b9tDAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qzhuo@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1032/1536] EDAC/i10nm: Fix mdev reference leak in i10nm_get_ddr_munits()
Date: Sat,  7 Nov 2026 08:50:48 -0500
Message-ID: <20261107135026.659246309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit f0d8c34b3b5e845113581d7d3b24ddaa61bce1f0 ]

In i10nm_get_ddr_munits(), get_ddr_munit() returns a PCI device with
its reference count incremented.  If ioremap() fails to map the MMIO
space of the memory controller, the function returns -ENODEV without
putting the reference held by mdev, leaking it.

Put the device reference before returning on the ioremap failure path.

[Tony: Dropped the Cc: stable tag]

Fixes: c545f5e41225 ("EDAC/i10nm: Skip the absent memory controllers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qzhuo@nvidia.com>
Link: https://patch.msgid.link/20260916091251.1997522-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index c2157c5e84b3b..6697df5b4af55 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -741,6 +741,7 @@ static int i10nm_get_ddr_munits(void)
 
 			mbase = ioremap(base + off, size);
 			if (!mbase) {
+				pci_dev_put(mdev);
 				i10nm_printk(KERN_ERR, "Failed to ioremap 0x%llx\n",
 					     base + off);
 				return -ENODEV;
-- 
2.53.0



