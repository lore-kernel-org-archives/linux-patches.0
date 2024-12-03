Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972371DF981;
	Tue,  3 Dec 2024 15:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240847; cv=none; b=t+GT1/Zbo3NdtfaoAjy0Rp9a7RVVzp/SRYqz//+wYG1seYnWU63FqOQWQbRay05C1FQlCz0lXu/T9ryd7Ea/4j1yTEUQUWU0OZbny5DAPKTsg3H8Jfdv1s74Hh9XsWq+mKwfxr2pv/QjX/fXfeBlWde/MGt4FpnBfThjDRZbq64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240847; c=relaxed/simple;
	bh=L1bTYKkiozqEd1WDiorwtX1IlH5VQP5snOcUtijPgxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHEM0lSG/XuKB42PeazUCNRREjXLvvc/F8GmyUP1WKJTP1f9PLWc7RHTY0Xau44zLLBIlR3CCsoXAUp3IL4XIaZgqk472s6c2r3EuB31rRNC4X2MBNeuvrPe0m0pZEW/Qp2t9NAjTq0IwZoxZq3IYTfzkjKf38Op/bah3nDYDv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFF4c1JJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFF4c1JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D955C4CECF;
	Tue,  3 Dec 2024 15:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240847;
	bh=L1bTYKkiozqEd1WDiorwtX1IlH5VQP5snOcUtijPgxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFF4c1JJqTsff5i3Ev5K3ZoSSJ79rwTy/0vOYu5LA+7quWAPPAPziUEXz+VeIUE2d
	 GtMSmXUdF9rFceyal1NHeUniGJuddQvW14UVTzkW0UQDO8mTdQdpEcVKe4LQvK413f
	 GAggIj1FItvlXRtNKCDe+gxIH//7fOUEOv0nf4NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/826] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()
Date: Tue,  3 Dec 2024 15:39:40 +0100
Message-ID: <20241203144753.636078414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alper Nebi Yasak <alpernebiyasak@gmail.com>

[ Upstream commit d241a139c2e9f8a479f25c75ebd5391e6a448500 ]

Replace one-element array with a flexible-array member in `struct
mwifiex_ie_types_wildcard_ssid_params` to fix the following warning
on a MT8173 Chromebook (mt8173-elm-hana):

[  356.775250] ------------[ cut here ]------------
[  356.784543] memcpy: detected field-spanning write (size 6) of single field "wildcard_ssid_tlv->ssid" at drivers/net/wireless/marvell/mwifiex/scan.c:904 (size 1)
[  356.813403] WARNING: CPU: 3 PID: 742 at drivers/net/wireless/marvell/mwifiex/scan.c:904 mwifiex_scan_networks+0x4fc/0xf28 [mwifiex]

The "(size 6)" above is exactly the length of the SSID of the network
this device was connected to. The source of the warning looks like:

    ssid_len = user_scan_in->ssid_list[i].ssid_len;
    [...]
    memcpy(wildcard_ssid_tlv->ssid,
           user_scan_in->ssid_list[i].ssid, ssid_len);

There is a #define WILDCARD_SSID_TLV_MAX_SIZE that uses sizeof() on this
struct, but it already didn't account for the size of the one-element
array, so it doesn't need to be changed.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241007222301.24154-1-alpernebiyasak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index d03129d5d24e3..4a96281792cc1 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -875,7 +875,7 @@ struct mwifiex_ietypes_chanstats {
 struct mwifiex_ie_types_wildcard_ssid_params {
 	struct mwifiex_ie_types_header header;
 	u8 max_ssid_length;
-	u8 ssid[1];
+	u8 ssid[];
 } __packed;
 
 #define TSF_DATA_SIZE            8
-- 
2.43.0



