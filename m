Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D6F27B324;
	Mon, 18 Aug 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522006; cv=none; b=fz2eFitQG9pTLqoNecNL+HzK/3dS9RY2QyiHMmlRjtLz9FsHtYLz4/N0fF0FG+inGKgRxRHzg5g1glHU/fS+xaPL695lL+r3DwK/vgu0FKUDH3NzxeP8ZjJqaYhyls+ecjR+EIj90U2JKzDoNBzc254nYkHkGVx37s8f2gc7CrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522006; c=relaxed/simple;
	bh=DFy8OvAyX0pD7lU2lM9xzItnluDj8KEqN7i5W5akke0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6MbIpsdbtW5v5IhEkcwlHZiC7N2lWyBz+yXBFoT24zABejUYieTPvJ8Utu03b2mS8YdsKjwwFsi1tu+TCNat71P90dKsDWStFKujM8VWQMTQxwLeYFBmmHnaWEuenK+ImqIFfQPgC4JPkayow5J1VUxRnl1DR4F9ph5u7dezpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THT6qOlH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THT6qOlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5FDC4CEEB;
	Mon, 18 Aug 2025 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522006;
	bh=DFy8OvAyX0pD7lU2lM9xzItnluDj8KEqN7i5W5akke0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THT6qOlHLKxqTTiF5JlQfiw57AjhaJwVe2nUaV4p19rGTRxNXaaLH77G+XXsM1KDS
	 1ab+iEhxyy4+mbod2X8hXtnNfYjiXZrUjDIUhzUP/rTDdUyH5y/B1w+R8wI1DA9Oki
	 F6OsPfgwDq/YPGZBveiVq7EyuvGnob0EaEOHAIvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Michalec <tmichalec@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/444] platform/chrome: cros_ec_typec: Defer probe on missing EC parent
Date: Mon, 18 Aug 2025 14:43:00 +0200
Message-ID: <20250818124454.676797356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Michalec <tmichalec@google.com>

[ Upstream commit 8866f4e557eba43e991f99711515217a95f62d2e ]

If cros_typec_probe is called before EC device is registered,
cros_typec_probe will fail. It may happen when cros-ec-typec.ko is
loaded before EC bus layer module (e.g. cros_ec_lpcs.ko,
cros_ec_spi.ko).

Return -EPROBE_DEFER when cros_typec_probe doesn't get EC device, so
the probe function can be called again after EC device is registered.

Signed-off-by: Tomasz Michalec <tmichalec@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20250610153748.1858519-1-tmichalec@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index f1324466efac..ca665b901010 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -1226,8 +1226,8 @@ static int cros_typec_probe(struct platform_device *pdev)
 
 	typec->ec = dev_get_drvdata(pdev->dev.parent);
 	if (!typec->ec) {
-		dev_err(dev, "couldn't find parent EC device\n");
-		return -ENODEV;
+		dev_warn(dev, "couldn't find parent EC device\n");
+		return -EPROBE_DEFER;
 	}
 
 	platform_set_drvdata(pdev, typec);
-- 
2.39.5



