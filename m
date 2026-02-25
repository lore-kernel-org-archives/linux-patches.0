Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4760D248881;
	Wed, 25 Feb 2026 01:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983492; cv=none; b=iiRa7W3SF9QuNVQyY8/13xV13AwHd875rmYrebNcSvWybEFOzmo/YJCACEFlHFl24jyRBZ0vfMZHEwHrKriXWoMiEn/luCs0VAdH+Oa+dCqOpjuu+ojDI2IA9Or2CLOBiKhO2D7YugSMYfQzN2/kCr/pMXnP9O+zws5GHKVFSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983492; c=relaxed/simple;
	bh=5LIlLQBqolqsT01MwMxlmDKq17AbO2Cb5mSqT4qSPcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tnh8SfEcMvRWn7KHW/T//vQKfxhXGzHoWyr7dzBfU+Xb5twozjn201hdjz+kQM2ZvVaXU7fpNZGLAxNrM6WX+O1NZlNdWhmjY+9eTmds17kfcIpJrfQ3CsP2B1ECzOBYUf3rigXyM73ti6pXqu9jvbY5FSbWMcwp2vF4QrqVnyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUpX3ynK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUpX3ynK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B49C116D0;
	Wed, 25 Feb 2026 01:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983491;
	bh=5LIlLQBqolqsT01MwMxlmDKq17AbO2Cb5mSqT4qSPcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUpX3ynKUsuTwBlxNrjlK/keKkR6TF7xtNW59i3ACq/sXo3k20lF+l51qGXBTNKCu
	 4r04gqEdlWoAS85qovWUjU8DRgKZVVtY08VGnHm/S2X3bE9a0gMkLz0YjOGevsgro9
	 CJ+bWm+KGK9pYr3tR3Rqbc1WfF6L6zdeXDetfAD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 576/781] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Tue, 24 Feb 2026 17:21:25 -0800
Message-ID: <20260225012413.928205529@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit aced969e9bf3701dc75cfca57c78c031b7875b9d ]

The existing 1ms delay in sd_power_on is insufficient and causes resume
errors around 4% of the time.

Increasing the delay to 5ms resolves this issue after testing 300
s2idle cycles.

Fixes: 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260105060236.400366-3-matthew.schwartz@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 4db3328f46dfb..b6cf1803c7d27 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -937,7 +937,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(1);
+	mdelay(5);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0



