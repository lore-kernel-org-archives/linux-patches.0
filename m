Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64BF46EF73;
	Tue, 21 Jul 2026 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661488; cv=none; b=Vhb8voJrif4S4thckIjxb+ApNRrt07bw2i2okkzOX7qGVJnH6kI34Inx2aTPwMdV86FV4jjaG9wevvz1ixPANbTNt6FAsr3fDWdZg5BhmN70CbKWbCLM+a6jqc14OXqu+/EUEB5RjET62crG2KVOUXgiKA/gX6s70Quh2xVyY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661488; c=relaxed/simple;
	bh=G8ru5+/hJwXSJrRYlGiLwoHetilxD1WGrDtdNCd5Ank=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdgadxnnPn2qmMFyWmncjdWn+W5n+Rek++IUvZ2bXsXYfwk7TIHbyu+D5fJI0W8PLbVI90IeHp1T03WEhO9RKoKQUOHDqDW7ztFkh+DbICO2N7I43Wae57YmBCcqNJiNBec+712095phovwcGyBh7kF5ICCkvzI1WdjLtUDDZV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NukqjIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NukqjIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDAF1F000E9;
	Tue, 21 Jul 2026 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661486;
	bh=5ZCJvB7QCfmWj6MfmdTvKSZXg5gj93vHgAp4dgAoEJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NukqjIjR1XERcpGmdMX+YmjJiSb0guF9f9MCFW+cvXspqsa+qt7qZubjOSQNKIa5
	 p5uyJFSQJtF4H+IcrLQ74h+SXmxWV99oKShbO6Nefrj2IXy8I50EbrUjcBjERVyC0h
	 uiTnNYj2bKLrp5kxci+ffa8OVY72NhmNy/xXOjRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0083/1276] ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
Date: Tue, 21 Jul 2026 17:08:46 +0200
Message-ID: <20260721152447.952952055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 757ebd96b3f0b5..ccbde00d719c7c 100644
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



