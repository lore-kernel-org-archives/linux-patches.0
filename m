Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C453296D1D;
	Mon, 12 May 2025 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071828; cv=none; b=nW5CXEXlFBrXvOzoPvxIG2KHGUdeqR6yPfgqqDlclr/0dDpxgHDV3I37ISIEdwNhQx/YMwHIrx1lSwiZCpNG/NiyVRW05mRBwVSlM2fSWQZo1dlQ4gX/qFxRB8mfiuApjTenXvJbx2E/4+SoESfJQMCxn4/GHp0CNKi4UewjKFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071828; c=relaxed/simple;
	bh=gB10e72TQdTkaBv57ZwYUL04PxI/N1mgP1xZE19w1HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty5Hagz5iuq7G7kOvbLYYeA2Y982tKlglfAopQDx1EnS4GhFATTYUUfgC7VoG+q/b7uNn3w3IjbRkJfs856oFozAjsdreF7jPwAtXdvUvZaymL2Nps1N2YX3OXUaZUQhssVgKt6qdKozoLpBZ8AFM1msNPM6uaiCQWWuXOmDvjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOtxG1OZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOtxG1OZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C7C4CEEF;
	Mon, 12 May 2025 17:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071828;
	bh=gB10e72TQdTkaBv57ZwYUL04PxI/N1mgP1xZE19w1HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOtxG1OZLG4oy+ICb7VIDdOi1C/r8WNnXi0um6Bn6PL3/YahAdYHOs+Ydms/tTgja
	 XBcJTOaSpzZdHdrpoWILOYb06SlbMeJxPOhh1mWpEihZBf17UPU+r3ywnfhrwouniX
	 6xLfnfJVaLlf2uw1AY2v4oHB5EfTGdrdetRcmKRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 043/197] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon, 12 May 2025 19:38:13 +0200
Message-ID: <20250512172046.142054281@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9f34ad89bcf0e6df6f8b01f1bdab211493fc66d1 ]

When VLAN filtering is off, we configure the switch to forward, but not
learn on VLAN table misses. This effectively disables learning while not
filtering.

Fix this by switching to forward and learn. Setting the learning disable
register will still control whether learning actually happens.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-11-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 118457e28e717..0c79c6c0a9187 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -383,7 +383,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
 			vc5 |= VC5_DROP_VTABLE_MISS;
 		} else {
-			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc4 |= VC4_NO_ING_VID_CHK << VC4_ING_VID_CHECK_S;
 			vc5 &= ~VC5_DROP_VTABLE_MISS;
 		}
 
-- 
2.39.5



