Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F81F420868;
	Sat, 12 Sep 2026 08:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202415; cv=none; b=ruistJdoT2ewaM0Adyh7QeW8d8mwdzZ9w3KdM29G3YpVNaXdIiej1V6gXqySgUO9IW0uJI8AFV380u+03/+tYrPaL9nT3zFMagtWMKmELGwaGj+1m66zsTU0UFkFz3/ET7XbE7SPZ4UYE2mWwP2PSPP7wUT4qme0EzasuWiRoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202415; c=relaxed/simple;
	bh=/PZNHszKtO3RkIgf8COm/syukhRAVZrHGuuauSUknP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxGSfy7wPQK2TuI8tIVkhLOuH2031MISmdllfarFojSzeyNDu0iflYbnKOxOz8Em1MMHWoG4+LolGfLGFXbIzm7kkhELG2cHHB34za3/+5V5/mri4sSkQqG5e16xeswyKpq75xSFlqOITJVtcg9WuHpaZxI2xVHRFtx68SuS3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0bJC4H0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0bJC4H0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4321F000FF;
	Sat, 12 Sep 2026 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202413;
	bh=SQ4bxCjXLLm7mFAssinzQEt3Rq1MUxRGg4AEJUX8wYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0bJC4H0jpPVCiDdxLGbL/SIney3l+c5t6NQRf5WNE9n1R5/hcB7b8mmwRIx9DPv7
	 2YbegnVb13iPJW9NHeA11P281ujWt+NLDHwivRUj+SQXQmTV1UuvccGoSS/+kI1Fxb
	 UjuG4q1wcUu8wcaQptyM3C70NBm42qYG2+8yAbVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1199/1815] arm_mpam: Fix a NULL pointer dereference on unbinding after an error interrupt
Date: Sat, 12 Sep 2026 08:49:09 +0200
Message-ID: <20260912065717.158207287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit fc996c39689bb15aa80e5366809434f7258fb703 ]

If a user unbinds an MSC after mpam_disable() has been run in response
to an error interrupt then a dereference of a NULL pointer occurs as
mpam_disable() sets the drvdata to NULL. Add an early return to the driver
remove callback to avoid this.

Fixes: f04046f2577a ("arm_mpam: Add probe/remove for mpam msc driver and kbuild boiler plate")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index b68f5599e8dbe..59ea62b845c1e 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2023,6 +2023,9 @@ static void mpam_msc_drv_remove(struct platform_device *pdev)
 {
 	struct mpam_msc *msc = platform_get_drvdata(pdev);
 
+	if (!msc)
+		return;
+
 	mutex_lock(&mpam_list_lock);
 	mpam_msc_destroy(msc);
 	mutex_unlock(&mpam_list_lock);
-- 
2.53.0



