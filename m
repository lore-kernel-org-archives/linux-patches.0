Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24793229676;
	Thu, 12 Dec 2024 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019247; cv=none; b=Jcyv1Vl8qiqhuu1ne+52u2lRjzj0su0ktFV3BfXRjLSscm6R/eNa5O4NTAJCPLaxn2yfwxtF8os7gX/EWDMZu8j9Vb3jIaKdSb5t2oblotpDmC6fnhE46aAQltHHA8W+1B55mNzx8JTq+4BRONyj9iiYs/4WCXOGAGd1u8Za6Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019247; c=relaxed/simple;
	bh=70/seDV07+hZNSpMao6+ncHRfpfg17KNIxzrn8dK2s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUBWcf5z9fM1Vpt7azolA4GkqqPdd4SCLFK8zEUy4MZcRVUpte5SQI/A87/fSSBbm8wIi3zCEQjeXWBBf+B+CZMbwcfdNHcGnhf1YMR0etjTtPnw2lsNPeyi4hKgDdC/Fg2N77cooXviiw3IQswn23xJRZPnsNSM88eDoOTw1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbhyFbw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbhyFbw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF56C4CECE;
	Thu, 12 Dec 2024 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019247;
	bh=70/seDV07+hZNSpMao6+ncHRfpfg17KNIxzrn8dK2s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbhyFbw+VoWzG/2QxE+LtjMSzogXNcK3ftxZreOStpm5Bola54U4zuSJSDKrsBVQL
	 xivdN1Kl9+vWG1ckyKXW1Dg2AZ4C3RuFjuochBqOkbTz1ZQsZtSaUi1bw+hcMPZUDg
	 AEjDHhRv7PaKq2r+hnMZYhIfFpwmgm+A/Blq1wCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/772] wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_config_scan()
Date: Thu, 12 Dec 2024 15:51:41 +0100
Message-ID: <20241212144356.382479421@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 26979013ca52d..9c9fe5757b295 100644
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



