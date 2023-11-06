Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B920320
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6lFDdsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49099C433C7;
	Mon,  6 Nov 2023 13:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276165;
	bh=t91FtmvjkprEn8lATo8hHEh51PqFtMhWuO7JeM7wQwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6lFDdsUyKpvCV/tg9ouyoZ5tGP/oFRzVZVMIfLDnUGW62KrzSSr9MEneZC3uYrxk
	 V51KKjlQ+fimiEsy5w7AN5L51BOw3fvY981jnV7eq9CXgzZhBc+gTxRRwllXuHOKLX
	 KlLPGqdwAFG53L7DXzpEyn9W/u8h3wM+0K1W0xwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 4.19 12/61] igb: Fix potential memory leak in igb_add_ethtool_nfc_entry
Date: Mon,  6 Nov 2023 14:03:08 +0100
Message-ID: <20231106130259.983051542@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

[ Upstream commit 8c0b48e01daba5ca58f939a8425855d3f4f2ed14 ]

Add check for return of igb_update_ethtool_nfc_entry so that in case
of any potential errors the memory alocated for input will be freed.

Fixes: 0e71def25281 ("igb: add support of RX network flow classification")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index e19fbdf2ff304..f714c85c36c50 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -2994,11 +2994,15 @@ static int igb_add_ethtool_nfc_entry(struct igb_adapter *adapter,
 	if (err)
 		goto err_out_w_lock;
 
-	igb_update_ethtool_nfc_entry(adapter, input, input->sw_idx);
+	err = igb_update_ethtool_nfc_entry(adapter, input, input->sw_idx);
+	if (err)
+		goto err_out_input_filter;
 
 	spin_unlock(&adapter->nfc_lock);
 	return 0;
 
+err_out_input_filter:
+	igb_erase_filter(adapter, input);
 err_out_w_lock:
 	spin_unlock(&adapter->nfc_lock);
 err_out:
-- 
2.42.0



