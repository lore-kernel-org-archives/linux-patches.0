Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07776F2FE;
	Thu, 12 Dec 2024 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025308; cv=none; b=Z+3X7meK8mx86HrdmVyXOPSNzMdymN9pjx9vbnBaVeyBRCKIKrDNQKRadPK7gftAPvDSco9ZzvWP5AC5quKhRWKfSspxixwXIEUIO3vgH1MVYDqQqiB8nsgWLkgXPtC8CmGDT3xXp79NcNfWYUPDR8axzZ0fi87B5bNJPzErAtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025308; c=relaxed/simple;
	bh=kDrsaTU66xr0BKEdPVTdBaQ6GwWrwsHJY+hEJ3fkjrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeYulj4fMnmBhFubSLu+JlNTPaJK/Hchi0fc5RvOn9+YndfRChcrYSRQrAOwIwT+Ma8fWBvkx2CgYcFHTZX2nEYWzbmXn8/lvV/MrKAuPnWPb85xqJxbqL5pL2rFblttQKiQFNUaWgRiWI7XpuOFSOfK3LdnIrWUgm2CcpG+FfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvZ5IlPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvZ5IlPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37472C4CECE;
	Thu, 12 Dec 2024 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025308;
	bh=kDrsaTU66xr0BKEdPVTdBaQ6GwWrwsHJY+hEJ3fkjrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvZ5IlPTSLy+9cKXjZjgTXfh1yI/Db+Srd3CXndt7eZ32Zz+cI/a/TT0FomzMvAte
	 Hpap1tGZ3/HKKdYiXJ+1PCC2k33pEkLDHz4bVwpgCLuO6wIvAQx5uDJJwfn33+Vyu0
	 94GBH8p2piePsgLH5MbQ53vF7cJXY0K4QUKsst5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/321] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Thu, 12 Dec 2024 16:00:44 +0100
Message-ID: <20241212144234.954673068@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f6da4553ff24a5d1c959c9627c965323adc3d307 ]

The put_device() call in power_supply_put() may call
power_supply_dev_release(). The latter function does not sleep so
power_supply_put() doesn't sleep either. Hence, remove the might_sleep()
call from power_supply_put(). This patch suppresses false positive
complaints about calling a sleeping function from atomic context if
power_supply_put() is called from atomic context.

Cc: Kyle Tso <kyletso@google.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 1a352462b537 ("power_supply: Add power_supply_put for decrementing device reference counter")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240917193914.47566-1-bvanassche@acm.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 2d6836b33da33..606e21fe599d2 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -479,8 +479,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
  */
 void power_supply_put(struct power_supply *psy)
 {
-	might_sleep();
-
 	atomic_dec(&psy->use_cnt);
 	put_device(&psy->dev);
 }
-- 
2.43.0



