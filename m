Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298BF44AB7F;
	Tue, 21 Jul 2026 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668854; cv=none; b=VWtFSbd7Ppcty0UAS+iGYFU1RJBLlKHLn/KC8e1L65LysjDsUORjplGLC1BA5sonqa8l8bb/uyqjky3//FlQ2DuyVrYKcHXKScpzkX91S2hMEZhgxBpKSez7D7OFrmHxmHI8WIVfuW99U8xPgfhWZ+LXamPtYC6yKo0ZGIblGUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668854; c=relaxed/simple;
	bh=bAb8M2ue1Spc9HKoZdC7hTrjU9u3a0Y3FHepo1XTMA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaWu9Dq73k1OBx0e5bUXmC5CgOcO5RIW2wJzEu7MCwQZrzDsULJHgQ85OHd8DUfQa2CiYzKAK/mbHcTqKYhuMnGD/r1WgMdsP7zxjSfjmgSmRRW0Pp/mEtQ77+BSfJpjFClIrHNW2UoO+pJwXnMF9FWiF8Dzq0c2UIs1PTaTMJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBU24PDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBU24PDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B841F000E9;
	Tue, 21 Jul 2026 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668853;
	bh=JLPxj4foCrDcu+BbcU+dt+x1dXWl2KRw5M8RIvYw5No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBU24PDBUBG4vCMN+4TQzN4Nm6xdu34jumyExrDJzvYAhEJrRCmmDe3KVV4Zj+Go+
	 CUttrgoHbMNEhOPasNWjRxgPXfyRxQl1KiAUgaa3aGYi5uWx5dUWU6LdeziRrk3qXy
	 HDoZC1y//aY1ud33k6yPboKcr0kbptlOSB9QWFjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0290/1067] ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
Date: Tue, 21 Jul 2026 17:14:51 +0200
Message-ID: <20260721152431.091105245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/am335x-sl50.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-sl50.dts b/arch/arm/boot/dts/am335x-sl50.dts
index 73b5d1a024bd1d..63f604005adf3d 100644
--- a/arch/arm/boot/dts/am335x-sl50.dts
+++ b/arch/arm/boot/dts/am335x-sl50.dts
@@ -557,8 +557,8 @@ cpu_endpoint: endpoint {
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



