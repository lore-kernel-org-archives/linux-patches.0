Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F68E330B00;
	Fri, 17 Oct 2025 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716037; cv=none; b=PxFmy+jfyx+Er3XOJ1Gau8DLcu6uwij24gFK/ghS41SowoUPAVFiDqAmVNJSy/76LnOpTNHtW6scpfbCrotuHyNCNEzkBJtzbEdPCOPwNhYGpmjx44YZO6q5N5DGRqCZnm2634O3G0wLqInWDELG4yKgb6Tjrbiis1qnwVlyyXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716037; c=relaxed/simple;
	bh=XzXA3dmPD/LdSVzNodWtUXdjuocevYE07gpcgjCjMS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSWhTqZ84D0p5uIPdM+ldUje60IWUzhcuQXVomh6zYOylvUBQu/5MWTGAkpimU5HTR6TV4cOkb8ZS/VRRAyPrcdOXrT3cZ2NGPqZk3YRyATqtAmQJWIpA5tj3noJQHNB+28vt8vUAwtRWxfc1cUPKTf7pFDiPRnTNedD9XRFl/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QauDBqtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QauDBqtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3BEC4CEFE;
	Fri, 17 Oct 2025 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716037;
	bh=XzXA3dmPD/LdSVzNodWtUXdjuocevYE07gpcgjCjMS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QauDBqtNrmT98UAZrv/nYQtzepYXVwr326BKrqhyMEQuMF0GwIngDcqQCxGKjPNL6
	 NOYFC4/F8DFZUwh4s8xl3htvVY4XuZDFaf1s7Ff++DBAszRAt4SIIg198IMg7M4PQd
	 eqLksYLeO3oyZRimhWE7pJvbftUH4JGilKUQBb+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/276] i2c: designware: Add disabling clocks when probe fails
Date: Fri, 17 Oct 2025 16:52:25 +0200
Message-ID: <20251017145144.388443002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit c149841b069ccc6e480b00e11f35a57b5d88c7bb ]

After an error occurs during probing state, dw_i2c_plat_pm_cleanup() is
called. However, this function doesn't disable clocks and the clock-enable
count keeps increasing. Should disable these clocks explicitly.

Fixes: 7272194ed391f ("i2c-designware: add minimal support for runtime PM")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 718bebe4fb877..09fcd155c6410 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -322,6 +322,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



