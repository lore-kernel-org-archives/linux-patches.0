Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D93D6CCA;
	Tue, 21 Jul 2026 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673544; cv=none; b=ifHcH01w0Upz5E4xkLE11i1Y2EFI8lAgQNReuo43nHtGOvZDV0DQVKUNPxk/8/z8QcDvLbM2AzZ5sR449NPm/f/2EcHVECIFIvO9s1Ci5aq4OTB+brXUh6OR7TeYRN4+dwQccsNRm+D/Og2wubyrJhOVqyRWJKzh6VYAMg9Htf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673544; c=relaxed/simple;
	bh=PQZToIvFeQMgiRcV034YvtC6qe74sOJXkMu/Uf+BRJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iszsdBay1zqH8/dPmxSQhs90jZw9GngoKPQRv5gHPt4/fNyHbQGTbfkJjkRFmktgnYSJLo7Hptpb2dOvT6zyPeHZSRtN5sFMSSPeJ7yIblQVOqbcSQMg5WMltqgNw0G5dxkwzNM+o1VSRsqhQ0FPhfjxvcNtDnw3ZVL2idWcvTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2idgo4Nx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2idgo4Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE1C1F000E9;
	Tue, 21 Jul 2026 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673543;
	bh=fTZ1M72ySlJo7Mf7ooZeSYbk0HHVI9YaN6uLRlki9ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2idgo4NxYx5d63+1lWlhslq6s5e3zUnpKEfzOg+9pl8huBbzrbVhdF8Pt10QbwULU
	 i/D8fauYxmojEPzkyx4okoJWWMfn/5rgB0MMHaPlQRS1RzlQTeEDi1IlLavuwj/76U
	 UfSTXdC3dapzrSfFj6/xqUxCtr/U9ZGgh/LsM5jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/699] ARM: dts: am335x-sl50: Fix audio bitclock and frame master endpoint
Date: Tue, 21 Jul 2026 17:18:54 +0200
Message-ID: <20260721152359.647980080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f4684c8eaffef2..b65dc5c0826a58 100644
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



