Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B26C3914ED;
	Thu, 30 Jul 2026 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422672; cv=none; b=oe666oSdOlvA6vWE+uJNfgYspsA7ebB95Zp+DPp+wnzo/sLdYZ1/wJBsKLx9TNIPdx1vAWdMk2uFIPp9KTkczuqBqe6v238CCcIdOXKiyRMcA5RxTF49/BCjXrI711vzfaRFIXyzg6CSFoV9s2tMtNU6+Hpr6DFogoiGj3vD4Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422672; c=relaxed/simple;
	bh=qGz5q5IWjFtVbKc6vn4zJPGmy53cKSCDdKsuQXQsTEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSnCxn3usj2enc3OAbjZ/WeLQAXgtxdIQOIybtSOdMZ1OtUKYSf6yaT6dWqzMsxpJIJJN6RalDX7OkropC7vl6GbBzS4hKK9baU38AaDkyODvJLRdF3bNkP+IVQE73K+Te8bYbkMumo7owER0IuC8xQ9NZOOZoCmpPlu9UjPH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBGeMU7K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBGeMU7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F4A1F00A3A;
	Thu, 30 Jul 2026 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422671;
	bh=16a9mSkMBaFJI20KH6QhvGD9o3pWJxbhA+ZUx1rFEvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBGeMU7K2Y/fcRGYUaq8UeHt/waGQEl05qgcTzHFXQaJeetiD132Upyirrq3uMxKR
	 KpuX7W+VnTqUF2D3xsuFA2TSFyeUmYL0ziHNa3DzNrzOrjS9jXeUfvuSNMbGhkkSK0
	 j9AlIOpO7u4bfUdOpCvNqihSgLdEWLdnRhj2u2wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Cawston <ross@r-sc.ca>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 519/744] media: synopsys: hdmirx: Fix HPD lane hold time
Date: Thu, 30 Jul 2026 16:13:12 +0200
Message-ID: <20260730141455.307701459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -506,9 +506,9 @@ static void hdmirx_hpd_ctrl(struct snps_
 	hdmirx_writel(hdmirx_dev, CORE_CONFIG,
 		      hdmirx_dev->hpd_trigger_level_high ? en : !en);
 
-	/* 100ms delay as per HDMI spec */
+	/* 100ms delay as per HDMI spec + extra 50ms to cover internal delay */
 	if (!en)
-		msleep(100);
+		msleep(100 + 50);
 }
 
 static void hdmirx_write_edid_data(struct snps_hdmirx_dev *hdmirx_dev,


