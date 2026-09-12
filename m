Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0F2D739C;
	Sat, 12 Sep 2026 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219002; cv=none; b=XWidKPdT+yrqfcLgZ2KRK0j3hQ/ujSeBgn53Xg5FT3fPm4/jLNMLtWshHHF6rBhUiFF9Ub/Ur3tDKxDBp6rZWGuyd2aenGwX1XGR6DUkDN5q0ud6IMZtvOVzM6SMdOScWmppUY7AnnkFBydjZWmhtyXsQ6efIfgi4tfWEJTlvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219002; c=relaxed/simple;
	bh=RoJhjGmz9hHoLmnC1OSfy70OYRc6wVEpaiqQo0d+sjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+F29pa18HYfjm5kDSDnGJvTvHJuknZEJYjclqULJzYvsjtRDljoUwKyZoGMF8JpK4bXoA9CUPzaMWbv5Sjw5HdAhvqnDXAvtcTkkWSpb2m1hxKj0GUFUz2ZyegV/WttarQLJxz/T696IoXeuQDTs1QuTftF5xYYu7BurG1wahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHSomKQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHSomKQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8121F000FF;
	Sat, 12 Sep 2026 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219000;
	bh=sw+UgXu3zylNURjDk+aWeAPaNfLQg77z0aww1Nj9uvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHSomKQz1Gsh/G81ggjqv0UHl/buUh6Oo7n5H8lfW7sw0C6Vb8lChLuQttYUEgO36
	 cVWqXlnTi783amuUnxOIVLA91T3WjX8m+uviBU8FeOVoO0oHXe5uizB2vx9Jc/dxIQ
	 WBCBorkCdhs4RO/neBcM6X4bNU8yi5F39GRh528Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1262/1376] bnxt_en: Fix call to hardware monitoring event handler
Date: Sat, 12 Sep 2026 09:01:28 +0200
Message-ID: <20260912065635.669306786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 669d24ba0e87f..a53815bbe2725 100644
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



