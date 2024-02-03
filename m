Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725D6168D0;
	Sat,  3 Feb 2024 04:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933876; cv=none; b=WSvNfqUvmJprMEBJ2EznJk2aSqw9WCiVHPWh7URb5j+9qWglT+VwTOBGLyR6x+6azg56ly+2UgzxBpQEelf60Eaktgwd5+MXYiA5QVTIzpk5NXjoy7iITBp5Yi7dHyU5ELF479FQuKyDLSlh6uxBv05msD1yBPlti0LSLD3qFGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933876; c=relaxed/simple;
	bh=kkq6D/SeSIhycZPVBlgtWgrDXQ/vchcW/Waw4mVqju4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpxjfmI7limu0i/YgycdjULy2chcAsO5RbiW0kIJl25iGX/apeOYwXx8GL5Yd1rVmch1oZYAjMHdiERGRljhHciIVjzaNYTrtWtYA8OOaxQEiWPqSR8phne2tZ/C4edmUbjXeWA8AK9XYhSmXkMamAiV6pdwyATLSXonqWiYydE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iik/zIEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iik/zIEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8C7C433C7;
	Sat,  3 Feb 2024 04:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933876;
	bh=kkq6D/SeSIhycZPVBlgtWgrDXQ/vchcW/Waw4mVqju4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iik/zIEnDOe2n4xXwFgOajgmQXv1rRPMlQO/gDrwduRpDMza49o0SUhozXWWa1EPQ
	 szeLlP5rlJggTHv3ythQIoZyudnk28aj34n941TmN1pl8x54oMjZDVbu6iBNxZ9AD4
	 mYzPCGOUOkYWs1n08a9d/v5pd6RtTl1aD8ZlpbCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 215/353] watchdog: starfive: add lock annotations to fix context imbalances
Date: Fri,  2 Feb 2024 20:05:33 -0800
Message-ID: <20240203035410.489860835@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit f77999887235f8c378af343df11a6bcedda5b284 ]

Add the necessary __acquires() and __releases() to the functions
that take and release the wdt lock to avoid the following sparse
warnings:

drivers/watchdog/starfive-wdt.c:204:13: warning: context imbalance in 'starfive_wdt_unlock' - wrong count at exit
drivers/watchdog/starfive-wdt.c:212:9: warning: context imbalance in 'starfive_wdt_lock' - unexpected unlock

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231122085118.177589-1-ben.dooks@codethink.co.uk
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/starfive-wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/starfive-wdt.c b/drivers/watchdog/starfive-wdt.c
index 5f501b41faf9..49b38ecc092d 100644
--- a/drivers/watchdog/starfive-wdt.c
+++ b/drivers/watchdog/starfive-wdt.c
@@ -202,12 +202,14 @@ static u32 starfive_wdt_ticks_to_sec(struct starfive_wdt *wdt, u32 ticks)
 
 /* Write unlock-key to unlock. Write other value to lock. */
 static void starfive_wdt_unlock(struct starfive_wdt *wdt)
+	__acquires(&wdt->lock)
 {
 	spin_lock(&wdt->lock);
 	writel(wdt->variant->unlock_key, wdt->base + wdt->variant->unlock);
 }
 
 static void starfive_wdt_lock(struct starfive_wdt *wdt)
+	__releases(&wdt->lock)
 {
 	writel(~wdt->variant->unlock_key, wdt->base + wdt->variant->unlock);
 	spin_unlock(&wdt->lock);
-- 
2.43.0



