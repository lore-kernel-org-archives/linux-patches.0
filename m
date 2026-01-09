Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1C31946C8;
	Fri,  9 Jan 2026 12:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960757; cv=none; b=sFvqtvSO7bXi/NT9giWmPSL4KxXWRk80Db7zDBjblrfLztvLXDG2MXJquBsCaBFLvC73DbUvbDUFKWah01SY51j8m56iz+7i4NDQbNGYsxGg9MYygm2B833GWuwVt8aeGfIV5Upze5u71top/Dmd3BLfGigsgtusAqZaOkYiPag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960757; c=relaxed/simple;
	bh=kq13Au0kcEuX995GN5KoJCQU/62UC9TuI0QGzHegaDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ygih2suMiweZyrHj3eKFl3oaIP20bgB+qsxX60gbHNp3Hns2dOXJQ/A5u1yjWit1JmtZ032ZRNJehCICiVgIkDLyKzwcXu1prdhwes7g9NCvHSCNHHmj8ExPEG6mFZvd7W7f6EeERS+0iBAYv2Fc+bHUkDLJt0947UV6P25KDic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4C9T3XC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4C9T3XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D8EC4CEF1;
	Fri,  9 Jan 2026 12:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960757;
	bh=kq13Au0kcEuX995GN5KoJCQU/62UC9TuI0QGzHegaDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4C9T3XCCdCfWVT80bw6FYw7OzFMRqFX1xztgt1/yE+xfHSI05w/IEDkj8Tmxajv9
	 WcZt4skT0vcPiBsuw+f9OvoOTFgOkQNu3tnvaMrUzirfvd+7VvYsrZKU6UpzYYf8VF
	 kPUk3qnZ7Qda+S6Rg1f99PP4yONfav5FZnhgCHDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Simon Horman <horms@kernel.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 514/737] amd-xgbe: reset retries and mode on RX adapt failures
Date: Fri,  9 Jan 2026 12:40:53 +0100
Message-ID: <20260109112153.335500559@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit df60c332caf95d70f967aeace826e7e2f0847361 ]

During the stress tests, early RX adaptation handshakes can fail, such
as missing the RX_ADAPT ACK or not receiving a coefficient update before
block lock is established. Continuing to retry RX adaptation in this
state is often ineffective if the current mode selection is not viable.

Resetting the RX adaptation retry counter when an RX_ADAPT request fails
to receive ACK or a coefficient update prior to block lock, and clearing
mode_set so the next bring-up performs a fresh mode selection rather
than looping on a likely invalid configuration.

Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://patch.msgid.link/20251215151728.311713-1-Raju.Rangoju@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 32e633d11348..6d2c401bb246 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2036,6 +2036,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 {
 	if (pdata->rx_adapt_retries++ >= MAX_RX_ADAPT_RETRIES) {
 		pdata->rx_adapt_retries = 0;
+		pdata->mode_set = false;
 		return;
 	}
 
@@ -2082,6 +2083,7 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 		 */
 		netif_dbg(pdata, link, pdata->netdev, "Block_lock done");
 		pdata->rx_adapt_done = true;
+		pdata->rx_adapt_retries = 0;
 		pdata->mode_set = false;
 		return;
 	}
-- 
2.51.0



