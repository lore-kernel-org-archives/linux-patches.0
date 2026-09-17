Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E5254706A;
	Thu, 17 Sep 2026 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666412; cv=none; b=uLnWtHAiLE4FFSB9bDlfITHM8LixPK1Jv1/ctNY+zC3YZ+g5PnAQhboNAW48OvKh6OyxpFBB08svqrvz7nsxMdGA2q3tB98oQVSUsR9gTWwBoz6fx1wAkzCdQZWEjcH4MX5tHRFLVHm1vca+NZF2IzUpNKJFpakWnUoYBChamXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666412; c=relaxed/simple;
	bh=5EmOsecXoI2OruM3Gc3T9pqMrJK6JmwAgfkvmjKemk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxlliocP2AMoPE6Ky3INOIOjiLedhtyMfXp6KoMDNyKMiY2xvYQgjk0GE0GVZ9VF01kMuRcANvb826nf7HDyEVSXkP7W76RjeS3xPTFzRUW4KTu49eR2wGGaLXvhKG7buMMHhib2860kc1CPXTul8AMwnPiGLqDYqSyOSV2M9Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8LXB+sY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8LXB+sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4691F000FF;
	Thu, 17 Sep 2026 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666410;
	bh=fXEX4YlbAr9jO8bTNCLW4wNV9GB/cGWI16QhszX2KO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8LXB+sYdoKX0BlsNjNS0Dq7PIboQxnEiPhsJ+D2NKdm+nhEUbrj8mbAFJVB3Qq0v
	 p8rhuQp3dNApRukwqszH8Zmjc9XZgduikxmUxL7H3lKgo0mlfeh8X3dJ9ALfVfMSoM
	 jqPSzDUGCjRkDdToO7UTxiBhHdFlbFpzGlsG0L0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1021/1250] net: phy: dp83td510: handle the active-high LED polarity mode
Date: Thu, 17 Sep 2026 16:13:36 +0100
Message-ID: <20260917151619.728542879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 6ca81bbc31cdc964e4b74d17b86215d4a810a56f upstream.

dp83td510_led_polarity_set() only recognizes PHY_LED_ACTIVE_LOW, so
PHY_LED_ACTIVE_HIGH falls through to the default case and returns -EINVAL.
of_phy_led() propagates the error, of_phy_leds() drops the LEDs registered
so far and passes it on, and phy_probe() returns it. A device tree marking
a DP83TD510 LED as 'active-high', which leds/common.yaml allows and
ethernet-phy.yaml references for led@N nodes, thus leaves the mdio device
unbound, so phy_attach_direct() falls back to the genphy driver, which
cannot drive this 10BASE-T1L single-mode PHY, so the interface has no
usable link.

The callback initializes polarity to DP83TD510E_LED_POLARITY(index), which
is the active-high setting, so the request is already satisfied and only
the case label is missing.

Cc: stable@vger.kernel.org
Fixes: 5b281fe7e396 ("net: phy: dp83td510: introduce LED framework support")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260908105959.70453-3-donggeunyoo.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83td510.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/phy/dp83td510.c
+++ b/drivers/net/phy/dp83td510.c
@@ -380,6 +380,9 @@ static int dp83td510_led_polarity_set(st
 		case PHY_LED_ACTIVE_LOW:
 			polarity = 0;
 			break;
+		case PHY_LED_ACTIVE_HIGH:
+			polarity = DP83TD510E_LED_POLARITY(index);
+			break;
 		default:
 			return -EINVAL;
 		}


