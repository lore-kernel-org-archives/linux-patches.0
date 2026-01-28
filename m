Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9636C0B9;
	Wed, 28 Jan 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614062; cv=none; b=PZ79Bsoqk7d4tMyNGWZaVKi7I5wuPGYpcMKRvkIMsswUlSfHSBl22P4Gis9q9nAUxOAIimXyjHJ9JJWZDky6dh7XCPCVUIRI418wKJ2pBTWWtovROlqMz25Em6TEOHqVT59w8X5JakbckFA6+R3Aand843JS1j7rDefNj+2WDzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614062; c=relaxed/simple;
	bh=+8KKHg3RqrMoJPsVchGO4kAMrTDzujK/y93Q8EmmOwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6632cND//+gHLihU4hEKONrzH2Zs63eBkNbwtEgTG1a67AiFSIqQ9fe6hVNVfjYjteW2oGUGhD3eR62yDsv7AF6HrXfbKkGebuXQXPqIGU49grtm/rUh+nEoDaLtkxlpTvRBy2KsAu9HH0BFCfyd1cUVzfHoQY1dL3JMLoeviQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dzd9Dhlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dzd9Dhlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB7C4CEF7;
	Wed, 28 Jan 2026 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614061;
	bh=+8KKHg3RqrMoJPsVchGO4kAMrTDzujK/y93Q8EmmOwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dzd9DhlhjcuRbqaRQ5CSpu8JwoWw29k/Vb8k8Y1AlsBJAA1oX9bQ4Yihlx92S3eYk
	 C20rwrqoUlSeiY5kIzb15kyQK7f3Lb74eA8lSXwrEfSAUjCMUwFCsvfInfdIUqC3js
	 ItoE/zsxq9ZDoqtSiV7t3NLyqrEHZDVQKVMxk/eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/254] net: hv_netvsc: reject RSS hash key programming without RX indirection table
Date: Wed, 28 Jan 2026 16:20:00 +0100
Message-ID: <20260128145345.574772217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit d23564955811da493f34412d7de60fa268c8cb50 ]

RSS configuration requires a valid RX indirection table. When the device
reports a single receive queue, rndis_filter_device_add() does not
allocate an indirection table, accepting RSS hash key updates in this
state leads to a hang.

Fix this by gating netvsc_set_rxfh() on ndc->rx_table_sz and return
-EOPNOTSUPP when the table is absent. This aligns set_rxfh with the device
capabilities and prevents incorrect behavior.

Fixes: 962f3fee83a4 ("netvsc: add ethtool ops to get/set RSS key")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1768212093-1594-1-git-send-email-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index aa114240e340d..af001e2e688b2 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1762,6 +1762,9 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
 		return -EOPNOTSUPP;
 
+	if (!ndc->rx_table_sz)
+		return -EOPNOTSUPP;
+
 	rndis_dev = ndev->extension;
 	if (indir) {
 		for (i = 0; i < ndc->rx_table_sz; i++)
-- 
2.51.0



