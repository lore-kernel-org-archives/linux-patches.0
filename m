Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17212237163;
	Mon,  2 Jun 2025 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876279; cv=none; b=MKOIQhoQgN3YKS4+X260BkBT8MCOfhDCg8bA4jrxuoIwPCIs2NPvs6Aa0GYPN8u+DULx0qXV+s347dzif2gDoJSXj4ca3WAm/cFbrrnEn4620qPwNOK8XCUomD6aC9k3rEfek9GTRul/Ykt/gTip+csqKrVD+UiCEFZo7zRUygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876279; c=relaxed/simple;
	bh=5PGn2TVh/Ajphn5oeBaYNWgI0cMOwvLtFXkrdU+LSio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuND0I0xE3vVmpfbdAWLPiMdj7cHCPwrBQ97KKzzKWnlg+8mMNYYZimkiM3RaFu4rSXahJfrrgw65cZw6UD2CroZqtYClzqnTj+N/EJr9XGwhMDkenXHWYNAp4dLA/7mkcXdujqdv+gv90ln/EMn1XOfbE4V2X0v2BcAunBUQrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDckLJwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDckLJwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B58FC4CEEB;
	Mon,  2 Jun 2025 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876279;
	bh=5PGn2TVh/Ajphn5oeBaYNWgI0cMOwvLtFXkrdU+LSio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDckLJwXkUuP/IszHBe58WkIETU3q1PNTlma+WSn1uxDPkm7xZvZmnQA4nhSEfBZY
	 OFjVxccuAP5hpNtqiaIZ8F6nNKez/jdtOz8XojOzoPpHbojlG4kE/NXzPLN5t38zrY
	 W1o9+aRf7ONpT/1jpCG4+8wPJMX/1xkk5s3q5v28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/207] wifi: mac80211: dont unconditionally call drv_mgd_complete_tx()
Date: Mon,  2 Jun 2025 15:48:20 +0200
Message-ID: <20250602134303.722409918@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1798271b3604b902d45033ec569f2bf77e94ecc2 ]

We might not have called drv_mgd_prepare_tx(), so only call
drv_mgd_complete_tx() under the same conditions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.e091fc39a351.Ie6a3cdca070612a0aa4b3c6914ab9ed602d1f456@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b71d3a03032e8..11d9bce1a4390 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2336,7 +2336,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (tx)
 		ieee80211_flush_queues(local, sdata, false);
 
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (tx || frame_buf)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 
 	/* clear bssid only after building the needed mgmt frames */
 	eth_zero_addr(ifmgd->bssid);
-- 
2.39.5



