Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA54D1DEFE0;
	Tue,  8 Oct 2024 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393277; cv=none; b=nnYM6RP8fGXEDz6p7TXySXZEtDLJJ+ow6tdDcINvBAzdgqtEIHhg7jBXTTFZ420t/2aJ9sryNrptdtaTpOhEsIG4oKBxxICDwkPspSLV6idkWaTL/zbyLxbNjLp2y3fhj5SBvsPaE08W7WCp+Yuf/AGwZ8FEp++PEHWHhZJ7QMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393277; c=relaxed/simple;
	bh=0LC0Yh6xP3W75Wq6iZO1S/VbfYlfgo9C+PbSbwM50C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxv1rBONJupq9+9f1m4CC8I3GKgWT10HUY+/i1yikxrF0XX1WVfvjTCUxKXAO0FF1CCIyFD3Dt/jPM0CRFo+NbJypZeKFeWG9BOohSBUK7ItTfqNPfUpxoVYNpZU6kTyK89UE9NGZOhYE6IArWBCaJ0wbV199RdZ17UxWJCQAWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLLrEK97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLLrEK97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A497C4CEC7;
	Tue,  8 Oct 2024 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393276;
	bh=0LC0Yh6xP3W75Wq6iZO1S/VbfYlfgo9C+PbSbwM50C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLLrEK97WGuahC28hFDPWcCn7pc8BhOrQ6nle2EWhVixg1vpWqIqNqJ8Aw8biQJO+
	 a60bYACG9Blm/V3P3g1LvDEOSdlbwZibgFN/JNm5DHE+PvaMK2ZM+plLDPN8XByF4J
	 iifNVXozSmtyj9AGjCi3IAMMYIo7dUf1RCkRAM1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/386] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()
Date: Tue,  8 Oct 2024 14:05:50 +0200
Message-ID: <20241008115633.577208588@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 62f3c9a52a1d5..a3be37526697b 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1587,7 +1587,7 @@ struct host_cmd_ds_802_11_scan_rsp {
 
 struct host_cmd_ds_802_11_scan_ext {
 	u32   reserved;
-	u8    tlv_buffer[1];
+	u8    tlv_buffer[];
 } __packed;
 
 struct mwifiex_ie_types_bss_mode {
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 72904c275461e..5be817d9854a6 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2543,8 +2543,7 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 	ext_scan_resp = &resp->params.ext_scan;
 
 	tlv = (void *)ext_scan_resp->tlv_buffer;
-	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN
-					      - 1);
+	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN);
 
 	while (buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 		type = le16_to_cpu(tlv->type);
-- 
2.43.0



