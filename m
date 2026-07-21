Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EA46AA6B;
	Tue, 21 Jul 2026 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648204; cv=none; b=ItABQVppYk/CGWovUB69i1/jHhcdsx4yzXh7KZIKsM1X7IF77vv20asWqJita/hbxraJ2mmT3m0H9lnEJIi7wYkapcW52cLzrzySfWaZbpKBzhKsvUV0Dixrl7DDR4jF19O8Bzngxzwjfpwx+GVVT1/JxRYrSOguAQSJjBh0xFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648204; c=relaxed/simple;
	bh=2gxr6R7WTJMDw2iGLGfMgZN39pfL8/4r3H+rWXmUHzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnPyHxlCAzdQCVYHC8W0xLhkm0EuBvOBab1+h1U/KEU0geOw57YWsy3cx9jCNBoxHf+fx/FdRBgaMwt5iFatG7RXuYUCwiF9mpqiMKU8K2363yHLAGV5y/YIMKd8MJD3eNKLlBCF3QTAgIwh9sfgdTVpbyyBuOX2Ni1E3qjBwp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFlRBfKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFlRBfKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9D81F000E9;
	Tue, 21 Jul 2026 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648203;
	bh=Yy3tU83hGf5EBTgSg8aW+M40+9QhbilaD4PF1eVl68E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFlRBfKjipLjbO9ca/xx1HMxMVZ+2u2VMYMQtJ5RnnuoRk8jKd0Q+7lNV0Qh5c7t6
	 YjNMkbICBRWCeW/FRbbzG7dK2GKW682ZiMIe5M77W2pAFvmTZemNjioQ3Pi/2hSzbB
	 BNhmZJtAZeoPMDFbmzmBtOKmy7JwpH8S84Otgw78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0111/2077] ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
Date: Tue, 21 Jul 2026 16:56:24 +0200
Message-ID: <20260721152555.314102271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 2bc564f46b00dc4f4331fc337277ff3f5fac8a4e ]

The cpu_endpoint in mcasp0 specifies the TLV320AIC3106 codec as the
bitclock and frame master, but the phandles point to the codec's port
node (codec_port) rather than its endpoint node (codec_endpoint).

audio-graph-card calls simple_util_parse_daifmt() with ep_codec set to
the endpoint node (codec_endpoint). The function resolves the
bitclock-master phandle and checks whether it equals ep_codec. Since
codec_port is the parent of codec_endpoint, not the endpoint itself, the
comparison always evaluates to false. This causes the mcasp0 CPU side to
be silently configured as bitclock and frame master instead of the codec,
which is the opposite of the intended configuration.

Fix by pointing bitclock-master and frame-master to codec_endpoint.

Fixes: e5f89dbdebc5 ("ARM: dts: am335x-sl50: use audio-graph-card for sound")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://patch.msgid.link/20260325223411.123666-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-sl50.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-sl50.dts b/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
index 1dc4e344efd63e..c5259eb7d21c7e 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-sl50.dts
@@ -558,8 +558,8 @@ cpu_endpoint: endpoint {
 			remote-endpoint = <&codec_endpoint>;
 
 			dai-format = "dsp_b";
-			bitclock-master = <&codec_port>;
-			frame-master = <&codec_port>;
+			bitclock-master = <&codec_endpoint>;
+			frame-master = <&codec_endpoint>;
 			bitclock-inversion;
 			clocks = <&audio_mclk>;
 		};
-- 
2.53.0



