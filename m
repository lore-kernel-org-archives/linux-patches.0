Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3E146D53;
	Tue,  9 Jul 2024 11:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524586; cv=none; b=CFNbpnlmTTwD6WHVW4IhGmTBbqWnccLWZ15B22zHS+eC6BqNkPOHwBs49TtgZ+is23QN7SKgKlhk4DMQxtZAtluaTJrTDxoRu4fPWrDZ191MZuyi6VT4sHJ0mxpzJpb4vkzdLv8qRnMKqJIT+gwlVLvBZo50LDZp26q+7Labn9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524586; c=relaxed/simple;
	bh=FzLStpewQBBtVPFtvNHL/2U7xuLql4Q74ac2tambPpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlHm1pPirV6GxsIY3fXpvr4dnKpTBMwLJ3vSzDTd5a7/7Ih6wrDtmA+iMkQi5R+lgqrPRN2hdFqsdk/BmZ3FL7UV9AmtbhlZZh+ELq/BD7twcKFuvVM24+XdUZ8PMUet8idfV26wwJdpgunDnB5cQGNYjL5qnXaQ1OpdqR11Z9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AK82/yqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AK82/yqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981DCC3277B;
	Tue,  9 Jul 2024 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524586;
	bh=FzLStpewQBBtVPFtvNHL/2U7xuLql4Q74ac2tambPpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AK82/yqqwsBLmB54YT00aWqclygOTGi6xNRw8apdrrWYYYahetAOccq8t5nDM4S2C
	 C21dzvR+idaI39oy6bi6eeRycVuv6yhwnI1kKIQG6pP6DwKfpoRMu1jj5+3nFxyq1G
	 V+h6V8w1l81bJ4G9pz4YHpNIXq0jNElXcMwd3fVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corinna Vinschen <vinschen@redhat.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/102] igc: fix a log entry using uninitialized netdev
Date: Tue,  9 Jul 2024 13:09:56 +0200
Message-ID: <20240709110652.659941168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit 86167183a17e03ec77198897975e9fdfbd53cb0b ]

During successful probe, igc logs this:

[    5.133667] igc 0000:01:00.0 (unnamed net_device) (uninitialized): PHC added
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The reason is that igc_ptp_init() is called very early, even before
register_netdev() has been called. So the netdev_info() call works
on a partially uninitialized netdev.

Fix this by calling igc_ptp_init() after register_netdev(), right
after the media autosense check, just as in igb.  Add a comment,
just as in igb.

Now the log message is fine:

[    5.200987] igc 0000:01:00.0 eth0: PHC added

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e052f49cc08d7..d8e9eef195c84 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6679,8 +6679,6 @@ static int igc_probe(struct pci_dev *pdev,
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
-	igc_ptp_init(adapter);
-
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6702,6 +6700,9 @@ static int igc_probe(struct pci_dev *pdev,
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
+	/* do hw tstamp init after resetting */
+	igc_ptp_init(adapter);
+
 	/* print pcie link status and MAC address */
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);
-- 
2.43.0



