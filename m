Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9314350820;
	Tue, 26 Aug 2025 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216384; cv=none; b=mhcBzk+RWTXeZ2XbakaALCVJMueH4p46VUIQuyeaHl0JYvuVg77nhqvWXIF4oXB4IEOHPH+j1TJPe/F8c8PRq1qR1tcoOrql5HDP5LpyLEaLkxsXxOjgOcVGloEA3iostCE9d/EYcK/YZ0u2Y3bwEA+jFGJwzNyEMeFRtPFZZLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216384; c=relaxed/simple;
	bh=2p5xWN40606tJVQ64ha9ImZrRDDgoh9WUq7ikEHk+kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcRrAPJ9Mr37oXyPtdDFkQqQwDKWAM/i4a6vcK2eifSrSLs1uO1STGx13O1qVPEF2yPjpWFx9M6IvBnmVDo3j4iVeHNvMptxGAfBg/k2ZTyZtYhVMr10IB8MRaxdYiZSUqrv2S85mIAEFPMq0ItRn+nOcQGZdxSe8nCTRfCFcNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMWA8KBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMWA8KBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE6C4CEF1;
	Tue, 26 Aug 2025 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216383;
	bh=2p5xWN40606tJVQ64ha9ImZrRDDgoh9WUq7ikEHk+kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMWA8KBuSdgiYjCArlIVrieNjni8xt3bUIVz8ZGywkxwEBHkeJ6r9popTL7PY6TXO
	 7rdR6sc5EbWiiZhV34eUHSPWc8SmR63rgeQFvc9Wy//Aj01bejn/GshBMC0IWHXK8V
	 DeAWQDD5i9Ckd6igEykitdObjP4iFt+h99mycR6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/644] watchdog: dw_wdt: Fix default timeout
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826110956.080056143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit ac3dbb91e0167d017f44701dd51c1efe30d0c256 ]

The Synopsys Watchdog driver sets the default timeout to 30 seconds,
but on some devices this is not a valid timeout. E.g. on RK3588 the
actual timeout being used is 44 seconds instead.

Once the watchdog is started the value is updated accordingly, but
it would be better to expose a sensible timeout to userspace without
the need to first start the watchdog.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250717-dw-wdt-fix-initial-timeout-v1-1-86dc864d48dd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/dw_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 498c1c403fc9..7571fc2df541 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -660,6 +660,8 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	} else {
 		wdd->timeout = DW_WDT_DEFAULT_SECONDS;
 		watchdog_init_timeout(wdd, 0, dev);
+		/* Limit timeout value to hardware constraints. */
+		dw_wdt_set_timeout(wdd, wdd->timeout);
 	}
 
 	platform_set_drvdata(pdev, dw_wdt);
-- 
2.39.5



