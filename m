Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFD037AA87;
	Mon,  9 Feb 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648140; cv=none; b=lvIxLT8+dgD0bGYe1BEpTqt0PAiHWVjXxJ3XaCObZbMulyHbFLC4ZI2fQpluh97z0rfRTVdvlNy6LmYxUSOgkwoCRSEjkMi5Ywf2mGOSDh5//cYzv5khJynBU9yth1fwFgiuFx124foBDBEZBROn+5Ju4YnTPibt1EeSH++G6rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648140; c=relaxed/simple;
	bh=AMH0PTzntOkVfhfpMUZ+uR32JSWNpZQFSpTQkwdVriM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcA+d9Jr8ixkJrypicMb3B/NkF4o/0SYC7saNa9pKBepGrOJYIHWdyDzQrwqXixQ74MyjbT+/gBW0s7WgZv/Ps5/1Z3GCRiK6vaBhgEEjxUUgGeBxV0CBJnf7QA6jG8N5q7yiDU86zTuVLCFcm3VFqRLnrEmF/+TuOKGwKOwl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMNw+6g5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMNw+6g5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6416EC19423;
	Mon,  9 Feb 2026 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648139;
	bh=AMH0PTzntOkVfhfpMUZ+uR32JSWNpZQFSpTQkwdVriM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMNw+6g5YpFlS6gCig13FzagnHrGGiioCrLA5Goh6UyxyNvaY18wgB5Bd/dMc0etR
	 LH96LPXYnIAUIRblZRiZRXymOMLyZyoXZxk+s7X/pcxVIgkdATHkFWaTA7DPT4mWt0
	 NOZpNymggdeYm3ezw2OfScaUBLKho3XRBM4Fkj3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Astrand <astrand@lysator.liu.se>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/69] wifi: wlcore: ensure skb headroom before skb_push
Date: Mon,  9 Feb 2026 15:23:47 +0100
Message-ID: <20260209142302.620834831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Åstrand <astrand@lysator.liu.se>

[ Upstream commit e75665dd096819b1184087ba5718bd93beafff51 ]

This avoids occasional skb_under_panic Oops from wl1271_tx_work. In this case, headroom is
less than needed (typically 110 - 94 = 16 bytes).

Signed-off-by: Peter Astrand <astrand@lysator.liu.se>
Link: https://patch.msgid.link/097bd417-e1d7-acd4-be05-47b199075013@lysator.liu.se
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 7bd3ce2f08044..75ad096676561 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -210,6 +210,11 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	total_blocks = wlcore_hw_calc_tx_blocks(wl, total_len, spare_blocks);
 
 	if (total_blocks <= wl->tx_blocks_available) {
+		if (skb_headroom(skb) < (total_len - skb->len) &&
+		    pskb_expand_head(skb, (total_len - skb->len), 0, GFP_ATOMIC)) {
+			wl1271_free_tx_id(wl, id);
+			return -EAGAIN;
+		}
 		desc = skb_push(skb, total_len - skb->len);
 
 		wlcore_hw_set_tx_desc_blocks(wl, desc, total_blocks,
-- 
2.51.0



