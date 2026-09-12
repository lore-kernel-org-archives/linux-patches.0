Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF072F617C;
	Sat, 12 Sep 2026 12:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215602; cv=none; b=EaMRXpLvC9FzfWAA1JCdFeup3zHaauyZtoc6IbTq0oi6Ay8hOw19gZIZDLjd3uqu8hXC6j/Rwj/dxewmXjyIxL67a1wOC0MRtyt6MK9ej6aJyKr4ExfujbYolCXk+s1AV0lDAR6ee8YbLxBOFeMC0K3ln07xvcyCie23bq1xI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215602; c=relaxed/simple;
	bh=2T55zjMWaIhifd6DwLaONUKsmeYnoB0lgLZRMTvDPio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BisERkvTEo2dMHLEFNIr8+rxoHiyK1+Kcfo3ElOLQswBsEOAU5QmLBk1mM/g5+r9J+NJ/BCUbhY2QU161LlVG7sX/XXRtQdrEpnyLWYjCB6BBMZoEkKwJa4uJm0AquvhlY5tjF3zu0aAQ/p4rMDnKc/5Mh8oIj43dWdaVatCa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjNHziQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjNHziQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313341F00893;
	Sat, 12 Sep 2026 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215601;
	bh=lo2fgAHpKFJm/18m83dCjjkJbG2MSL2+ZzRwZSYn34A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjNHziQhn/fF720F5MBGBS/lrvqEEI+YMaXveId3XorEKlbOgC4kFuCXKtObZqSfr
	 t+mclviqQHTGyrTpPZ/iAubV1suOwMI3OobagvsuCmjiURri78TAo7plmipKlf/Y3E
	 0arAYQ+hTIzBFkMJdAdQaAnx0ouy0E2ttSFyGy64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0512/1376] RDMA/hfi1: Free RX data on late probe failure
Date: Sat, 12 Sep 2026 08:48:58 +0200
Message-ID: <20260912065618.948361807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 8e17e101e04a3dc062e2719da57ff78c1c060632 ]

hfi1_init_dd() allocates the shared AIP/VNIC RX support before returning.
If hfi1_init() or hfi1_register_ib_device() later fails, init_one() tears
down the device data without calling hfi1_free_rx(). This leaks netdev_rx
and its dummy netdev.

Free the RX support after IB unregistration and before postinit_cleanup(),
as done on normal device removal.

Fixes: 4730f4a6c6b2 ("IB/hfi1: Activate the dummy netdev")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-7-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index e84616bc4fa99..d6331f90222d8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1678,6 +1678,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
+		hfi1_free_rx(dd);
 		postinit_cleanup(dd);
 		if (initfail)
 			ret = initfail;
-- 
2.53.0



