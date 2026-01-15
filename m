Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5391A5B9E;
	Thu, 15 Jan 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498164; cv=none; b=D4p4WPJFVU0wGwYxAHe7SLXNKDOlI7wqOa4B6h63tJcyO3wtsQ2gXajw2WpgQq9134ypAmw/CIJXAQzOMn0gtXPnwWg1EG8J/JfXnj/c0QXjUCGqklnhamcuOyxdL0pWUNVSIXUt8ENUebA6H8NVowqEt8j7n50BsBQ6OXODTyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498164; c=relaxed/simple;
	bh=tbWKJ5f2Q46EoqLHA1DCtuXhnk8jQAnBfkdjYlu0NAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbwAobyBah2er8rmH4N0BUmfmpuzkgHa5bmUV0cG0zKqgegJsTIxHjJSFfiLlrQt3QhrsQhms82B3uiOUBTJhh46jEtrfIRe0fVLDtcm0nyCbYhIS2LO2RbWdVhiDvbC2mTRwcwuRLa/3zEi+/f46klorUjUQW0tk0U1lTZSrOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAI2Qtlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAI2Qtlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACDEC116D0;
	Thu, 15 Jan 2026 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498164;
	bh=tbWKJ5f2Q46EoqLHA1DCtuXhnk8jQAnBfkdjYlu0NAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAI2Qtlpj9YD+h0M3/KEqcrRiLV1oLBkdRI/jbfG2KZJ9NiD9UZ/XC6FXoIxUn6Qj
	 H51fHrp5zkho7o7cvLROmoUi/aWnLrKho4YAxJqukOHgdeLKvTOxddOUVJmveKoCwM
	 bblLlPmcfyP/VMKtdFOwz5FohGUGvOQQ2Fe71jyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 335/554] i40e: fix scheduling in set_rx_mode
Date: Thu, 15 Jan 2026 17:46:41 +0100
Message-ID: <20260115164258.356764107@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemyslaw Korba <przemyslaw.korba@intel.com>

[ Upstream commit be43abc5514167cc129a8d8e9727b89b8e1d9719 ]

Add service task schedule to set_rx_mode.
In some cases there are error messages printed out in PTP application
(ptp4l):

ptp4l[13848.762]: port 1 (ens2f3np3): received SYNC without timestamp
ptp4l[13848.825]: port 1 (ens2f3np3): received SYNC without timestamp
ptp4l[13848.887]: port 1 (ens2f3np3): received SYNC without timestamp

This happens when service task would not run immediately after
set_rx_mode, and we need it for setup tasks. This service task checks, if
PTP RX packets are hung in firmware, and propagate correct settings such
as multicast address for IEEE 1588 Precision Time Protocol.
RX timestamping depends on some of these filters set. Bug happens only
with high PTP packets frequency incoming, and not every run since
sometimes service task is being ran from a different place immediately
after starting ptp4l.

Fixes: 0e4425ed641f ("i40e: fix: do not sleep in netdev_ops")
Reviewed-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemyslaw Korba <przemyslaw.korba@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 4c50e18707c7..8f9cbbfec63e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2216,6 +2216,7 @@ static void i40e_set_rx_mode(struct net_device *netdev)
 		vsi->flags |= I40E_VSI_FLAG_FILTER_CHANGED;
 		set_bit(__I40E_MACVLAN_SYNC_PENDING, vsi->back->state);
 	}
+	i40e_service_event_schedule(vsi->back);
 }
 
 /**
-- 
2.51.0



