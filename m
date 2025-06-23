Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86D1F4628;
	Mon, 23 Jun 2025 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713521; cv=none; b=ZRtSKaUkdlokNj+Y9FzYWjtNNQQgGDvOEHz6YGqTV+1QyvLB4kZ0OZe+Be/AsizpMwcRIX626ovKQ9WwUHuCApPXiYTlsBJrZ/0hrtNA9AlQvn5ogYwGZS4lAvk8vx39ekd+lD546Y3nQWh0CTpd0zAcvDMfPby/eRwLxLmwJi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713521; c=relaxed/simple;
	bh=or7CJwhSCofK74Zyj0Lu2Z1ZYysSGHIhjRJ5j1GfNMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvM5pwtu1mcOIkydHYz0VFOobljF7qzm7fbWl8AEWdqHFCvx/7nqK4juyBwHkxOk8bX8gKcSVdFo/Zvi/Dkv5ww5M8O8OKNd5YDi6SsBq6SSlITt2PI4xKq1N8CJTHnL5MjePQl7jKil2ltzzMxul9K1eDItipk7IoF577hjitc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1Rwf7v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1Rwf7v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13410C4CEEA;
	Mon, 23 Jun 2025 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713521;
	bh=or7CJwhSCofK74Zyj0Lu2Z1ZYysSGHIhjRJ5j1GfNMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1Rwf7v1Gn2Fk8qu63xwJc5HYv3ZYZ00+c8KlM011XGI4l3yUxqNmCwuy0zQwh0Tq
	 sxCJURN+s6o6ZTSOogq1D0MnPNgLbusm4YBStGQtIsuRMIH++PpzmUKdUUfOvcue7Y
	 QfAXqS9MenMgZXA0GNOlITo3csCtT4p2NlDc2M7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liangliang Zou <rawdiamondmc@outlook.com>,
	Mingcong Bai <jeffbai@aosc.io>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.10 170/355] wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723
Date: Mon, 23 Jun 2025 15:06:11 +0200
Message-ID: <20250623130631.819287684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


