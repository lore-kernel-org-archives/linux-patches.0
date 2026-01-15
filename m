Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CED72D94A7;
	Thu, 15 Jan 2026 17:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498981; cv=none; b=YCbmw1HOKPOwxqbIknRLQ4x3zmbvebItCuNdvZOrA2eduBQ681F/VldB6a7t3V9P4CgO/FLa7DSuZQdQmicUWfkkYdomIo+5+2HI3+BOpEMHYdaxaft0ywI2aUwHZr62iRdb52RTLl/sjo9zYpft6RiRkHs2WWsgycdg+dhY1bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498981; c=relaxed/simple;
	bh=g1u/u/U1TQ5ui0onGY3Dnnw22E8ymj42Jc+QEFFmu1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMFNdBrETl/WPHGr0B2Igc3OJFN6pY3WPQnVr012K4z5JkVIobCfr86884Y4ERMI2c033fkIJy1hKy3AiCm5KfBjDCEgjtDfEVLMaLsAAHLGZJHijktHZOsMJjh1V2XGGPWRDGFk2WGOAHdTNyx4g79kkfFO8KprJ8se6vdcOBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyekQ/a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyekQ/a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9110C116D0;
	Thu, 15 Jan 2026 17:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498981;
	bh=g1u/u/U1TQ5ui0onGY3Dnnw22E8ymj42Jc+QEFFmu1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyekQ/a39nw0cgW1/wozGPW7yeerPvkSEsVBaYlAw4VJ7oLXkGXGqrzSnXaYmEnd8
	 dmhPk2K9vsHjflfhVtoWQQO5d+61V/JZuHxzygnOFu6+eM8SGUQXwW61AK7NgZYrkk
	 i2zL53hZ+7BP4hPRki6q9qL+fMyzqcNrlJM97K2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/451] wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()
Date: Thu, 15 Jan 2026 17:44:28 +0100
Message-ID: <20260115164233.325936744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 5e88e864118c20e63a1571d0ff0a152e5d684959 ]

In one of the error paths, the memory allocated for skb_rx is not freed.
Fix that by freeing it before returning.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251110175316.106591-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/bh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 361fef6e1eeaa..61916e202f20b 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -320,10 +320,12 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 
 	if (wsm_id & 0x0400) {
 		int rc = wsm_release_tx_buffer(priv, 1);
-		if (WARN_ON(rc < 0))
+		if (WARN_ON(rc < 0)) {
+			dev_kfree_skb(skb_rx);
 			return rc;
-		else if (rc > 0)
+		} else if (rc > 0) {
 			*tx = 1;
+		}
 	}
 
 	/* cw1200_wsm_rx takes care on SKB livetime */
-- 
2.51.0



