Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DB826157B;
	Mon, 12 May 2025 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072507; cv=none; b=rNbABdUelaLdNw3rquiTEYHo41RLp8omP9aVEjs7/lP3F8ZvbUCM0uG4gSx2+8f4Cd5hfr9Lc9XXVRP/839wxWz8pF/1pV4djyoVbRQc7+p2UXnc9/tz7V9l23D5DTfB9AtVOa4rioyVHj4xjPOVtOVeb17ThiAQbB5QXUpxFs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072507; c=relaxed/simple;
	bh=35/Ct5Wb+XyiLUmEmUlOrLnK+ARfnX3RWWXwQju+6yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwTNy5fC0TzROnA8lhcEIZq76cfs+LgiepXCOyc54FpCpoZJuT1OKF0sFC2tBINxz9XfrIBalES0noeT/9L6etvah1BJS7HAyd8Q+Gnam2bL8OCrQ1MpKfva/wLLFzgfuGFh1oDMr7kUjNkWgTGUnONMpn8OnnIgmQbLXby8kjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/BBhnNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/BBhnNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26630C4CEE7;
	Mon, 12 May 2025 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072507;
	bh=35/Ct5Wb+XyiLUmEmUlOrLnK+ARfnX3RWWXwQju+6yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/BBhnNWEaYGSRUj82jr9IQamlbg2rA+xn8sZoE+TKvr+ilUw8h16ELfWEpIwJfea
	 wa//+jSnjBiDic0wq2Qwxk0iHMM/HGlnHCKcqlnJTSV6N2+LThWY57K2oKXe8aqoaL
	 R7+Wx4wSSaSXmfZSkAqoTbAIM/FmXMldHX0g88B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/92] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon, 12 May 2025 19:44:57 +0200
Message-ID: <20250512172024.025190955@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d410c21416f9..1a23fcc0445cb 100644
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



