Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23AB21FF2B;
	Mon, 23 Jun 2025 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716171; cv=none; b=u+jM5IJwjz25lPgKMuUiR7aZArzTs7iupgRMjbZsQBPj/sqHUTlec0TQ6fGcD6TvKbQngE4HoBYumVnAhrTF6y5KBhUMDHXpxw7P8MdhIHBHP/Stdp2gmTIRzFm0Pn1OgYXj1rGOpYvpdJ/ag8B+k69ASYMe/ElLAWkkbXb7tEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716171; c=relaxed/simple;
	bh=nvYjcQbW3ECYyoKt1DvWUly9gRI1+R9H7umetynyqJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMXQJ5vglnkNctHuVPM8435f3R6oIkkGsQc6NSr/xU3KMhwePwNNue+QWDSi1sxxqs3Qj6QBG1dea7p4YJbQ7MrqW1o0cZZMdbRHncn5Ssgx3sT0+OKO25tMy2r+rmsJI+63WcA2NCUngKfhrUzF0egqxmI078y1DhRaFSp9YVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alsblGCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alsblGCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC3CC4CEED;
	Mon, 23 Jun 2025 22:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716171;
	bh=nvYjcQbW3ECYyoKt1DvWUly9gRI1+R9H7umetynyqJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alsblGCHQG9TbzoniUS/hwqDnPpG9AVoFq5oUX95wXduBiDoX0dR6luJKoVBbwVTj
	 e4381tNTCMQLN9e7ZLDcGwnbcWD9FRCndcxrwQFOfqWCFwbpkwZInaQmC7y2kb6itA
	 8PxjX4XKFwXSaBxW2rsNjuwiIc3ZiPj03AX5RELg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liangliang Zou <rawdiamondmc@outlook.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 306/508] wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723
Date: Mon, 23 Jun 2025 15:05:51 +0200
Message-ID: <20250623130652.840558551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingcong Bai <jeffbai@aosc.io>

commit 77a6407c6ab240527166fb19ee96e95f5be4d3cd upstream.

RTL8723BE found on some ASUSTek laptops, such as F441U and X555UQ with
subsystem ID 11ad:1723 are known to output large amounts of PCIe AER
errors during and after boot up, causing heavy lags and at times lock-ups:

  pcieport 0000:00:1c.5: AER: Correctable error message received from 0000:00:1c.5
  pcieport 0000:00:1c.5: PCIe Bus Error: severity=Correctable, type=Physical Layer, (Receiver ID)
  pcieport 0000:00:1c.5:   device [8086:9d15] error status/mask=00000001/00002000
  pcieport 0000:00:1c.5:    [ 0] RxErr

Disable ASPM on this combo as a quirk.

This patch is a revision of a previous patch (linked below) which
attempted to disable ASPM for RTL8723BE on all Intel Skylake and Kaby Lake
PCIe bridges. I take a more conservative approach as all known reports
point to ASUSTek laptops of these two generations with this particular
wireless card.

Please note, however, before the rtl8723be finishes probing, the AER
errors remained. After the module finishes probing, all AER errors would
indeed be eliminated, along with heavy lags, poor network throughput,
and/or occasional lock-ups.

Cc: <stable@vger.kernel.org>
Fixes: a619d1abe20c ("rtlwifi: rtl8723be: Add new driver")
Reported-by: Liangliang Zou <rawdiamondmc@outlook.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218127
Link: https://lore.kernel.org/lkml/05390e0b-27fd-4190-971e-e70a498c8221@lwfinger.net/T/
Tested-by: Liangliang Zou <rawdiamondmc@outlook.com>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250422061755.356535-1-jeffbai@aosc.io
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -155,6 +155,16 @@ static void _rtl_pci_update_default_sett
 	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8192SE &&
 	    init_aspm == 0x43)
 		ppsc->support_aspm = false;
+
+	/* RTL8723BE found on some ASUSTek laptops, such as F441U and
+	 * X555UQ with subsystem ID 11ad:1723 are known to output large
+	 * amounts of PCIe AER errors during and after boot up, causing
+	 * heavy lags, poor network throughput, and occasional lock-ups.
+	 */
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
+	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
+	     rtlpci->pdev->subsystem_device == 0x1723))
+		ppsc->support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(


