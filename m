Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A341BDA95;
	Thu, 30 Jan 2025 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246771; cv=none; b=PchyF2i3NM35900J4y4dm9jpusJO+tPb3nKP8YGzsx7lheiOdOfFZfG2P6ALRbnSNyJadUE7TNiGqEo71Z7OsTlBl6YSKERvj7wYcXRpkPxrlk8Wy0a1ShDCaKcwLquZTFRPwHLWQsTsciaUaxMKslh2oqrilcjRHttLoiK4Ek8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246771; c=relaxed/simple;
	bh=m50uJK3Y06UYw3i+KEiTOIJd1nFLAuSRrzyhPHt8pLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dl2tuMVgwiIv+x0kMVzkh/3dbREIq0413+fjVYFw4z1oq3j7lRFJ8ODYu8kFbYZBW92AEQOTTuq1WDxEPNiF+vdsshTnCqrbTuoI35ES9m1BdbgtXB4kO+ExMYB6B+/exE7aH6cfC+rUoSW+/OJ2Kf76qcQEBVqJcLXDtcmzrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hX68eTOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX68eTOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C303CC4CED2;
	Thu, 30 Jan 2025 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246771;
	bh=m50uJK3Y06UYw3i+KEiTOIJd1nFLAuSRrzyhPHt8pLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX68eTOW8/ZnwuZAXa8y1aHQ5T9Op6ywj/ZaBVE9/28E4XZ8zsA+D5LyWw1BweRQ5
	 8xUA/W1YdUCrcWa0dhmyEeiVskBEA/zHsbhs2V0NaIHffaFYTjDzB8Vz1h9Cmupe+F
	 qvJVmvwCcdvpwaPuh2TdJPxTY9HwZg5kFe+9SnL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 62/91] i2c: mux: demux-pinctrl: check initial mux selection, too
Date: Thu, 30 Jan 2025 15:01:21 +0100
Message-ID: <20250130140136.170091205@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca89f73394daf92779ddaa37b42956f4953f3941 ]

When misconfigured, the initial setup of the current mux channel can
fail, too. It must be checked as well.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 45a3f7e7b3f68..cea057704c00c 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -261,7 +261,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 	pm_runtime_no_callbacks(&pdev->dev);
 
 	/* switch to first parent as active master */
-	i2c_demux_activate_master(priv, 0);
+	err = i2c_demux_activate_master(priv, 0);
+	if (err)
+		goto err_rollback;
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-- 
2.39.5



