Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B51DF24E;
	Wed,  6 Nov 2024 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895273; cv=none; b=kFN0wv4105/gS69gUZVcOHQ8OL6p0ZhkQ8HDmrox8hF2oMKFUlfKqwmWdI0/e7mzxoBeMXVynsbj47Hhh8vFBwvzWjZj+TK+gvi0AIDbZQ8uXD1KoWkDXpkzOgBa0wyezWA30EDNJn4Jl9IGCTiiui9yDOcIv37XNWhQluXHi+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895273; c=relaxed/simple;
	bh=hk6N5AncAHChmPCXGRiHstbr9gXkj6ajwyO/npDOX8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blbXUcD08cyopDEFLGdOGB0wed4uWpa8jiyFCS45mMF+jGFepriMjYVui1GgSiIlJivbUa311MVisgR2D/v2BMj+jzEaFcnKnZQBwE1UMxbGPIL1IsiPFAkRi0EF+dKYD710+uwmFElkwcT+lv/IN7UoATRfXiLw6eNmV4xCrb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VC2WymeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VC2WymeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35695C4CECD;
	Wed,  6 Nov 2024 12:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895273;
	bh=hk6N5AncAHChmPCXGRiHstbr9gXkj6ajwyO/npDOX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC2WymeQ+05uZmokCbC/AkxzhAvv3LuAI6SL8s0gLRLDV3OH+xQEuF9YB1mhlk9wC
	 WOz1lobBjqCxSU5ZZHPOSagRKYLJp+ZfsJ4rKsUd7lauTnAdmq9yP3LO3szSwaqxKv
	 FE+dWW4JKq60ZdjyvncfeKOyxllkqbtoom4c6bzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/350] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()
Date: Wed,  6 Nov 2024 13:01:29 +0100
Message-ID: <20241106120324.897049771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 498365e52bebcbc36a93279fe7e9d6aec8479cee ]

Replace one-element array with a flexible-array member in
`struct host_cmd_ds_802_11_scan_ext`.

With this, fix the following warning:

elo 16 17:51:58 surfacebook kernel: ------------[ cut here ]------------
elo 16 17:51:58 surfacebook kernel: memcpy: detected field-spanning write (size 243) of single field "ext_scan->tlv_buffer" at drivers/net/wireless/marvell/mwifiex/scan.c:2239 (size 1)
elo 16 17:51:58 surfacebook kernel: WARNING: CPU: 0 PID: 498 at drivers/net/wireless/marvell/mwifiex/scan.c:2239 mwifiex_cmd_802_11_scan_ext+0x83/0x90 [mwifiex]

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/linux-hardening/ZsZNgfnEwOcPdCly@black.fi.intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/ZsZa5xRcsLq9D+RX@elsanto
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h   | 2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 3e3134bcc2b06..bfa482cf464ff 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1590,7 +1590,7 @@ struct host_cmd_ds_802_11_scan_rsp {
 
 struct host_cmd_ds_802_11_scan_ext {
 	u32   reserved;
-	u8    tlv_buffer[1];
+	u8    tlv_buffer[];
 } __packed;
 
 struct mwifiex_ie_types_bss_mode {
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 4f0e78ae3dbd0..0cbdd5a930d83 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2570,8 +2570,7 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 	ext_scan_resp = &resp->params.ext_scan;
 
 	tlv = (void *)ext_scan_resp->tlv_buffer;
-	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN
-					      - 1);
+	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN);
 
 	while (buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 		type = le16_to_cpu(tlv->type);
-- 
2.43.0



