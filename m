Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BE72627FE;
	Thu, 17 Apr 2025 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914740; cv=none; b=Le8zIOMI+G+c7zVnfl+0RgxRp1AUUXGSqtbX9Q8ykKrBQFyX6EVLlX7SGs2nBHs9IjWM/LTKkDChrJKqoXJEhov1yvfNiKS3rZR4AGN8vx6fEC1RHXtUKMzabb5M4qJs4DFbT6wsPTLREcBzmTlk8q5iSGVroK9vCnix9kZW4tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914740; c=relaxed/simple;
	bh=d8ZnmajJTGv0RCytpxERed+T5qJzIJf0GwaEb+lim0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Spqt48r3ugeu3tUXWHGZ4/y79tnidL6mpsFO2nyQ5MHlp1dWLcPce8iyYyldFQe9FpCu8sdez1V+a6IopAENl8pMa/Qzg0bevdGXjLBhNdMctr7dEr99ppT9vtvLm2QlMaG/AY+RBKYdVyhYnt5sIop8esA4LyzFNi5+hGe1HbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2LU80YQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2LU80YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B6AC4CEE4;
	Thu, 17 Apr 2025 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914740;
	bh=d8ZnmajJTGv0RCytpxERed+T5qJzIJf0GwaEb+lim0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2LU80YQEHmW/NOYDzbyxTYe+nhwPA4wWJAy91tV9a3rNtbwXpJPUlRPW15OjRguW
	 Nfktr54Z8Dc+aSI+asfAONGJql+rdNHTlnBUw+8iZm6YlKHj1azRHoyKnTKqIPQOXs
	 hWnkWeF2IfxVFY9pvqD4xm8SNlG4zW5NkozeT37k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>
Subject: [PATCH 6.13 308/414] arm64: dts: mediatek: mt8188: Assign apll1 clock as parent to avoid hang
Date: Thu, 17 Apr 2025 19:51:06 +0200
Message-ID: <20250417175123.824263505@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


