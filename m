Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349553368B8;
	Tue, 21 Jul 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655806; cv=none; b=Io6hGBnOdInJaOLWNdUpNlVaAtrIljsxqTQMAAB0U33U5Q1R1LVavcGNdD4jMFsiVTtVWnUzCaYLsqRkxHMmAvc+OSwLe2+AlHzd7FlekZxffPHq461AtbybOiVTGwZ/wUA2C5j3uZvyeSPaQhLuoc6kuHb8nXvJmY+cA6ug2rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655806; c=relaxed/simple;
	bh=KABRrfZ/Wg7zCK73rREfkXbOlkzG6mMLzuoM3I2bKGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRFRcI1C08+gr8RKwA5tAtFOU4ORGgKX9QWteFm1cjtN/3dZRIx+rBUf1/Gc7wVhPL88UCvtWfrviOsxGPXK085El3DcMGliNpFxhzenp6IGhCnuYq6QK22+bt6jvxYndryKQlo/ilzV4T5qDSbHkVjIz6C1F7rV7qQoWyoDKk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8kcSobi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8kcSobi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9446C1F00A3A;
	Tue, 21 Jul 2026 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655805;
	bh=k/XIgrkc6su2EuLiusOi2WcuhI4rEjdfrnN6x2wC9BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8kcSobi8HVhRaoz7WDZaPdU1RIpL35T8v9IN9Wb7FHg5x+U07yjIiH5f2wH92n9i
	 CQ62s7z4tdeAChussDXGKZiZEQmzhok7JRk5F4FZk2+2JqEF7LgxVwWg9YYeIHgQah
	 BPZ6+9QsdMB5W/b/qL4RFdt6KkM1sR7bHryCvy08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0095/1611] ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
Date: Tue, 21 Jul 2026 17:03:31 +0200
Message-ID: <20260721152516.982199726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



