Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E541B371;
	Wed,  4 Feb 2026 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217073; cv=none; b=AJbI7RcUSRM6zIaKzUQzZSl1wYdDHT5gZB9A/wWaFxNTXWXosz3oqQARVeX/0nbWlVwVXTkqiwE6VGUfmoGrOG23rQmcPHEFbnMFUiuMduylqfBTPLF56LMbeuCnsjcWYLsWpIjkdEjy2MNdy8NcDSF9eqNxSr7rucKh44LQu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217073; c=relaxed/simple;
	bh=+iaebYaFgedcx4rSDcQA/l4sHbI70figFNC5swhRnIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEyBjCQJb3dUC7kR+jZd4wbg/gK5ZqdPOodfdW+eC6C9XBoBhse9HYI1zDwwbXirp6zbITfSsYBd/GYotWHubl9cNlDByHbK/9g2uvJu246Nr+uGkWdQWcPaSvVJWGCkbYEvugX24ObVxoRIXLBIbq44TEN7W5T7+1M2/MfB0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InHWBaMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InHWBaMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3F2C19424;
	Wed,  4 Feb 2026 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217073;
	bh=+iaebYaFgedcx4rSDcQA/l4sHbI70figFNC5swhRnIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InHWBaMkbH05ay19XuZle3qjaGDa5eEE4/KqUmJdOg8VFmw3+gZVxSl/FJjmeTs1B
	 GpCHWrpsMVI4rkLjZoxLrCI+iPHZ6Z89+bcfp2mDQLZeeDVQp4LvjjXr0kSHeKt9tB
	 kU8mIcudiIN2V9ciXHwagKwFRnjLheIIIpxqeZVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 115/206] wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()
Date: Wed,  4 Feb 2026 15:39:06 +0100
Message-ID: <20260204143902.344775704@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 2120f3a3738a65730c81bf10447b1ff776078915 upstream.

The "i" iterator variable is used to count two different things but
unfortunately we can't store two different numbers in the same variable.
Use "i" for the outside loop and "j" for the inside loop.

Cc: stable@vger.kernel.org
Fixes: d219b7eb3792 ("mwifiex: handle BT coex event to adjust Rx BA window size")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/aWAM2MGUWRP0zWUd@stanley.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -839,7 +839,7 @@ void mwifiex_update_rxreor_flags(struct
 static void mwifiex_update_ampdu_rxwinsize(struct mwifiex_adapter *adapter,
 					   bool coex_flag)
 {
-	u8 i;
+	u8 i, j;
 	u32 rx_win_size;
 	struct mwifiex_private *priv;
 
@@ -879,8 +879,8 @@ static void mwifiex_update_ampdu_rxwinsi
 		if (rx_win_size != priv->add_ba_param.rx_win_size) {
 			if (!priv->media_connected)
 				continue;
-			for (i = 0; i < MAX_NUM_TID; i++)
-				mwifiex_11n_delba(priv, i);
+			for (j = 0; j < MAX_NUM_TID; j++)
+				mwifiex_11n_delba(priv, j);
 		}
 	}
 }


