Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39421657C7;
	Tue, 23 Jan 2024 00:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971508; cv=none; b=JcLqkUiVmApzMcvJhDyZ5pSKKElBcQ0iMib/QMemrq1ym/USHh44QqA3j2scmtZZWe/WLvEs1D65SZY3Ri9pkLvVlr7oSMJ+j1jRyLyG7OxIBWrRIClTeM3rJWf5iYFiLCayqsfbq0Pl+rXp9ZUcUw8qvEbMxNcTNfXdtCC4FRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971508; c=relaxed/simple;
	bh=8Lhdt5BTFOaXCFewjpCr2wEyz4gIo0ZyUgViOvIz6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4skm8bVUoubXnMTp9JqywBysp/Wf1DAKCY12L6Bey1JDV+uGYME+x2VxyujxCF72qgMGme+fGtFtRNtNeIH15+4IubzKxQvZqQ8G7Lya6kSx82/wn5+6h1P9dWoc5/b+PiyJ2Q9ku5ZP2xx+P+kG9efDjmqLQibCan9BYA4O7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ee6OjS0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ee6OjS0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6562C433C7;
	Tue, 23 Jan 2024 00:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971508;
	bh=8Lhdt5BTFOaXCFewjpCr2wEyz4gIo0ZyUgViOvIz6z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ee6OjS0LMyH8NaOntYyUVUbe7ZFKuuiuyYlAY86pb/J75+nvURX0LuGCSZ/KhZJKg
	 nHNqoTPyMuSHuRvOqztRXcoVdKT3ZHqJGiCQC+N9eYnjH+PltYkDwmZmvgnR9HB8HS
	 LI4ccnwhRW9HxV60iApoSfGvbg6+3usgXB9He8u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 163/286] drm/bridge: tc358767: Fix return value on error case
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235738.445710116@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 32bd29b619638256c5b75fb021d6d9f12fc4a984 ]

If the hpd_pin is invalid, the driver returns 'ret'. But 'ret' contains
0, instead of an error value.

Return -EINVAL instead.

Fixes: f25ee5017e4f ("drm/bridge: tc358767: add IRQ and HPD support")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-4-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index b4f7e7a7f7c5..9c905634fec7 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1637,7 +1637,7 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	} else {
 		if (tc->hpd_pin < 0 || tc->hpd_pin > 1) {
 			dev_err(dev, "failed to parse HPD number\n");
-			return ret;
+			return -EINVAL;
 		}
 	}
 
-- 
2.43.0



