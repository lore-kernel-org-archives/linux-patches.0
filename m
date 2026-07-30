Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285D32B116;
	Thu, 30 Jul 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424547; cv=none; b=l8pW1aHTXsUT8CekPytxDmVFHMhBCmvVv1vXEkvXML1zhZVzox/1Fr+Br40cUONVLsBxHX0SiDUlrBmP1K0Z4efhW6HVw20+7Vee7+Zoflju7+CMZOMmjDo/utLx2NqFvuKyQ5url3AibhGOsAApCZh9qpPwhjYAdtpETPCxDq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424547; c=relaxed/simple;
	bh=8l5rG4z5o/QuO+ehRIahBFoLptR+b1aSdq8DGXOmgzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XABl1bfYf+zwriHhJfBqP5LCuy2csASHM8zBP1ASzVYoDXJYuvdc1r/1+O4rZ7GLlsSLpC0dkSeUdf46GKcJvXJDcpIMM7C2eJr2kMcSnzXEV7wa3znT30EbrJmUd4m3qWHiXMKpDu5S74ME3vciWaA+F96tC6Jpo+btp8M8LOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AblZ0jBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AblZ0jBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027901F000E9;
	Thu, 30 Jul 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424546;
	bh=0ZzMJTKVPmFPl0FKTnwKc7v25q06t7Typ+4ARx7YCrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AblZ0jBlHIC1JQrxyiEtw/UVEwF2t5exfmrtqtzcmNn8dLY0YSnnPNWFtXvQNVz8E
	 f2UgsTnNtHPezgvTHQ2A9ySUl1fpP2QTGBZ6OB+0gKhJe+7OKZoZ4dPDXRpmjHpw8E
	 I26roxysUP55XUPMcHzwt/v9RPOn31tKPjzhA1Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Cawston <ross@r-sc.ca>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 432/675] media: synopsys: hdmirx: Fix HPD lane hold time
Date: Thu, 30 Jul 2026 16:12:42 +0200
Message-ID: <20260730141454.321674574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit d1162a5adbb5e95953d460b5bde3a04cd4473fe9 upstream.

Increase time of holding HPD lane low by 50ms. This fixes EDID change not
detected by source/display side.

Fixes: 7b59b132ad43 ("media: platform: synopsys: Add support for HDMI input driver")
Cc: stable@vger.kernel.org
Reported-by: Ross Cawston <ross@r-sc.ca>
Closes: https://lore.kernel.org/linux-rockchip/20260209061654.54757-1-ross@r-sc.ca/
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -504,9 +504,9 @@ static void hdmirx_hpd_ctrl(struct snps_
 	hdmirx_writel(hdmirx_dev, CORE_CONFIG,
 		      hdmirx_dev->hpd_trigger_level_high ? en : !en);
 
-	/* 100ms delay as per HDMI spec */
+	/* 100ms delay as per HDMI spec + extra 50ms to cover internal delay */
 	if (!en)
-		msleep(100);
+		msleep(100 + 50);
 }
 
 static void hdmirx_write_edid_data(struct snps_hdmirx_dev *hdmirx_dev,


