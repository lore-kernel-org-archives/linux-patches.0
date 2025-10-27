Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD84202963;
	Mon, 27 Oct 2025 19:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592865; cv=none; b=NvcZk8jU45aP+lj3azDzHPj/4yoM6rqyfMmablEFA3YbCWsEd+tMwbjB8awygya+trFUPMPwJWnc3WJ4fSH6b4imCFdKT8ja2diWZlZ9OmTuOnXDoU/95Zd+otkAyPcV8FcXP4CXgZTfReR7m/8EliOUBBR+VTVHWMtBphIo6jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592865; c=relaxed/simple;
	bh=v/JGEWkbkylg9YOCSaGx2tgozCZVY/aLQb7iUW5jcQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUpjS+p4evMEoSZTuutdvrxEG/T0pZ2CUAvAaQEIn6QXOeejYianZJ7yLNCgGr2D1+HORB+uQReRxUpUvLs2qG5Ci6p54G73Ak26jfJpR7aPXF32noCehLJ8uAIIhcsbJV9oAV6tTIhx5vZ4mWm4ImRRUKtAPs0c013ThYLo7Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1ZfahUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1ZfahUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88C6C4CEF1;
	Mon, 27 Oct 2025 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592865;
	bh=v/JGEWkbkylg9YOCSaGx2tgozCZVY/aLQb7iUW5jcQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1ZfahUQkwneasmIrg1IMrZzt/BFQyogvRCn5AXIzj0mv8Xdsp74lLb6vlO4D/mus
	 OIlS7ZxCGIhm3DLuUHIjkgqzPQy8zWnvSLJYE+KRd3AsoG9wLW9XpLvRLsaz7rmvsP
	 JTPGv0QKcoMGQPSagBBrbkUABk7SYDCa2t5BfjbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/117] net: phy: micrel: always set shared->phydev for LAN8814
Date: Mon, 27 Oct 2025 19:36:08 +0100
Message-ID: <20251027183455.125403774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 399d10934740ae8cdaa4e3245f7c5f6c332da844 ]

Currently, during the LAN8814 PTP probe shared->phydev is only set if PTP
clock gets actually set, otherwise the function will return before setting
it.

This is an issue as shared->phydev is unconditionally being used when IRQ
is being handled, especially in lan8814_gpio_process_cap and since it was
not set it will cause a NULL pointer exception and crash the kernel.

So, simply always set shared->phydev to avoid the NULL pointer exception.

Fixes: b3f1a08fcf0d ("net: phy: micrel: Add support for PTP_PF_EXTTS for lan8814")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20251021132034.983936-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 92e9eb4146d9b..f60cf630bdb3d 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3870,6 +3870,8 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phydev->shared->priv;
 
+	shared->phydev = phydev;
+
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);
 
@@ -3921,8 +3923,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 
 	phydev_dbg(phydev, "successfully registered ptp clock\n");
 
-	shared->phydev = phydev;
-
 	/* The EP.4 is shared between all the PHYs in the package and also it
 	 * can be accessed by any of the PHYs
 	 */
-- 
2.51.0



