Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3608155335;
	Wed,  5 Feb 2025 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764014; cv=none; b=WgtHTHKdnOKlS06/ear8u0pndetWqcffKItAhcJ/KEDH1932o4I6BG5fAJ+PTlb/8aBhv7URq+NcAsp0DdtnfSwXMJgmOnYMvXtH/cKTtVaca9cGRRyWsUqBrmnKx8WvKJg+FuON3kueeeyCGMsSthCxi15+hnZjNRrRKNoyOLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764014; c=relaxed/simple;
	bh=zklDo6FY3GcPZyvsNDsucKr1iBkcHE9rpqFoExIbxTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJdgb2RL9C3VvstmoE/eH/LgBuk5ML76hvHqrgDcQ6q/21MJnpcZuuHj93YSJJElEKrkgUrwkveQxoeWEP/HQcDqfPpj6NbY3wU+3T8bUSNJsLuoFPCyEIKAuZHlu9eDI8oPbm3PqYIKxphIUoeTNggkZXVqNYesYyJHXqK95Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODCzjbM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODCzjbM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F7C4CED1;
	Wed,  5 Feb 2025 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764014;
	bh=zklDo6FY3GcPZyvsNDsucKr1iBkcHE9rpqFoExIbxTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODCzjbM1IVMwJtXjXAV1ZPdYjdoE/rNOk4CoLk8hbIUTM0HjhN41sCiYjksyt7FJP
	 ELAKuD5EkLFPt7JzubsvPxlYJW+AfltrzrBX+OjJOQKF3GRsh6Q9SpCh8DQGqWCTSU
	 UOHCC+0AMwlRr0nVzrn8rjCDJ5hSGrleom5+ORQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/590] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Wed,  5 Feb 2025 14:37:16 +0100
Message-ID: <20250205134458.352917335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit f79bc5c67867c19ce2762e7934c20dbb835ed82c ]

rtl_init_core creates a workqueue that is then assigned to rtl_wq.
rtl_deinit_core does not destroy it. It is left to rtl_usb_deinit, which
must be called in the probe error path.

Fixes: 2ca20f79e0d8 ("rtlwifi: Add usb driver")
Fixes: 851639fdaeac ("rtlwifi: Modify some USB de-initialize code.")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-6-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 8ec687fab5721..0368ecea2e817 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1039,6 +1039,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



