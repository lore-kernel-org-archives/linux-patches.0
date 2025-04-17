Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E126253B7B;
	Thu, 17 Apr 2025 18:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913436; cv=none; b=FkVoM7wjxFRAx+kyqgyporDehUqlUnrkRiFz6FPMGnH6v5oLKmruFAklG7Y+tCMrozktQX76C4HsjmYdKvRNUFyL81kyiAlH9LyuXo72+R8HV21GIeSxUixvT9I0dlpj3IqwuApvldqsk4X7i9E/DQSZaw4n6AsD0zNwhcpMYBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913436; c=relaxed/simple;
	bh=cQuP2FwL/dZmc47i1MO7CQIGFEESwmC5o8jwL6yhoW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/JtNV/T8aAO4csuj4/zxfazfw4uY98TeKdBa1+5klhKM9NCsE41385UgeOqRvUEwL5xgiFnIdNIJFoopMrfCr5ELu0l3N7l3wyq7lLwJ3RhVbLDHh7mS8Ir32HkhnCiYVsVEQu/sfuKLZbfwT+UvveMlzmY3t7nsS0RRNbPNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vgHh65S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vgHh65S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89EC4AF09;
	Thu, 17 Apr 2025 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913436;
	bh=cQuP2FwL/dZmc47i1MO7CQIGFEESwmC5o8jwL6yhoW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vgHh65Sgjf7rf2Wzk5elSQy0T4viR3GF3GlbTvdM4koAFhpJw824Pv1J9ydOZt0a
	 pj3eo6pKUVkpw8q/WYkLgW1rpz9rivoRRZOarYVN/nwmQKxZbGZuhqiPtmDVyqUzDn
	 PXgS1qKKQx6897E8kV1TEQjgbL4sMrPNq5/xjQCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>
Subject: [PATCH 6.14 339/449] arm64: dts: mediatek: mt8188: Assign apll1 clock as parent to avoid hang
Date: Thu, 17 Apr 2025 19:50:27 +0200
Message-ID: <20250417175131.838973803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit a69d5795f12b06d07b6437cafdd08f929fff2706 upstream.

Certain registers in the AFE IO space require the apll1 clock to be
enabled in order to be read, otherwise the machine hangs (registers like
0x280, 0x410 (AFE_GAIN1_CON0) and 0x830 (AFE_CONN0_5)). During AFE
driver probe, when initializing the regmap for the AFE IO space those
registers are read, resulting in a hang during boot.

This has been observed on the Genio 700 EVK, Genio 510 EVK and
MT8188-Geralt-Ciri Chromebook, all of which are based on the MT8188 SoC.

Assign CLK_TOP_APLL1_D4 as the parent for CLK_TOP_A1SYS_HP, which is
enabled during register read and write, to make sure the apll1 is
enabled during register operations and prevent the MT8188 machines from
hanging during boot.

Cc: stable@vger.kernel.org
Fixes: bd568ce198b8 ("arm64: dts: mediatek: mt8188: Add audio support")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20250207-mt8188-afe-fix-hang-disabled-apll1-clk-v2-1-a636d844c272@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -1392,7 +1392,7 @@
 			compatible = "mediatek,mt8188-afe";
 			reg = <0 0x10b10000 0 0x10000>;
 			assigned-clocks = <&topckgen CLK_TOP_A1SYS_HP>;
-			assigned-clock-parents =  <&clk26m>;
+			assigned-clock-parents = <&topckgen CLK_TOP_APLL1_D4>;
 			clocks = <&clk26m>,
 				 <&apmixedsys CLK_APMIXED_APLL1>,
 				 <&apmixedsys CLK_APMIXED_APLL2>,


