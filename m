Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD462DAFAA;
	Wed,  8 Apr 2026 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672385; cv=none; b=bJUrVa3rGDNy0829aTFDEiT797WMP89QtVHJes57UUiOrtKJ1xHKpwzz7pJib1WMijqK7PmuCvCmA6T5rFYv8oOxBi6Kb2EH4S0daEJc9OxF+xupNuKnCXHAHDQI6dKQNhJnNGhRSIRhy8tV9MiJln6FHQ/MbIkJNfDBAHO+jpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672385; c=relaxed/simple;
	bh=IdFcjQL3Ka70ATCGALsTa1Ayd6FG2f58j2caq7M8ebQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sibQGHNJ3nwBLr1v5RD/itpV7JIEFRlnh3mw3Xvj+c7nFdjRB9fz9em/7AgeGRjV9XiaavIll7V37kiBfNdVxaYZy1SxUG4tXMna8Ux4cBdxkHvCG+dOYg7BN+QXtAoyDneBYYhqiTXO1MbDmyg2QHaF1r6ZP4MMb19G7LJNOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlbY93mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlbY93mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF10C19421;
	Wed,  8 Apr 2026 18:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672385;
	bh=IdFcjQL3Ka70ATCGALsTa1Ayd6FG2f58j2caq7M8ebQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlbY93mqUiGYSXmJR1F5/tdyin4cyLOrIK7CVvBi8Kh5UOOM+klaGe3C3qp6ithHC
	 x4uNG1kZP52ys+KgxKAZiOXfVRESpksVJ1zpgbgGcc5bnOLgRxWE+EqN8Wd85HQzwQ
	 dpeKMfVLjVv2dVV9VFHWBrlL+GgdcAg2ed9HiISk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 267/312] net: enetc: fix PF !of_device_is_available() teardown path
Date: Wed,  8 Apr 2026 20:03:04 +0200
Message-ID: <20260408175943.720032599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Upstream commit e15c5506dd39 ("net: enetc: allocate vf_state during PF
probes") was backported incorrectly to kernels where enetc_pf_probe()
still has to manually check whether the OF node of the PCI device is
enabled.

In kernels which contain commit bfce089ddd0e ("net: enetc: remove
of_device_is_available() handling") and its dependent change, commit
6fffbc7ae137 ("PCI: Honor firmware's device disabled status"), the
"err_device_disabled" label has disappeared. Yet, linux-6.1.y and
earlier still contains it.

The trouble is that upstream commit e15c5506dd39 ("net: enetc: allocate
vf_state during PF probes"), backported as 35668e29e979 in linux-6.1.y,
introduces new code for the err_setup_mac_addresses and err_alloc_netdev
labels which calls kfree(pf->vf_state). This code must not execute for
the err_device_disabled label, because at that stage, the pf structure
has not yet been allocated, and is an uninitialized pointer.

By moving the err_device_disabled label to undo just the previous
operation, i.e. a successful enetc_psi_create() call with
enetc_psi_destroy(), the dereference of uninitialized pf->vf_state is
avoided.

Fixes: 35668e29e979 ("net: enetc: allocate vf_state during PF probes")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-patches/20260330073356.GA1017537@ax162/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 99422c0b4a265..8cb4c759b165e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1393,10 +1393,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
-err_device_disabled:
 err_setup_mac_addresses:
 	kfree(pf->vf_state);
 err_alloc_vf_state:
+err_device_disabled:
 	enetc_psi_destroy(pdev);
 err_psi_create:
 	return err;
-- 
2.53.0



