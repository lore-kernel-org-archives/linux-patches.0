Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3B1F7569;
	Tue,  3 Dec 2024 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238445; cv=none; b=LbpcDEVXfKPa7xHCJrjBGKUe5PXfxUmRsNxg8/XkOMAow0irbo5uCuIcT5MUq67pWkCxPv1QP0EzrPIIXxBTKpiCPhwy9GNthdXD8ykVaKj2oyf13AqZ1cx5w8JrjXDEyfWGu6GbsqRrDBpcq16iHLr8U3PeONCv81EXy70ods0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238445; c=relaxed/simple;
	bh=jS5kBIbWgpRJ+u2icoy1SAsg6EKjFLueckwPcv73NhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDcwk0hPS60H69GpYFiaKzpXfqGVL8hhbBL2XUij4D2OC3H0kG5oLWoYK2j6r/4CL0oo8esP+k0N6kG3nYSvFyjzbmz1bWes8GMKWhDjXhZDRHP1gximmz2XYrVe8yMULiITdzOEcxpHWbkwFwfyMBiATm4INK8HmKGwg3UhXu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4wx1ULh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4wx1ULh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAADC4CECF;
	Tue,  3 Dec 2024 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238444;
	bh=jS5kBIbWgpRJ+u2icoy1SAsg6EKjFLueckwPcv73NhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4wx1ULhQqPFk8SCO3muoUReKeYle9DtTRxMsx5BCWvyQIrO83sq5onJUolbEvtLh
	 p8H76CaJxqT1/59VRjoq3WRNTvVdCpsfVIFEwFTeAWqPqwx5nQk/Si+Kmc62KNVuQ5
	 STmqc++FI0CHcT1aCH514EPUP+pZG62HlnoKaq3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 280/817] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()
Date: Tue,  3 Dec 2024 15:37:32 +0100
Message-ID: <20241203144006.736003171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5b072120e3f21..324efd55c8e4f 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -842,7 +842,7 @@ struct mwifiex_ietypes_chanstats {
 struct mwifiex_ie_types_wildcard_ssid_params {
 	struct mwifiex_ie_types_header header;
 	u8 max_ssid_length;
-	u8 ssid[1];
+	u8 ssid[];
 } __packed;
 
 #define TSF_DATA_SIZE            8
-- 
2.43.0



