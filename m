Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5A043F4C7;
	Thu, 30 Jul 2026 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423991; cv=none; b=b28vdCNcLbLwT/9zR+K9PG5DTZE436dSCBjIVQhopGR+IXFO9ZnxXc35/IJASLzbJcpiQbvH7G0yRE2itG4vPfildcTVBoK14VSPL7xzwSiNBDzgPS2wcGy3VMTq0oYB8cOPIwavK5W5NcZJL1Ax/DQ2lGRdSKg1EdS9UXS2ST0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423991; c=relaxed/simple;
	bh=1WYyJNM60xNJ4A8K4zD2TK8mcMrie69rnQrf4UQEUHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNkooAbNVV6fNdiw7d0x/gAi/hvi37aRM4OgssIJIs5Stfb4853WHzrJd8zyU2yiW/ltNYiI1M/LDtStChhfRS7JlNpRFnbBaZehlFhxtqo2Pm/6e/o09/9ESmgorPLhIiZZrK0p+sGEU7DnJXnpj+NizByRmGUHsQnnpYPQ3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4LJKCHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4LJKCHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159D61F000E9;
	Thu, 30 Jul 2026 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423990;
	bh=h6r0LU5GmYBxBpZUrXmVvzw2dom2bpBPaI/tFScgcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4LJKCHHLVlnWplovB4zUIPs98ZO3SO1zwDcK3ugmBhg4JaK8W8nNTqtMWWKoDXw+
	 Zr9V/jhpxzROLaMHjZDBvIlIbvgzEBBrsT2xFT20FT/OgwHqrhWzl2aFIsdmL1IHg6
	 0diZs3UH8iRWybxubnJDeLYtnRQh83teBn9s83FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/675] net: txgbe: fix FDIR filter leak on remove
Date: Thu, 30 Jul 2026 16:09:27 +0200
Message-ID: <20260730141450.173561150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit ecaa37826340520664a4e5522f803ff48fc3f564 ]

Perfect FDIR filters can be added while the interface is down and are
kept on the software list for later restore. unregister_netdev() only
calls ndo_stop when the device is up, so txgbe_fdir_filter_exit() in
txgbe_close() is skipped in that case and the filters are leaked on
driver remove. Free the filter list from txgbe_remove() as well.

Fixes: 4bdb441105dc ("net: txgbe: support Flow Director perfect filters")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260713091911.1614795-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 4d20b178af236b..76d2940a49fae6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -956,6 +956,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	netdev = wx->netdev;
 	wx_disable_sriov(wx);
 	unregister_netdev(netdev);
+	txgbe_fdir_filter_exit(wx);
 
 	txgbe_remove_phy(txgbe);
 	wx_free_isb_resources(wx);
-- 
2.53.0



