Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A27435F5F7;
	Sat, 12 Sep 2026 09:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204966; cv=none; b=OI+J/vbwa+b15mAtnzXyupaPcIyqN4USKbJFZjT/Lh1rWxZnh7nmiPqEdmx8fdBTaYkT4DYJ5wp2RpzkY+FK6qP0EsFuW1W2KwREoKmb54R3Ij2SS6jvZpiOiWGxiN57hTh4ziNCly0BrdNDHaSlaat1PXa+xY71V3FB5QN92AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204966; c=relaxed/simple;
	bh=7VZ9C/swWOdgjDnutSifMKLGVHPUqMkhjpE+OXavjJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR1NxwAtLLLYoExpe9fnrZNdYQw7UKnpMBpHCZdRWe21ZnFJ98MWLYNIU4M/RyM37FxtOkhG1AbsDqJ3hj6lDR8gsb3JHeragsC9UbR1J/KJtwDZiFhF1BejXUQeBgHw6QHMrs/Q8ch9SvxHh3DANHkYSqnpM26j8LcazKmJFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4YKZKdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4YKZKdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD11F000FF;
	Sat, 12 Sep 2026 09:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204964;
	bh=daJo92g9XoBWgTl4cV0HhWH2tMi2FXg4yMWjE+mxnSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4YKZKdLQOay4zwUYyM7hHsSGqJdlA6jms6dKlrltubWuM2+AhBCevmSBL862be4J
	 vFwxyEalrhKzU4vjWTprjgcIyjz2P4FnHSjdhrYq52nB88a0eZ4+ylFiGkumA7kNiJ
	 53mxUSZzQjVcfXSyerRP7otHpRFjHan+Ak/vFRBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1694/1815] bnxt_en: Fix call to hardware monitoring event handler
Date: Sat, 12 Sep 2026 08:57:24 +0200
Message-ID: <20260912065728.746989887@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 622d698df4239fef3e0eb51fe59f4198f957f28a ]

The first parameter of hwmon_notify_event() is supposed to be the hardware
monitoring device. The bnxt driver calls it with the platform device as
first parameter instead. This API break results in undefined behavior and
may result in a crash.

Pass the hardware monitoring device as parameter instead to fix the
problem.

Fixes: a19b4801457b0 ("bnxt_en: Event handler for Thermal event")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260821044512.663941-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
index de3427c6c6aaf..faed0cf726e1e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwmon.c
@@ -40,7 +40,7 @@ void bnxt_hwmon_notify_event(struct bnxt *bp)
 		return;
 	}
 
-	hwmon_notify_event(&bp->pdev->dev, hwmon_temp, attr, 0);
+	hwmon_notify_event(bp->hwmon_dev, hwmon_temp, attr, 0);
 }
 
 static int bnxt_hwrm_temp_query(struct bnxt *bp, u8 *temp)
-- 
2.53.0



